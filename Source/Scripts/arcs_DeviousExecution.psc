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

bool function AddExecute(string category, Actor akOriginator, string contextJson, string paramsJson, string actionName) global

    bool result = false

    ;TODO - make an add items cooldown that start and singleupdate for 5 seconds or so, that will set a global flag that will make all devious eligibility fail
    ;between that and the DHLP, most everything should be safe from overlapping now

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none) 
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    zadDeviceLists zDevicesList = arcs_Devious.GetDeviousZadDevicesList()
    string material = SkyrimNetApi.GetJsonString(paramsJson, "material", "") 
    string color = SkyrimNetApi.GetJsonString(paramsJson, "color", "") 
    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 

    if akTarget == none
        return false
    endif

    if aktarget.IsChild()
        return false ;adults only
    endif

    arcs_Utility.StoreTimesUsed(actionName, config.ThePlayer)

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
            string msg = akOriginator.GetDisplayName() + " wants to add a device"
            ;msg = akOriginator.GetDisplayName() + " wants to add " + dev.GetName(), "Allow this?"
            if !arcs_Utility.ConfirmBox(msg, dev.GetName())
                return false
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

            result = true
        endif

    endif

    if result 
        ;add success - write short term event for device removal
        string data = akOriginator.GetDisplayName() + " locked " + dev.GetName() + " on " + akTarget.GetDisplayName()
        bool dnResult = arcs_SkyrimNet.CreateShortLivedEvent("arc_devious_add_" + akOriginator.GetDisplayName(), "arc_devious_add", data, data, akOriginator, akTarget)
    endif

    return result

endfunction

bool function RemoveExecute(string category, Actor akOriginator, string contextJson, string paramsJson, string actionName) global

    bool result = false

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)
    arcs_Utility.StoreTimesUsed(actionName, config.ThePlayer)

    if aktarget == none
        return false
    endif

    if akOriginator == aktarget
        ;don't let the NPCs remove their own gear
        ;might want to make this more granular at some point
        return false
    endif

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    Form dev = StorageUtil.GetFormValue(akTarget, "arcs_worn_item_" + category, none)
    if dev

        if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
            string msg = akOriginator.GetDisplayName() + " wants to remove a device"
            ;msg = akOriginator.GetDisplayName() + " wants to remove - " + dev.GetName(), "Allow this?"
            if !arcs_Utility.ConfirmBox(msg, dev.GetName())
                return false
            endif
        endif

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        arcs_Movement.PlayDoWork(akOriginator)

        if zlib.UnlockDevice(akTarget, dev as Armor, none, none, true)
 
            StorageUtil.StringListRemove(akTarget, "arcs_dd_items", category, true)
            StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + category, none) ;todo - make sure this works

            result = true
 
        endif
        
    else 

        ;TODO - add an mcm option to disable this - ON by default
        ;had a variety of people complian about mods that add items as generic and having biding remove them

        Keyword kw = arcs_Devious.ItemTypeToKeyword(category)

        ;debug.MessageBox("none found - checking category : " + category + " kw: " + kw.GetName())

        if kw != none
            dev = zlib.GetWornRenderedDeviceByKeyword(akTarget, kw)
            ;debug.MessageBox(dev)
            if dev
                if config.arcs_GlobalDeviousConfirm.GetValue() == 1 && akTarget == config.ThePlayer
                    string msg = akOriginator.GetDisplayName() + " wants to remove a device"
                    if !arcs_Utility.ConfirmBox(msg, arcs_Devious.GetDeviousDisplayName(category))
                        return false
                    endif
                endif

                if zlib.UnlockDeviceByKeyword(akTarget, kw, false)
                    result = true
                endif
            endif
        endif

    endif

    if result
        ;remvoe success - write short term event for device removal
        string data = akOriginator.GetDisplayName() + " removed " + dev.GetName() + " from " + akTarget.GetDisplayName()
        bool dnResult = arcs_SkyrimNet.CreateShortLivedEvent("arc_devious_remove_" + akOriginator.GetDisplayName(), "arc_devious_remove", data, data, akOriginator, akTarget)
    endif

    return result

endfunction

;VIBRATE

