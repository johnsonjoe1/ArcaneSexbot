Scriptname arcs_Decorators extends Quest  

;TODO - move decorator functions to their own script
string function GetActorBlocked(Actor akActor) global

    ;sexlab eligibility?
    ;check for appropriate ages
    ;check for player mcm race blocks
    ;check for elderly mcm block
    ;check for player sexual preferences

    return ""
endfunction

string function GetActorSexualPurity(Actor akActor) global

    return ""
endfunction

string function GetActorSexualPreference(Actor akActor) global

    return ""
endfunction

string function GetActorNudity(Actor akActor) global
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    int nudity = ncheck.NudityCheck(akActor)
    string nudityString = ""
    if nudity == ncheck.NUDITYCHECK_ACTOR_NUDE()
        nudityString = "actor_nude"
    elseif nudity == ncheck.NUDITYCHECK_ACTOR_DRESSED_SKIMPY()
        nudityString = "actor_dressed_skimpy"
    elseif nudity == ncheck.NUDITYCHECK_ACTOR_DRESSED()
        nudityString = "actor_dressed"
    endif
    arcs_Utility.WriteInfo("GetActorNudity decorator - actor: " + akActor.GetDisplayName() + " nudity: " + nudity + " output: " + nudityString)
    return nudityString
endfunction

string function GetArousalLevel(Actor akActor) global
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    string outputString = "actor_not_aroused"
    if arousal > config.arcs_GlobalSlightlyAroused.GetValue() && arousal < config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_slightly_aroused"
    elseif arousal > config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_very_aroused"
    endif
    arcs_Utility.WriteInfo("GetArousalLevel decorator - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " output: " + outputString)
    return outputString
endfunction

string function GetAttractionToPlayer(Actor akActor) global

    string outputString = "actor_not_attracted"

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    sslActorStats slStat = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
    
    int arousal = slau.GetActorArousal(akActor)
    ;bool exbitionist = slau.IsActorExhibitionist(akActor)
    int purity = slStat.GetPurityLevel(akActor)
    int sexuality = slStat.GetSexuality(akActor)
    int gender = akActor.GetLeveledActorBase().GetSex()

    Actor thePlayer = Game.GetPlayer()
    int playerPurity = slStat.GetPurityLevel(thePlayer)
    int playerGender = thePlayer.GetLeveledActorBase().GetSex()

    bool sexCompatible = false
    if sexuality <= 35
        ;gay
        if gender == playerGender
            sexCompatible = true
        endif
    elseif sexuality > 35 && sexuality < 65
        ;bi
        sexCompatible = true
    elseif sexuality >= 65
        ;straight
        if gender != playerGender
            sexCompatible = true
        endif
    endif

    if sexCompatible
        if arousal <= config.arcs_GlobalSlightlyAroused.GetValue()
            outputString = "actor_attracted_not_aroused"  
        elseif arousal > config.arcs_GlobalSlightlyAroused.GetValue()  && arousal < config.arcs_GlobalVeryAroused.GetValue()
            outputString = "actor_attracted_slightly_aroused"
        elseif  arousal >= config.arcs_GlobalVeryAroused.GetValue()
            outputString = "actor_attracted_aroused"
        endif
    endif

    arcs_Utility.WriteInfo("GetAttractionToPlayer decorator - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " sexCompatible: " + sexCompatible + " output: " + outputString)

    return outputString

endfunction

string function SexMinimumArousalCheck(Actor akActor) global

    string outputString = "sex_aroused_min_yes"

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr

    int arousal = slau.GetActorArousal(akActor)
    int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
    if arousal < arousalNeeded
        outputString = "sex_aroused_min_no"
    endif

    arcs_Utility.WriteInfo("SexMinimumArousalCheck decorator - actor: " + akActor.GetDisplayName() + " output: " + outputString)

    return outputString

endfunction

string function GetSexThreadId(Actor akActor) global
    int threadId = arcs_SexLab.GetActorThreadId(akActor)
    arcs_Utility.WriteInfo("GetSexThreadId decorator - actor: " + akActor.GetDisplayName() + " threadId: " + threadId)
    return "" + threadId
endfunction

string function InSexScene(Actor akActor) global
    bool inScene = arcs_SexLab.ActorInSexScene(akActor)
    string outputString = "actor_not_having_sex"
    if inScene
        outputString = "actor_having_sex"
    endif
    arcs_Utility.WriteInfo("GetSexThreadId decorator - actor: " + akActor.GetDisplayName() + " outputString: " + outputString)
    return outputString
endfunction