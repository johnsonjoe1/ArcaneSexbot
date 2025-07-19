Scriptname arcs_Decorators extends Quest  

;TODO - move decorator functions to their own script
string function GetActorBlocked(Actor akActor) global
    if akActor == none
        return arcs_Utility.JsonIntValueReturn("actor_blocked", -1)
    endif
    int actorOK = 0
    ;sexlab eligibility?
    ;check for appropriate ages
    if akActor.IsChild()
        actorOK = 1 ;adults only
    endif

    ;check for player mcm race blocks
    ;check for elderly mcm block
    ;check for player sexual preferences

    return arcs_Utility.JsonIntValueReturn("actor_blocked", actorOK)
endfunction

string function GetActorSexualPurity(Actor akActor) global
    if akActor == none
        return ""
    endif
    return ""
endfunction

string function GetActorSexualPreference(Actor akActor) global
    if akActor == none
        return ""
    endif
    return ""
endfunction

string function GetActorNudity(Actor akActor) global
    if akActor == none
        return ""
    endif
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

string function GetNudityValue(Actor akActor) global
    if akActor == none
        return arcs_Utility.JsonIntValueReturn("nudity", -1)
    endif
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    int nudity = ncheck.NudityCheck(akActor)
    return arcs_Utility.JsonIntValueReturn("nudity", nudity)
endfunction

string function GetArousalLevel(Actor akActor) global
    if akActor == none
        return ""
    endif
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

string function GetArousalValue(Actor akActor) global
    if akActor == none
        return arcs_Utility.JsonIntValueReturn("arousal", -1)
    endif
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    return arcs_Utility.JsonIntValueReturn("arousal", arousal)
endfunction

string function SexMinimumArousalCheck(Actor akActor) global
    if akActor == none
        return ""
    endif
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
    if akActor == none
        return ""
    endif
    int threadId = arcs_SexLab.GetActorThreadId(akActor)
    arcs_Utility.WriteInfo("GetSexThreadId decorator - actor: " + akActor.GetDisplayName() + " threadId: " + threadId)
    return "" + threadId
endfunction

string function InSexScene(Actor akActor) global
    if akActor == none
        return ""
    endif    
    bool inScene = arcs_SexLab.ActorInSexScene(akActor)
    string outputString = "actor_not_having_sex"
    if inScene
        outputString = "actor_having_sex"
    endif
    arcs_Utility.WriteInfo("GetSexThreadId decorator - actor: " + akActor.GetDisplayName() + " outputString: " + outputString)
    return outputString
endfunction

string function GetSexInfo(Actor akActor) global

    string output = ""
    
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    sslActorStats slStat = Quest.GetQuest("SexLabQuestFramework") as sslActorStats
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    int nudity = -1
    int arousal = -1
    int purity = -1
    int sexuality = -1
    int gender = -1
    int inSceneInt = -1
    string displayName = ""
   
    if akActor != none
        nudity = ncheck.NudityCheck(akActor)
        arousal = slau.GetActorArousal(akActor)
        purity = slStat.GetPurityLevel(akActor)
        sexuality = slStat.GetSexuality(akActor)
        gender = akActor.GetLeveledActorBase().GetSex()
        bool inScene = arcs_SexLab.ActorInSexScene(akActor)
        inSceneInt = 0
        if inScene
            inSceneInt = 1
        endif
        displayName = akActor.GetDisplayName()
    endif

    int useArousal = config.arcs_GlobalUseArousal.GetValue() as int
    int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
    int slightlyArousedThreshold =  config.arcs_GlobalSlightlyAroused.GetValue() as int
    int veryArousedThreshold = config.arcs_GlobalVeryAroused.GetValue() as int
    int slightlyAttractedThreshold = config.arcs_GlobalSlightlyAttracted.GetValue() as int
    int veryAttractedThreshold = config.arcs_GlobalVeryAttracted.GetValue() as int
    int subAndSlave = config.arcs_GlobalUseSubmissionAndSlavery.GetValue() as int

    int attraction = 0
    int attractionEnabled = 0
    if config.arcs_GlobalUseAttractionSystem.GetValue() == 1 && akActor != none
        attractionEnabled = 1
        attraction = arcs_Attraction.AttractionToPlayerCheck(akActor)
    else
        attraction = -1 ;disabled
    endif

    output = "{"

    output += "\"npcname\":\"" + displayName + "\","
    output += "\"having_sex\":" + inSceneInt + ","
    output += "\"sub_and_slave\":" + subAndSlave + ","
    output += "\"nudity\":" + nudity + ","
    output += "\"attraction_enabled\":" + attractionEnabled + ","
    output += "\"attraction\":" + attraction + ","
    output += "\"slightly_attracted\":" + slightlyAttractedThreshold + ","
    output += "\"very_attracted\":" + veryAttractedThreshold + ","    
    output += "\"use_arousal\":" + useArousal + ","    
    output += "\"arousal_sex\":" + arousalNeeded + ","
    output += "\"slightly_aroused\":" + slightlyArousedThreshold + ","
    output += "\"very_aroused\":" + veryArousedThreshold + ","
    output += "\"arousal\":" + arousal

    output += "}"

    ; output += "\"arousal_needed_for_sex\":" + arousalNeeded + ","
    ; output += "\"needed_for_slightly_aroused\":" + slightlyArousedThreshold + ","
    ; output += "\"needed_for_very_aroused\":" + veryArousedThreshold + ","
    ; output += "\"purity\":" + purity + ","
    ; output += "\"sexuality\":" + sexuality + ","
    ; output += "\"gender\":" + gender + ","
    ; output += "\"attraction_enabled\":" + attractionEnabled + ","
    ; output += "\"attraction\":" + attraction

    ; output += "}"

    arcs_Utility.WriteInfo(output)

    return output

endfunction