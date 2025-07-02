Scriptname arcs_Eligibility extends Quest  

bool function ActorIsEligible(Actor akActor) global
    ;TODO - add other global checks here
    bool valid = true

    if akActor == Game.GetPlayer()
        valid = false ;the player should never be the source of these
    endif

    if akActor.IsChild()
        valid = false ;adults onlly
    endif

    return valid
endfunction

;TODO - move eligibility checks to their own script
;TODO - create function to add to IsEligible calls to run high level checks like DHLP so not duplicated or missed
bool function ExtCmdStartSex_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true 
    
    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if akTarget.IsChild()
            result = false
        endif
    endif

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akOriginator)
    int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
    if arousal < arousalNeeded
        result = false
    endif

    ;TODO - target arousal check
    ;TODO - if NC sex, target arousal is not needed


    arcs_Utility.WriteInfo("ExtCmdStartSex_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + \
        " arousal: " + arousal + " needed: " + arousalNeeded + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdUpdateSexualPreferences_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    return true ;TODO - make this work
endfunction

bool function ExtCmdStripTarget_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if !arcs_Eligibility.ActorIsEligible(akTarget) 
            result = false
        endif

        arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
        if ncheck.NudityCheck(akTarget) == ncheck.NUDITYCHECK_ACTOR_NUDE()
            result = false ;already undressed
        endif

    endif

    arcs_Utility.WriteInfo("ExtCmdStripTarget_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdDressTarget_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if !arcs_Eligibility.ActorIsEligible(akTarget) 
            result = false
        endif

        arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
        if ncheck.NudityCheck(akTarget) != ncheck.NUDITYCHECK_ACTOR_NUDE()
            result = false ;already dressed
        endif

    endif

    arcs_Utility.WriteInfo("ExtCmdDressTarget_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdUndress_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    if ncheck.NudityCheck(akOriginator) == ncheck.NUDITYCHECK_ACTOR_NUDE()
        result = false ;already undressed
    endif

    arcs_Utility.WriteInfo("ExtCmdUndress_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " result: " + result)

    return result

endfunction

bool function ExtCmdDress_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    if ncheck.NudityCheck(akOriginator) != ncheck.NUDITYCHECK_ACTOR_NUDE()
        result = false ;already dressed
    endif

    arcs_Utility.WriteInfo("ExtCmdDress_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " result: " + result)

    return result

endfunction
