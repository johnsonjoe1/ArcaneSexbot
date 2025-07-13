Scriptname arcs_DeviousExecution extends Quest  

Form function FindAColor(LeveledItem list, string color) global
    ;TODO - this needs to randomly pick one of the items of the color in the list vs the first item
    ;TODO - add a keyword search for some items (simple, penta, etc.)
    Form result
    int size = list.GetNumForms()
    int i = 0
    while i < size
        Form dev = list.GetNthForm(i)
        if dev 
            ;int Function Find(string s, string toFind, int startIndex = 0) global native
            if StringUtil.Find(dev.GetName(), color, 0) > -1
                result = dev
                i = 500 ;break
            endif
        endif
        i += 1
    endwhile
    return result
endfunction

function AddExecute(string category, Actor akOriginator, string contextJson, string paramsJson) global

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) 
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    zadDeviceLists zDevicesList = arcs_Devious.GetDeviousZadDevicesList()
    string material = SkyrimNetApi.GetJsonString(paramsJson, "material", "") 
    string color = SkyrimNetApi.GetJsonString(paramsJson, "color", "") 
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    LeveledItem itemsList

    if category == "armbinder"
        if material == "rope"
            itemsList = zDevicesList.zad_dev_armbinders_rope
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_armbinders_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_armbinders_leather
        else
            itemsList = zDevicesList.zad_dev_armbinders
        endif

    elseif category == "belt"
        if type == "open"
            itemsList = zDevicesList.zad_dev_chastitybelts_open
        elseif type == "closed"
            itemsList = zDevicesList.zad_dev_chastitybelts_closed
        Else
            itemsList = zDevicesList.zad_dev_chastitybelts
        endif

    elseif category == "boots"
        if material == "metal"
            itemsList = zDevicesList.zad_dev_boots_metal
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_boots_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_boots_leather
        else
            itemsList = zDevicesList.zad_dev_boots
        endif

    elseif category == "blindfold"
        if material == "cloth"
            itemsList = zDevicesList.zad_dev_blindfolds_cloth
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_blindfolds_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_blindfolds_leather
        else
            ;TODO - need a way to pull rope blindfolds
            itemsList = zDevicesList.zad_dev_blindfolds
        endif
    
    elseif category == "collar"
        if material == "rope"
            itemsList = zDevicesList.zad_dev_collars_rope
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_collars_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_collars_leather
        elseif material == "metal"
            itemsList = zDevicesList.zad_dev_collars_metal
        else
            itemsList = zDevicesList.zad_dev_collars
        endif

    elseif category == "corset"
        if material == "rope"
            itemsList = zDevicesList.zad_dev_corsets_rope
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_corsets_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_corsets_leather
        else
            itemsList = zDevicesList.zad_dev_corsets
        endif

    elseif category == "gag"
        if material == "rope"
            itemsList = zDevicesList.zad_dev_gags_rope
        elseif material == "ebonite"
            if type == "ball"
                itemsList = zDevicesList.zad_dev_gags_ball_ebonite
            elseif type == "panel"
                itemsList = zDevicesList.zad_dev_gags_panel_ebonite
            endif
        elseif material == "leather"
            if type == "ball"
                itemsList = zDevicesList.zad_dev_gags_ball_leather
            elseif type == "panel"
                itemsList = zDevicesList.zad_dev_gags_panel_leather
            endif
        else
            if type == "ring"
                itemsList = zDevicesList.zad_dev_gags_ring
            else
                itemsList = zDevicesList.zad_dev_gags
            endif
        endif

    elseif category == "gloves"
        if material == "ebonite"
            itemsList = zDevicesList.zad_dev_gloves_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_gloves_leather
        else
            itemsList = zDevicesList.zad_dev_gloves
        endif

    elseif category == "harness"
        if material == "rope"
            itemsList = zDevicesList.zad_dev_harnesses_rope
        elseif material == "ebonite"
            itemsList = zDevicesList.zad_dev_harnesses_ebonite
        elseif material == "leather"
            itemsList = zDevicesList.zad_dev_harnesses_leather
        elseif material == "metal"
            itemsList = zDevicesList.zad_dev_harnesses_metal
        else
            itemsList = zDevicesList.zad_dev_harnesses
        endif

    elseif category == "hood"
        itemsList = zDevicesList.zad_dev_hoods

    elseif category == "npiercing"
        itemsList = zDevicesList.zad_dev_piercings_nipple

    elseif category == "vpiercing"
        itemsList = zDevicesList.zad_dev_piercings_vaginal

    elseif category == "aplug"
        itemsList = zDevicesList.zad_dev_plugs_anal

    elseif category == "vplug"
        itemsList = zDevicesList.zad_dev_plugs_vaginal

    endif

    Armor dev = arcs_DeviousExecution.FindAColor(itemsList, color) as Armor
    if dev == none
        dev = zDevicesList.GetRandomDevice(itemsList)
    endif

    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akOriginator.GetDisplayName() + " wants to add " + dev.GetName(), "Allow this?", "Reject this")
                return
            endif
        endif

        ;arcs_Utility.WriteInfo("Adding DD: " + dev.GetName())
        if zlib.LockDevice(akTarget, dev, true)
            if category == "npiercing" || category == "vpiercing" || category == "aplug" || category == "vplug"
                ;the actor feels these
                zlib.Moan(akTarget, 100)
            endif

            StorageUtil.StringListAdd(akTarget, "arcs_dd_items", category, false)
            StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + category, dev)
            StorageUtil.SetFloatValue(akTarget, "arcs_worn_time_" + category, arcs_Utility.GetTime())
        endif

    endif

