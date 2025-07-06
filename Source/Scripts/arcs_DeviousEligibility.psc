Scriptname arcs_DeviousEligibility extends Quest  

bool function ExtCmdAddBdsmDevice_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev
        result = false ;no item to unequip
    endif
    ;TODO - add a zad keyword check based on type also

    arcs_Utility.WriteInfo("ExtCmdAddBdsmDevice_IsEligible - target: " + akTarget.GetDisplayName() + " type: " + type + " result: " + result)

    return result

endfunction

bool function ExtCmdRemoveBdsmDevice_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if !dev
        result = false ;no item to unequip
    endif
    ;TODO - add a zad keyword check based on type also

    arcs_Utility.WriteInfo("ExtCmdRemoveBdsmDevice_IsEligible - target: " + akTarget.GetDisplayName() + " type: " + type + " result: " + result)

    return result

endfunction