Scriptname arcs_DeviousExecution extends Quest  

function ExtCmdAddBdsmDevice_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdAddBdsmDevice_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

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
    endif

    Armor dev = zDevicesList.GetRandomDevice(itemsList)
    if dev
        arcs_Utility.WriteInfo("Adding DD: " + dev.GetName())
        bool result = zlib.LockDevice(akTarget, dev, true)
        StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, dev)
    else
        arcs_Utility.WriteInfo("No DD found")
    endif

endfunction

function ExtCmdRemoveBdsmDevice_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdRemoveBdsmDevice_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + type, none)
    if dev
        bool result = zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
        arcs_Utility.WriteInfo("Removeing DD: " + dev.GetName())
    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

endfunction