endfunction

function RemoveExecute(string category, Actor akOriginator, string contextJson, string paramsJson) global

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) ;todo - pull this from the quest?

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + category, none)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            if !arcs_Utility.ConfirmBox(akOriginator.GetDisplayName() + " wants to remove - " + dev.GetName(), "Allow this?", "Reject this")
                return
            endif
        endif

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        arcs_Movement.PlayDoWork(akOriginator)

        if zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
            StorageUtil.StringListRemove(akTarget, "arcs_dd_items", category, true)
            StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + category, none) ;todo - make sure this works
        endif
        
        ;arcs_Utility.WriteInfo("Removeing DD: " + dev.GetName())

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

    ;NOTE - support a keyword based remove of generic items? player might manually equip and item
    ;could track this in the actor alias with the on equipped event - binding does it

endfunction

;VIBRATE

function ArcbotStartVibration_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("CALLED ArcbotStartVibration_Execute")
    ;debug.MessageBox("in here??")

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    arcs_Utility.WriteInfo("ArcbotStartVibration_Execute target: " + akTarget, 2)

    string duration = SkyrimNetApi.GetJsonString(paramsJson, "duration", "") 
    int seconds = 60
    if duration == "medium"
        seconds = 120
    elseif duration == "long"
        seconds = 180
    endif

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    if akTarget != none

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        ;arcs_Movement.PlayDoWork(akOriginator)

        ;zlib.SetVibrating(akTarget, 30)

        if !aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
            aktarget.AddToFaction(config.arcs_GettingVibratedFaction)
        endif

        int orgasms = zlib.VibrateEffect(akTarget, 4, seconds, teaseOnly = false, silent = false)
        ;this has a timed loop

        if aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
            aktarget.RemoveFromFaction(config.arcs_GettingVibratedFaction)
        endif

        string data = ""
        if orgasms == 0
            data = akTarget.GetDisplayName() + " was only teased by the vibrating plug."
        elseif orgasms == 1
            data = akTarget.GetDisplayName() + " orgasmed " + orgasms + " time by the vibrating plug."
        else
            data = akTarget.GetDisplayName() + " orgasmed " + orgasms + " times by the vibrating plug."
        endif

        bool result = arcs_SkyrimNet.CreateShortLivedEvent("arc_start_vibrate_event_" + akOriginator.GetDisplayName(), "arc_start_vibrate_event", data, data, akOriginator, akTarget)
        result = arcs_SkyrimNet.CreateDirectNarration(data, akTarget)

    else 
        arcs_Utility.WriteInfo("No target found")
    endif

endfunction

function ArcbotStopVibration_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    debug.Notification("CALLED ArcbotStopVibration_Execute")
    ;debug.MessageBox("in here??")

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    arcs_Utility.WriteInfo("ArcbotStopVibration_Execute target: " + akTarget, 2)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    if akTarget != none

        zlib.StopVibrating(akTarget)

        if aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
            aktarget.RemoveFromFaction(config.arcs_GettingVibratedFaction)
        endif

        string data = akTarget.GetDisplayName() + " vibrating plug mercifully stops."
        bool result = arcs_SkyrimNet.CreateShortLivedEvent("arc_stop_vibrate_event_" + akOriginator.GetDisplayName(), "arc_stop_vibrate_event", data, data, akOriginator, akTarget)
        result = arcs_SkyrimNet.CreateDirectNarration(data, akTarget)

    else 
        arcs_Utility.WriteInfo("No target found")
    endif

endfunction

