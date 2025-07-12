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

    RegisterDecorators()
    RegisterActions()

    Debug.Notification("Arcane Sexbot - Devious Devices active")

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

function RegisterModEvents()
    
    SkyrimNetApi.RegisterDecorator("arcs_devious_enabled", "arcs_DeviousDecorators", "GetDeviousEnabled")

    SkyrimNetApi.RegisterDecorator("arcs_devious_hours_since_last_shocked", "arcs_DeviousDecorators", "GetDeviousHoursSinceLastShocked")

endfunction

function RegisterActions()

    ;******************************
    ;other bondage actions
    ;******************************
    ;hogtied
    ;bondage sets
    ;store favorite set
    ;favorite an item
    ;bind to furniture
    ;vibrate plug
    ;shock?

    SkyrimNetApi.RegisterAction("ArcbotShock", "Makes piercings and plugs give {target} a shock for sexual pleasure or torment.", "arcs_DeviousEligibility", "ArcbotShock_IsEligible", \
        "arcs_DeviousExecution", "ArcbotShock_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")

    ;BINDER
    SkyrimNetApi.RegisterAction("ArcbotAddArmbinder", "Equip a armbinder on {target} to bind their hands", "arcs_DeviousEligibility", "ArcbotAddArmbinder_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddArmbinder_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveArmbinder", "Remove a armbinder from {target} to unbind their hands", "arcs_DeviousEligibility", "ArcbotRemoveArmbinder_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveArmbinder_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  
 
    ;BELT
    SkyrimNetApi.RegisterAction("ArcbotAddChastityBelt", "Equip a chastity belt over {target}'s hips", "arcs_DeviousEligibility", "ArcbotAddChastityBelt_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddChastityBelt_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"type\":\"open|closed\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveChastityBelt", "Remove a chastity belt from {target}'s hips", "arcs_DeviousEligibility", "ArcbotRemoveChastityBelt_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveChastityBelt_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  
    
    ;BLINDFOLD        
    SkyrimNetApi.RegisterAction("ArcbotAddBlindfold", "Equip a blindfold over {target}'s eyes'", "arcs_DeviousEligibility", "ArcbotAddBlindfold_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddBlindfold_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"cloth|ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveBlindfold", "Remove a blindfold from {target}'s eyes", "arcs_DeviousEligibility", "ArcbotRemoveBlindfold_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveBlindfold_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;BOOTS
    SkyrimNetApi.RegisterAction("ArcbotAddSlaveBoots", "Equip a slave boots on {target}'s feet", "arcs_DeviousEligibility", "ArcbotAddSlaveBoots_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddSlaveBoots_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"metal|ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveSlaveBoots", "Remove a slave boots from {target}'s feet", "arcs_DeviousEligibility", "ArcbotRemoveSlaveBoots_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveSlaveBoots_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;COLLAR
    SkyrimNetApi.RegisterAction("ArcbotAddCollar", "Equip a collar on {target}'s neck", "arcs_DeviousEligibility", "ArcbotAddCollar_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddCollar_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|metal|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveCollar", "Remove a collar from {target}'s neck", "arcs_DeviousEligibility", "ArcbotRemoveCollar_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveCollar_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;CORSET - needs pattern options also
    SkyrimNetApi.RegisterAction("ArcbotAddCorset", "Equip a corset on {target}'s waist", "arcs_DeviousEligibility", "ArcbotAddCorset_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddCorset_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveCorset", "Remove a corset from {target}'s waist", "arcs_DeviousEligibility", "ArcbotRemoveCorset_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveCorset_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;GAG
    SkyrimNetApi.RegisterAction("ArcbotAddGag", "Equip a gag in {target}'s mouth", "arcs_DeviousEligibility", "ArcbotAddGag_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddGag_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\",\"type\":\"ball|panel|ring\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveGag", "Remove a gag from {target}'s mouth", "arcs_DeviousEligibility", "ArcbotRemoveGag_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveGag_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;GLOVES
    SkyrimNetApi.RegisterAction("ArcbotAddSlaveGloves", "Equip a slave gloves on {target}'s hands", "arcs_DeviousEligibility", "ArcbotAddSlaveGloves_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddSlaveGloves_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveSlaveGloves", "Remove a slave gloves from {target}'s hands", "arcs_DeviousEligibility", "ArcbotRemoveSlaveGloves_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveSlaveGloves_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;HARNESS
    SkyrimNetApi.RegisterAction("ArcbotAddHarness", "Equip a slave harness over {target}'s chest", "arcs_DeviousEligibility", "ArcbotAddHarness_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddHarness_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|metal|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveHarness", "Remove a slave harness from {target}'s chest", "arcs_DeviousEligibility", "ArcbotRemoveHarness_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveHarness_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;HOOD
    SkyrimNetApi.RegisterAction("ArcbotAddHood", "Equip a hood over {target}'s head", "arcs_DeviousEligibility", "ArcbotAddHood_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddHood_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveHood", "Remove a hood from {target}'s head", "arcs_DeviousEligibility", "ArcbotRemoveHood_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveHood_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;NIPPLE PIERCING
    SkyrimNetApi.RegisterAction("ArcbotAddNipplePiercing", "Equip nipple piercings on {target}", "arcs_DeviousEligibility", "ArcbotAddNipplePiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddNipplePiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveNipplePiercing", "Remove nipple piercings from {target}", "arcs_DeviousEligibility", "ArcbotRemoveNipplePiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveNipplePiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;VAGINAL PIERCING
    SkyrimNetApi.RegisterAction("ArcbotAddVaginalPiercing", "Equip vaginal piercing on {target}", "arcs_DeviousEligibility", "ArcbotAddVaginalPiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddVaginalPiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveVaginalPiercing", "Remove vaginal piercing from {target}", "arcs_DeviousEligibility", "ArcbotRemoveVaginalPiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveVaginalPiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;ANAL PLUG
    SkyrimNetApi.RegisterAction("ArcbotAddAnalPlug", "Insert an anal plug in {target}'s ass", "arcs_DeviousEligibility", "ArcbotAddAnalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddAnalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveAnalPlug", "Remove an anal plug from {target}'s ass", "arcs_DeviousEligibility", "ArcbotRemoveAnalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveAnalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;VAGINAL PLUG
    SkyrimNetApi.RegisterAction("ArcbotAddVaginalPlug", "Insert an vaginal plug in {target}", "arcs_DeviousEligibility", "ArcbotAddVaginalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddVaginalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveVaginalPlug", "Remove an vaginal plug from {target}", "arcs_DeviousEligibility", "ArcbotRemoveVaginalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveVaginalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  




endfunction

function RegisterDecorators()

    ;dd enabled decorator
    ;item description decorators & time worn (return json)

    SkyrimNetApi.RegisterDecorator("arcs_get_devious_info", "arcs_DeviousDecorators", "GetDeviousInfo")

    ;min's example:
    ;{% set my_payload = get_worn_gear_info(actorUUID) %}
    ;{% if worn_has_keyword(actorUUID, "zad_DeviousBelt") %}
    ;  - {{ actor_name }} is locked in a {{ my_payload.belt.description }} for {{ my_payload.belt.duration }}, denying (etc)


    ;what's in the bondage bag decorator
    ;this would use a favorites list to let the dom/top know these are the items that they can use for play
    ;getting a lot of tie in silk ropes comments from LLM when adding metal cuffs

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