function ArcbotStartVibration_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("CALLED ArcbotStartVibration_Execute")
    ;debug.MessageBox("in here??")

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    if aktarget == none
        arcs_Utility.WriteInfo("ArcbotStartVibration_Execute no target found")
        return
    endif

    if akTarget.IsChild()
        return ;adults only
    endif

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()

    if !(aktarget.WornHasKeyword(zlib.zad_DeviousPiercingsNipple) || aktarget.WornHasKeyword(zlib.zad_DeviousPiercingsVaginal) || aktarget.WornHasKeyword(zlib.zad_DeviousPlug))
        bool dnResult = arcs_SkyrimNet.CreateDirectNarration(akOriginator.GetDisplayName() + " realizes " + akTarget.GetDisplayName() + " needs nipple piercings, vaginal piercings, or plugs to be vibrated", akOriginator)
        return
    endif

    arcs_Utility.WriteInfo("ArcbotStartVibration_Execute target: " + akTarget, 2)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson, 2)

    string duration = SkyrimNetApi.GetJsonString(paramsJson, "duration", "medium") 
    int seconds = 60
    if duration == "medium"
        seconds = 120
    elseif duration == "long"
        seconds = 180
    endif

    string strength = SkyrimNetApi.GetJsonString(paramsJson, "strength", "very weak")
    int power = 0
    if strength == "very weak"
        power = 1
    elseif strength == "weak"
        power = 2
    elseif strength == "standard"
        power = 3
    elseif strength == "strong"
        power = 4
    elseif strength == "very strong"
        power = 5
    endif

    bool tease = false
    string goal = SkyrimNetApi.GetJsonString(paramsJson, "goal", "orgasm")
    if goal == "tease"
        tease = true
    endif

    if akTarget != none

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        ;arcs_Movement.PlayDoWork(akOriginator)

        ;zlib.SetVibrating(akTarget, 30)

        ; if !aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
        ;     aktarget.AddToFaction(config.arcs_GettingVibratedFaction)
        ; endif

        ; if !aktarget.IsInFaction(config.arcs_ActorBusyFaction)
        ;     aktarget.AddToFaction(config.arcs_ActorBusyFaction)
        ; endif

        int orgasms = zlib.VibrateEffect(akTarget, power, seconds, teaseOnly = tease, silent = false)
        ;this has a timed loop

        ; if aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
        ;     aktarget.RemoveFromFaction(config.arcs_GettingVibratedFaction)
        ; endif

        ; if aktarget.IsInFaction(config.arcs_ActorBusyFaction)
        ;     aktarget.RemoveFromFaction(config.arcs_ActorBusyFaction)
        ; endif

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

    ;debug.Notification("CALLED ArcbotStopVibration_Execute")
    ;debug.MessageBox("in here??")

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    arcs_Utility.WriteInfo("ArcbotStopVibration_Execute target: " + akTarget, 2)

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    if akTarget != none

        zlib.StopVibrating(akTarget)

        ; if aktarget.IsInFaction(config.arcs_GettingVibratedFaction)
        ;     aktarget.RemoveFromFaction(config.arcs_GettingVibratedFaction)
        ; endif

        ; if aktarget.IsInFaction(config.arcs_ActorBusyFaction)
        ;     aktarget.RemoveFromFaction(config.arcs_ActorBusyFaction)
        ; endif

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
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none) ;not sure if the PC is a good fall back for targets or it would be better to have none 
    string strength = SkyrimNetApi.GetJsonString(paramsJson, "strength", "medium")

    if aktarget == none
        arcs_Utility.WriteInfo("ArcbotShock_Execute no target found")
        return
    endif

    if akTarget.IsChild()
        return ;adults only
    endif

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()

    if !(aktarget.WornHasKeyword(zlib.zad_DeviousPiercingsNipple) || aktarget.WornHasKeyword(zlib.zad_DeviousPiercingsVaginal) || aktarget.WornHasKeyword(zlib.zad_DeviousPlug))
        bool dnResult = arcs_SkyrimNet.CreateDirectNarration(akOriginator.GetDisplayName() + " realizes " + akTarget.GetDisplayName() + " needs nipple piercings, vaginal piercings, or plugs to be shocked", akOriginator)
        return
    endif

    if akTarget != none

        arcs_Movement.FaceTarget(akOriginator, akTarget)
        ;arcs_Movement.PlayDoWork(akOriginator)

        zlib.ShockActor(akTarget)

        if strength == "high"
            akOriginator.PushActorAway(akTarget, 0.1) ;TODO - replace this with a stagger
            ;zlib.Moan(akTarget, 100)
            zlib.SexlabMoan(akTarget)
        elseif strength == "medium"
            zlib.SexlabMoan(akTarget)
            bool[] cameraState
            cameraState= zlib.StartThirdPersonAnimation(akTarget, zlib.AnimSwitchKeyword(akTarget, "Horny01"), permitRestrictive=true)
            arcs_Utility.DoSleep(3.0)
            zlib.EndThirdPersonAnimation(akTarget, cameraState, permitRestrictive=true)
        else
            zlib.SexlabMoan(akTarget)
        endif

        StorageUtil.SetFloatValue(akTarget, "arcs_devious_last_shocked", arcs_Utility.GetTime())

        bool foundPlug = akTarget.WornHasKeyword(zlib.zad_DeviousPlug)
        bool foundPiercing = akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsNipple) || akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsVaginal)

        string shockType = akTarget.GetDisplayName()
        
        if foundPlug && foundPiercing
            shockType = "'s plug and piercings give a painful electrical jolt"
        elseif foundPlug
            shockType = "'s plug gives a painful electrical jolt"
        elseif foundPiercing
            shockType = "'s piercings give a painful electrical jolt"
        endif
        if strength == "medium"
            shockType += " that doubles " + akTarget.GetDisplayName() + " over in anguish"
        elseif strength == "high"
            shockType += " that causes " + akTarget.GetDisplayName() + " to collapse"
        endif

        string data = shockType

        bool result = arcs_SkyrimNet.CreateShortLivedEvent("devious_shock_event_" + akOriginator.GetDisplayName(), "devious_shock_event", "devious shock", data, akOriginator, akTarget)
        result = arcs_SkyrimNet.CreateDirectNarration(data, akTarget)

    else 
        arcs_Utility.WriteInfo("No stored DD found")
    endif

    arcs_Utility.WriteInfo("ArcbotShock_Execute target: " + akTarget, 2)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson, 2)

