Scriptname arcs_DeviousEligibility extends Quest  

bool function ExtCmdAddBdsmDevice_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionAllDevious.GetValue() == 0
        return false
    endif
    
    ;TODO - specific config check for this action

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev
        result = false ;already wearning this type of item
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

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionAllDevious.GetValue() == 0
        return false
    endif

    return true

    ;NOTE - having the check look for a type is just not working, better to provide the list and false out of the execute for now (if no item).

    ;TODO - specific config check for this action

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if !dev
        arcs_Utility.WriteInfo("ITEM NOT STORED")
        result = false ;no item to unequip
    endif
    ;TODO - add a zad keyword check based on type also

    arcs_Utility.WriteInfo("ExtCmdRemoveBdsmDevice_IsEligible - target: " + akTarget.GetDisplayName() + " type: " + type + " result: " + result)

    return result

endfunction

bool function RemoveAllBdsmRestraints_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true

    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if config.arcs_GlobalActionAllDevious.GetValue() == 0
        return false
    endif

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?
    if !akTarget.WornHasKeyword(zlib.zad_Lockable)
        result = false
    endif

    arcs_Utility.WriteInfo("RemoveAllBdsmRestraints_IsEligible - target: " + akTarget.GetDisplayName() + " result: " + result)

    return result

endfunction