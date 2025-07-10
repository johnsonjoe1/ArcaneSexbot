Scriptname arcs_API   

bool function IsDhlpActive() global
    
endfunction

int function CheckNudity(Actor akActor) global
    ;0 - nude, 1 - skimpy, 2 - nude
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    return ncheck.NudityCheck(akActor)
endfunction