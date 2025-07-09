Scriptname arcs_DeviousExecution extends Quest  

function ExtCmdAddBdsmDevice_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdAddBdsmDevice_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Actor thePlayer = Game.GetPlayer()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 
    Keyword kw = arcs_Devious.ItemTypeToKeyword(type)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    zadDeviceLists zDevicesList = arcs_Devious.GetDeviousZadDevicesList()

    ;"yoke|armbinder|collar|gag|blindfold|hood|harness|arm cuffs|leg cuffs|gloves|boots|corset|suit/catsuit"

    LeveledItem itemsList
    if type == "yoke"
        itemsList = zDevicesList.zad_dev_yokes
    elseif type == "armbinder"
        itemsList = zDevicesList.zad_dev_armbinders
    elseif type == "collar"
        itemsList = zDevicesList.zad_dev_collars
    elseif type == "gag"
        itemsList = zDevicesList.zad_dev_gags
    elseif type == "blindfold"
        itemsList = zDevicesList.zad_dev_blindfolds
    elseif type == "hood"
        itemsList = zDevicesList.zad_dev_hoods
    elseif type == "harness"
        itemsList = zDevicesList.zad_dev_harnesses
    elseif type == "arm cuffs"
        itemsList = zDevicesList.zad_dev_armcuffs
    elseif type == "leg cuffs"
        itemsList = zDevicesList.zad_dev_legcuffs
    elseif type == "gloves"
        itemsList = zDevicesList.zad_dev_gloves
    elseif type == "boots"
        itemsList = zDevicesList.zad_dev_boots
    elseif type == "corset"
        itemsList = zDevicesList.zad_dev_corsets
    elseif type == "suit/catsuit"
        itemsList = zDevicesList.zad_dev_suits
    elseif type == "bra"
        itemsList = zDevicesList.zad_dev_chastitybras
    elseif type == "belt"
        itemsList = zDevicesList.zad_dev_chastitybelts
    elseif type == "nipple"
        itemsList = zDevicesList.zad_dev_piercings_nipple
    elseif type == "clitoris"
        itemsList = zDevicesList.zad_dev_piercings_vaginal
    elseif type == "anal"
        itemsList = zDevicesList.zad_dev_plugs_anal
    elseif type == "vaginal"
        itemsList = zDevicesList.zad_dev_plugs_vaginal
    endif

    Armor dev = zDevicesList.GetRandomDevice(itemsList)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == thePlayer
            if !arcs_Utility.ConfirmBox(akOriginator.GetDisplayName() + " wants to add - " + type, "Allow this?", "Reject this")
                return
            endif
        endif

        arcs_Utility.WriteInfo("Adding DD: " + dev.GetName())
        bool result = zlib.LockDevice(akTarget, dev, true)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, dev)
        ;store item added
        ;StorageUtil.SetStringValue(akTarget, "arcs_worn_item_added_" + type, 0.0) ;getcurrenttime
        ;StorageUtil.SetStringValue(akTarget, "arcs_worn_item_desc_" + type, dev.GetName())
      
    else
        arcs_Utility.WriteInfo("No DD found")
    endif

endfunction

function ExtCmdRemoveBdsmDevice_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdRemoveBdsmDevice_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Actor thePlayer = Game.GetPlayer()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == thePlayer
            if !arcs_Utility.ConfirmBox(akOriginator.GetDisplayName() + " wants to remove - " + type, "Allow this?", "Reject this")
                return
            endif
        endif

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        arcs_Movement.PlayDoWork(akOriginator)

        bool result = zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)

        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, none) ;todo - make sure this works
        
        arcs_Utility.WriteInfo("Removeing DD: " + dev.GetName())

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

endfunction

function RemoveAllBdsmRestraints_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdRemoveBdsmDevice_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    Actor thePlayer = Game.GetPlayer()
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?

    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
	Form[] inventory = akTarget.GetContainerForms()
	int i = 0
 	while i < inventory.Length
        Form dev = inventory[i]
        if dev.HasKeyWord(zlib.zad_inventoryDevice)
            arcs_Utility.WriteInfo("found zad_inventoryDevice: " + dev)
            if dev.HasKeyWord(zlib.zad_QuestItem) || dev.HasKeyWord(zlib.zad_BlockGeneric)
                arcs_Utility.WriteInfo("quest or blocking device")
            else
                if zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
                    arcs_Utility.WriteInfo("removed device")
                endif
            endif
        endif
        i += 1
    endwhile

endfunction