endfunction

;BINDER

function ArcbotAddArmbinder_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("armbinder", akOriginator, contextJson, paramsJson, "ArcbotAddArmbinder")
    arcs_Utility.WriteInfo("ArcbotAddArmbinder_Execute")
endfunction

function ArcbotRemoveArmbinder_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("armbinder", akOriginator, contextJson, paramsJson, "ArcbotRemoveArmbinder")
    arcs_Utility.WriteInfo("ArcbotRemoveArmbinder_Execute")
endfunction

;BELT

function ArcbotAddChastityBelt_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("belt", akOriginator, contextJson, paramsJson, "ArcbotAddChastityBelt")
    arcs_Utility.WriteInfo("ArcbotAddChastityBelt_Execute")
endfunction

function ArcbotRemoveChastityBelt_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("belt", akOriginator, contextJson, paramsJson, "ArcbotRemoveChastityBelt")
    arcs_Utility.WriteInfo("ArcbotRemoveChastityBelt_Execute")
endfunction

;BLINDFOLD

function ArcbotAddBlindfold_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("blindfold", akOriginator, contextJson, paramsJson, "ArcbotAddBlindfold")
    arcs_Utility.WriteInfo("ArcbotAddBlindfold_Execute")
endfunction

function ArcbotRemoveBlindfold_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("blindfold", akOriginator, contextJson, paramsJson, "ArcbotRemoveBlindfold")
    arcs_Utility.WriteInfo("ArcbotRemoveBlindfold_Execute")
endfunction

;BOOTS

function ArcbotAddSlaveBoots_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("boots", akOriginator, contextJson, paramsJson, "ArcbotAddSlaveBoots")
    arcs_Utility.WriteInfo("ArcbotAddSlaveBoots_Execute")
endfunction

function ArcbotRemoveSlaveBoots_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("boots", akOriginator, contextJson, paramsJson, "ArcbotRemoveSlaveBoots")
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveBoots_Execute")
endfunction

;COLLAR

function ArcbotAddCollar_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("collar", akOriginator, contextJson, paramsJson, "ArcbotAddCollar")
    arcs_Utility.WriteInfo("ArcbotAddCollar_Execute")
endfunction

function ArcbotRemoveCollar_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("collar", akOriginator, contextJson, paramsJson, "ArcbotRemoveCollar")
    arcs_Utility.WriteInfo("ArcbotAddCollar_Execute")
