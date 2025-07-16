Scriptname arcs_API   

bool function IsDhlpActive() global
    arcs_Data gdata = arcs_Data.GetArcsData()
    return gdata.DhlpSuspend != 0
endfunction

int function CheckNudity(Actor akActor) global
    if akActor == none
        return -1
    endif
    ;0 - nude, 1 - skimpy, 2 - dressed
    ;arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    return (arcs_NudityChecker.GetArcsNudityChecker()).NudityCheck(akActor)
endfunction

;types: armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug
int function AddRandomDeviousItem(Actor akSource, Actor akTarget, string type, bool playAnimation = true) global
    if playAnimation
        arcs_Movement.FaceTarget(akSource, akTarget)
        arcs_Movement.PlayDoWork(akSource)
    endif
    int result = arcs_Devious.AddRandomDeviousItem(akSource, akTarget, type)
    return result
endfunction

int function AddDeviousItem(Actor akActor, Form item) global

endfunction

int function RemoveDeviousItem(Actor akSource, Actor akTarget, string type, bool playAnimation = true) global
    if playAnimation
        arcs_Movement.FaceTarget(akSource, akTarget)
        arcs_Movement.PlayDoWork(akSource)
    endif
    int result = arcs_Devious.RemoveDeviousItem(akSource, akTarget, type)
    return result
endfunction