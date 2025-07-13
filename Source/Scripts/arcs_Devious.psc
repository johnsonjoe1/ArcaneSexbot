Scriptname arcs_Devious extends Quest  

;zadLibs zlib

zadLibs function GetDeviousZadlibs() global
    return Quest.GetQuest("zadQuest") as zadLibs
endfunction

zadDeviceLists function GetDeviousZadDevicesList() global
    return Quest.GetQuest("zadxQuest") as zadDeviceLists
endfunction

function GameLoaded()

    ;zlib = GetDeviousZadlib()

    arcs_DeviousRegister.RegisterDecorators()
    arcs_DeviousRegister.RegisterActions()

    RegisterModEvents()

    Debug.Notification("Arcane Sexbot - Devious Devices active")

endfunction

function RegisterModEvents() global
    
endfunction

string function DeviousListDisplayNames() global
    return "Armbinder|Chastity Belt|Boots|Blindfold|Collar|Corset|Gag|Gloves|Harness|Hood|Nipple Piercing|Vaginal Piercing|Anal Plug|Vaginal Plug"
endfunction

string function DeviousList() global
    return "armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug"
    ;arm cuffs|leg cuffs|suit/catsuit|bra|"
endfunction

; string function DeviousRestraintsList() global
;     return "yoke|armbinder|collar|gag|blindfold|hood|harness|arm cuffs|leg cuffs|gloves|boots|corset|suit/catsuit"
; endfunction

string function GetDeviousDisplayName(string type) global
    string types = arcs_Devious.DeviousList()
    string displayNames = arcs_Devious.DeviousListDisplayNames()
    string result = ""
    string[] typesList = StringUtil.Split(types, "|")
    string[] displayNamesList = StringUtil.Split(displayNames, "|")
    int i = 0
    while i < typesList.Length
        if typesList[i] == type
            result = displayNamesList[i]
            i = 500
        endif
        i += 1
    endwhile
    return result
endfunction



Keyword function ItemTypeToKeyword(string type) global

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()

    if type == "collar"
        return zlib.zad_DeviousCollar
    
    elseif type == "wrist restraints"
        return zlib.zad_DeviousHeavyBondage

    else
        return none
    endif

endfunction

;NOTE - this code will not work in this mod, but will be super handy for binding

; int function CAN_EQUIP_LIST()
;     return 1
; endfunction

; int function CAN_REMOVE_LIST()
;     return 2
; endfunction

; string function CreateDeviousItemsTypes(Actor akActor, int direction)

;     string list = ""

;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Collar", akActor.WornHasKeyword(zlib.zad_DeviousCollar), direction), "|", false)
;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Wrist Restraints", akActor.WornHasKeyword(zlib.zad_DeviousHeavyBondage), direction), "|", false)

; endfunction

; string function AddItemToTypesList(string name, bool found, int direction)
;     string result = ""
;     if direction == CAN_EQUIP_LIST()
;         if !found 
;             result = name
;         endif
;     elseif direction == CAN_REMOVE_LIST()
;         if found
;             result = name
;         endif
;     endif
;     return result
; endfunction

;return types: 0 failed, 1 success, 2 player rejected
int function RemoveDeviousItem(Actor akSource, Actor akTarget, string type) global

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    int result = 0

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akSource.GetDisplayName() + " wants to remove - " + arcs_Devious.GetDeviousDisplayName(type), "Allow this?", "Reject this")
                return 2
            endif
        endif

        arcs_Movement.FaceTarget(akSource, akTarget)
        arcs_Movement.PlayDoWork(akSource)

        if zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
            result = 1
        endif

        StorageUtil.StringListRemove(akTarget, "arcs_dd_items", type, true)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, none) ;todo - make sure this works
        
        arcs_Utility.WriteInfo("Removeing DD: " + dev.GetName())

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

    return result

endfunction

;return types: 0 failed, 1 success, 2 player rejected
int function AddRandomDeviousItem(Actor akSource, Actor akTarget, string type) global

    int result = 0

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Keyword kw = arcs_Devious.ItemTypeToKeyword(type)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    zadDeviceLists zDevicesList = arcs_Devious.GetDeviousZadDevicesList()

    ;armbinder|belt|boots|blindfold|collar|corset|gag|gloves|harness|hood|npiercing|vpiercing|aplug|vplug

    LeveledItem itemsList
    if type == "armbinder"
        itemsList = zDevicesList.zad_dev_armbinders
    elseif type == "belt"
        itemsList = zDevicesList.zad_dev_chastitybelts
    elseif type == "boots"
        itemsList = zDevicesList.zad_dev_boots
    elseif type == "blindfold"
        itemsList = zDevicesList.zad_dev_blindfolds
    elseif type == "collar"
        itemsList = zDevicesList.zad_dev_collars
    elseif type == "corset"
        itemsList = zDevicesList.zad_dev_corsets
    elseif type == "gag"
        itemsList = zDevicesList.zad_dev_gags
    elseif type == "gloves"
        itemsList = zDevicesList.zad_dev_gloves
    elseif type == "harness"
        itemsList = zDevicesList.zad_dev_harnesses
    elseif type == "hood"
        itemsList = zDevicesList.zad_dev_hoods
    elseif type == "npiercing"
        itemsList = zDevicesList.zad_dev_piercings_nipple
    elseif type == "vpiercing"
        itemsList = zDevicesList.zad_dev_piercings_vaginal
    elseif type == "aplug"
        itemsList = zDevicesList.zad_dev_plugs_anal
    elseif type == "vplug"
        itemsList = zDevicesList.zad_dev_plugs_vaginal

    endif

    Armor dev = zDevicesList.GetRandomDevice(itemsList)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akSource.GetDisplayName() + " wants to add - " + type, "Allow this?", "Reject this")
                return 2
            endif
        endif

        arcs_Utility.WriteInfo("Adding DD: " + dev.GetName())
        if zlib.LockDevice(akTarget, dev, true)
            result = 1
        endif
        
        StorageUtil.StringListAdd(akTarget, "arcs_dd_items", type, false)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, dev)
        StorageUtil.SetFloatValue(akTarget, "arcs_worn_time_" + type, arcs_Utility.GetTime())
      
    else
        arcs_Utility.WriteInfo("No DD found")
    endif

    return result

endfunction



