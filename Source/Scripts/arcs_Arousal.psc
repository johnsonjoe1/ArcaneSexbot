Scriptname arcs_Arousal extends Quest  

int function ACTOR_NOT_AROUSED() global
    return 0
endfunction

int function ACTOR_SLIGTHY_AROUSED() global
    return 1
endfunction

int function ACTOR_VERY_AROUSED() global
    return 2
endfunction

string function GetArousalText(int arousalLevel) global
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    string outputString = "actor_not_aroused"
    if arousalLevel > config.arcs_GlobalSlightlyAroused.GetValue() && arousalLevel < config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_slightly_aroused"
    elseif arousalLevel > config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_very_aroused"
    endif
    return outputString
endfunction

int function GetActorArousalValue(Actor akActor) global
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    int result = arcs_Arousal.ACTOR_NOT_AROUSED()
    if arousal > config.arcs_GlobalSlightlyAroused.GetValue() && arousal < config.arcs_GlobalVeryAroused.GetValue()
        result = arcs_Arousal.ACTOR_SLIGTHY_AROUSED()
    elseif arousal > config.arcs_GlobalVeryAroused.GetValue()
        result = arcs_Arousal.ACTOR_VERY_AROUSED()
    endif
    ;arcs_Utility.WriteInfo("arcs_Arousal - GetActorArousalValue check - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " result: " + result)
    return result
endfunction

function ChangeActorExposure(Actor akActor, int changeAmount) global
    slaFrameworkScr slaf = Quest.GetQuest("sla_Framework") as slaFrameworkScr
    ; Faction slaArousalFaction = slau.slaArousal
    ; int exposure = akActor.GetFactionRank(slaArousalFaction)
    int exposure = slaf.GetActorExposure(akActor)
    ; int newExposure = exposure + changeAmount
    ; if newExposure < 0
    ;     newExposure = 0
    ; elseif newExposure > 100
    ;     newExposure = 100
    ; endif
    int newExposure = slaf.UpdateActorExposure(akActor, changeAmount, "Arcane Sexbot updated exposure change: " + changeAmount)
    ;int newExposure = slaf.GetActorExposure(akActor)
    ;arcs_Utility.WriteInfo("arcs_Arousal - ChangeActorExposure - actor: " + akActor.GetDisplayName() + " old: " + exposure + " new: " + newExposure)
endfunction