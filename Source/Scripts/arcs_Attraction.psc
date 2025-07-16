Scriptname arcs_Attraction extends Quest  

string function GetAttractionToPlayerStorageKey() global
    return "arcs_attraction_to_player"
endfunction

int function GetAttractionToPlayer(Actor akActor) global
    string skey = arcs_Attraction.GetAttractionToPlayerStorageKey()
    int attraction = StorageUtil.GetIntValue(akActor, skey, -1)
    return attraction
endfunction

function ChangeAttractionToPlayer(Actor akActor, int amount) global
    string skey = arcs_Attraction.GetAttractionToPlayerStorageKey()
    int attraction = StorageUtil.GetIntValue(akActor, skey, -1)
    attraction += amount
    if attraction > 100
        attraction = 100
    endif
    if attraction < 0
        attraction = 0
    endif
    StorageUtil.SetIntValue(akActor, skey, attraction)
endfunction

int function AttractionToPlayerCheck(Actor akActor) global

    int result = 0 

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    string skey = arcs_Attraction.GetAttractionToPlayerStorageKey()

    int attraction = StorageUtil.GetIntValue(akActor, skey, -1)

    if config.arcs_GlobalUseAttractionSeed.GetValue() == 1 && attraction == -1

        ;NOTE - this would be for players that already live in the area

        if config.arcs_GlobalUseSexualityCheck.GetValue() == 1

            sslActorStats slStat = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
            Actor thePlayer = Game.GetPlayer()
            int playerGender = thePlayer.GetActorBase().GetSex()
            int playerSexuality = slStat.GetSexuality(thePlayer)
            int sexuality = slStat.GetSexuality(akActor)
            int gender = akActor.GetActorBase().GetSex()

            int maxRange = 10
            int sexualityDifference = playerSexuality - sexuality
            if sexualityDifference < 0
                sexualityDifference = sexualityDifference * -1
            endif
            if sexualityDifference <= 30
                maxRange += 30
            elseif sexualityDifference > 30 && sexualityDifference <= 50
                maxRange += 10
            endif
            if sexuality <= 35
                ;gay
                if gender == playerGender
                    maxRange += 40
                endif
            elseif sexuality > 35 && sexuality < 65
                ;bi
                maxRange += 40
            elseif sexuality >= 65
                ;straight
                if gender != playerGender
                    maxRange += 40
                endif
            endif

            attraction = Utility.RandomInt(0, maxRange)

        else
            ;random seed with no sex preference
            attraction = Utility.RandomInt(0, 100)
        endif

        StorageUtil.SetIntValue(akActor, skey, attraction)

    elseif config.arcs_GlobalUseAttractionSeed.GetValue() == 0 && attraction == -1

        attraction = 0
        StorageUtil.SetIntValue(akActor, skey, attraction)

    endif

    ;arcs_Utility.WriteInfo("AttractionToPlayerCheck - attraction: " + attraction + " who: " + akActor.GetDisplayName())

    return attraction

endfunction
