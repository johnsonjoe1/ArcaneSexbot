Scriptname arcs_Arousal extends Quest  

int property ACTOR_NOT_AROUSED = 0 autoReadOnly
int property ACTOR_SLIGTHY_AROUSED = 1 autoReadOnly
int property ACTOR_VERY_AROUSED = 2 autoReadOnly

arcs_Arousal function GetArcsArousal() global
    return Quest.GetQuest("arcs_MainQuest") as arcs_Arousal
endfunction

string function GetArousalText(int arousalLevel) global
    arcs_ConfigSettings config = arcs_ConfigSettings.GetArcsConfig()
    string outputString = "actor_not_aroused"
    if arousalLevel > config.arcs_GlobalSlightlyAroused.GetValue() && arousalLevel < config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_slightly_aroused"
    elseif arousalLevel > config.arcs_GlobalVeryAroused.GetValue()
        outputString = "actor_very_aroused"
    endif
    return outputString
endfunction

int function GetActorArousalValue(Actor akActor) global
    arcs_ConfigSettings config = arcs_ConfigSettings.GetArcsConfig()
    arcs_Arousal aarousal = arcs_Arousal.GetArcsArousal()
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    int result = aarousal.ACTOR_NOT_AROUSED
    if arousal >= config.arcs_GlobalSlightlyAroused.GetValue() && arousal < config.arcs_GlobalVeryAroused.GetValue()
        result = aarousal.ACTOR_SLIGTHY_AROUSED
    elseif arousal >= config.arcs_GlobalVeryAroused.GetValue()
        result = aarousal.ACTOR_VERY_AROUSED
    endif
    debug.MessageBox("arcs_Arousal - GetActorArousalValue check - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " result: " + result)
    arcs_Utility.WriteInfo("arcs_Arousal - GetActorArousalValue check - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " result: " + result)
    return result
endfunction

function ChangeActorExposure(Actor akActor, int changeAmount) global
    slaFrameworkScr slaf = Quest.GetQuest("sla_Framework") as slaFrameworkScr
    int exposure = slaf.GetActorExposure(akActor)
    int newExposure = slaf.UpdateActorExposure(akActor, changeAmount, "Arcane Sexbot updated exposure change: " + changeAmount)
endfunction