;SHOCK

function ArcbotShock_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("CALLED ArcbotShock_Execute")
    ;debug.MessageBox("in here??")

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) ;not sure if the PC is a good fall back for targets or it would be better to have none 

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    if akTarget != none

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        ;arcs_Movement.PlayDoWork(akOriginator)

        zlib.ShockActor(akTarget)

        akOriginator.PushActorAway(akTarget, 1.0) ;TODO - replace this with a stagger

        zlib.Moan(akTarget, 100)

        StorageUtil.SetFloatValue(akTarget, "arcs_devious_last_shocked", arcs_Utility.GetTime())

        bool foundPlug = akTarget.WornHasKeyword(zlib.zad_DeviousPlug)
        bool foundPiercing = akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsNipple) || akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsVaginal)

        string shockType = "" 
        
        if foundPlug && foundPiercing
            shockType = "'s plug and piercings give a painful electrical jolt"
        elseif foundPlug
            shockType = "'s plug gives a painful electrical jolt"
        elseif foundPiercing
            shockType = "'s piercings give a painful electrical jolt"
        endif

        string data = akTarget.GetDisplayName() + shockType

        bool result = arcs_SkyrimNet.CreateShortLivedEvent("devious_shock_event_" + akOriginator.GetDisplayName(), "devious_shock_event", "devious shock", data, akOriginator, akTarget)
        result = arcs_SkyrimNet.CreateDirectNarration(data, akTarget)

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

    arcs_Utility.WriteInfo("ArcbotShock_Execute target: " + akTarget, 2)

endfunction

;BINDER

function ArcbotAddArmbinder_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("armbinder", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddArmbinder_Execute")
endfunction

function ArcbotRemoveArmbinder_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("armbinder", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveArmbinder_Execute")
endfunction

;BELT

function ArcbotAddChastityBelt_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("belt", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddChastityBelt_Execute")
endfunction

function ArcbotRemoveChastityBelt_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("belt", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveChastityBelt_Execute")
endfunction

;BLINDFOLD

function ArcbotAddBlindfold_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("blindfold", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddBlindfold_Execute")
endfunction

function ArcbotRemoveBlindfold_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("blindfold", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveBlindfold_Execute")
endfunction

;BOOTS

function ArcbotAddSlaveBoots_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("boots", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddSlaveBoots_Execute")
endfunction

function ArcbotRemoveSlaveBoots_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("boots", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveBoots_Execute")
endfunction

;COLLAR

function ArcbotAddCollar_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("collar", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddCollar_Execute")
endfunction

function ArcbotRemoveCollar_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("collar", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddCollar_Execute")
endfunction

;CORSET

function ArcbotAddCorset_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("corset", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddCorset_Execute")
endfunction

function ArcbotRemoveCorset_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("corset", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveCorset_Execute")
endfunction

;GAG

function ArcbotAddGag_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("gag", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddGag_Execute")
endfunction

function ArcbotRemoveGag_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("gag", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveGag_Execute")
endfunction

;GLOVES

function ArcbotAddSlaveGloves_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("gloves", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddSlaveGloves_Execute")
endfunction

function ArcbotRemoveSlaveGloves_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("gloves", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveGloves_Execute")
endfunction

;HARNESS

function ArcbotAddHarness_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("harness", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddHarness_Execute")
endfunction

function ArcbotRemoveHarness_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("harness", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveHarness_Execute")
endfunction

;HOOD

function ArcbotAddHood_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("hood", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddHood_Execute")
endfunction

function ArcbotRemoveHood_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("hood", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveHood_Execute")
endfunction

;NIPPLE PIERCING

function ArcbotAddNipplePiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("npiercing", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddNipplePiercing_Execute")
endfunction

function ArcbotRemoveNipplePiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("npiercing", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveNipplePiercing_Execute")
endfunction

;VAGINAL PIERCING

function ArcbotAddVaginalPiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("vpiercing", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddVaginalPiercing_Execute")
endfunction

function ArcbotRemoveVaginalPiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("vpercing", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPiercing_Execute")
endfunction

;ANAL PLUG

function ArcbotAddAnalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("aplug", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddAnalPlug_Execute")
endfunction

function ArcbotRemoveAnalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("aplug", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveAnalPlug_Execute")
endfunction

;VAGINAL PLUG

function ArcbotAddVaginalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("vplug", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotAddVaginalPlug_Execute")
endfunction

function ArcbotRemoveVaginalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("vplug", akOriginator, contextJson, paramsJson)
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPlug_Execute")
endfunction