endfunction

;CORSET

function ArcbotAddCorset_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("corset", akOriginator, contextJson, paramsJson, "ArcbotAddCorset")
    arcs_Utility.WriteInfo("ArcbotAddCorset_Execute")
endfunction

function ArcbotRemoveCorset_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("corset", akOriginator, contextJson, paramsJson, "ArcbotRemoveCorset")
    arcs_Utility.WriteInfo("ArcbotRemoveCorset_Execute")
endfunction

;GAG

function ArcbotAddGag_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("gag", akOriginator, contextJson, paramsJson, "ArcbotAddGag")
    arcs_Utility.WriteInfo("ArcbotAddGag_Execute")
endfunction

function ArcbotRemoveGag_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("gag", akOriginator, contextJson, paramsJson, "ArcbotRemoveGag")
    arcs_Utility.WriteInfo("ArcbotRemoveGag_Execute")
endfunction

;GLOVES

function ArcbotAddSlaveGloves_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("gloves", akOriginator, contextJson, paramsJson, "ArcbotAddSlaveGloves")
    arcs_Utility.WriteInfo("ArcbotAddSlaveGloves_Execute")
endfunction

function ArcbotRemoveSlaveGloves_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("gloves", akOriginator, contextJson, paramsJson, "ArcbotRemoveSlaveGloves")
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveGloves_Execute")
endfunction

;HARNESS

function ArcbotAddHarness_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("harness", akOriginator, contextJson, paramsJson, "ArcbotAddHarness")
    arcs_Utility.WriteInfo("ArcbotAddHarness_Execute")
endfunction

function ArcbotRemoveHarness_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("harness", akOriginator, contextJson, paramsJson, "ArcbotRemoveHarness")
    arcs_Utility.WriteInfo("ArcbotRemoveHarness_Execute")
endfunction

;HOOD

function ArcbotAddHood_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("hood", akOriginator, contextJson, paramsJson, "ArcbotAddHood")
    arcs_Utility.WriteInfo("ArcbotAddHood_Execute")
endfunction

function ArcbotRemoveHood_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("hood", akOriginator, contextJson, paramsJson, "ArcbotRemoveHood")
    arcs_Utility.WriteInfo("ArcbotRemoveHood_Execute")
endfunction

;NIPPLE PIERCING

function ArcbotAddNipplePiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("npiercing", akOriginator, contextJson, paramsJson, "ArcbotAddNipplePiercing")
    arcs_Utility.WriteInfo("ArcbotAddNipplePiercing_Execute")
endfunction

function ArcbotRemoveNipplePiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("npiercing", akOriginator, contextJson, paramsJson, "ArcbotRemoveNipplePiercing")
    arcs_Utility.WriteInfo("ArcbotRemoveNipplePiercing_Execute")
endfunction

;VAGINAL PIERCING

function ArcbotAddVaginalPiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("vpiercing", akOriginator, contextJson, paramsJson, "ArcbotAddVaginalPiercing")
    arcs_Utility.WriteInfo("ArcbotAddVaginalPiercing_Execute")
endfunction

function ArcbotRemoveVaginalPiercing_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("vpercing", akOriginator, contextJson, paramsJson, "ArcbotRemoveVaginalPiercing")
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPiercing_Execute")
endfunction

;ANAL PLUG

function ArcbotAddAnalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("aplug", akOriginator, contextJson, paramsJson, "ArcbotAddAnalPlug")
    arcs_Utility.WriteInfo("ArcbotAddAnalPlug_Execute")
endfunction

function ArcbotRemoveAnalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("aplug", akOriginator, contextJson, paramsJson, "ArcbotRemoveAnalPlug")
    arcs_Utility.WriteInfo("ArcbotRemoveAnalPlug_Execute")
endfunction

;VAGINAL PLUG

function ArcbotAddVaginalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.AddExecute("vplug", akOriginator, contextJson, paramsJson, "ArcbotAddVaginalPlug")
    arcs_Utility.WriteInfo("ArcbotAddVaginalPlug_Execute")
endfunction

function ArcbotRemoveVaginalPlug_Execute(Actor akOriginator, string contextJson, string paramsJson) global
    arcs_DeviousExecution.RemoveExecute("vplug", akOriginator, contextJson, paramsJson, "ArcbotRemoveVaginalPlug")
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPlug_Execute")
endfunction


