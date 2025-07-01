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
    if nudity == 0
        nudityString = "actor_nude"
    elseif nudity == 1
        nudityString = "actor_dressed_skimpy"
    elseif nudity == 2
        nudityString = "actor_dressed"
    endif
    arcs_Utility.WriteInfo("GetActorNudity decorator - actor: " + akActor.GetDisplayName() + " nudity: " + nudity + " output: " + nudityString)
    return nudityString
endfunction

string function GetArousalLevel(Actor akActor) global
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    string outputString = "actor_not_aroused"
    if arousal > 30 && arousal < 70
        outputString = "actor_mildly_aroused"
    elseif arousal > 70
        outputString = "actor_very_aroused"
    endif
    arcs_Utility.WriteInfo("GetArousalLevel decorator - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " output: " + outputString)
    return outputString
endfunction