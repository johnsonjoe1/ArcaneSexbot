Scriptname arcs_Execution extends Quest  

function ExtCmdKiss_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdKiss_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ExtCmdKiss_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    ;OSTIM has kissing animations that don't undress
    if (config.arcs_GlobalHasOstim.GetValue() == 0) || (config.arcs_GlobalUseOstim.GetValue() == 0)
        return
    endif

    arcs_Utility.StoreTimesUsed("ExtCmdKiss", config.ThePlayer)
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    Actor[] actors = new Actor[2]
    actors[0] = akOriginator
    actors[1] = akTarget

    ;ostim
    arcs_Ostim ost = arcs_Ostim.GetOstim()

    if ost.StartSex(actors, "Kissing", "", true)
        ;debug.MessageBox("started ostim")
    else
        arcs_Utility.WriteInfo("arcs_Ostim - StartSex failed")
    endif

    arcs_Utility.WriteInfo("ExtCmdKiss_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)


endfunction


function ExtCmdStartMasturbation_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdStartMasturbation_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ExtCmdStartMasturbation_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    arcs_Utility.StoreTimesUsed("ExtCmdStartSex", config.ThePlayer)

    arcs_Utility.WriteInfo("ExtCmdStartMasturbation_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

	Actor[] actors = new Actor[1]
	actors[0] = akOriginator

    arcs_SexLab slab = Quest.GetQuest("arcs_MainQuest") as arcs_SexLab
    if slab.StartSex(actors, "", "")
        ;debug.Notification("arcs_SexLab - StartSex success")
    else 
        arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
        ;debug.Notification("arcs_SexLab - StartSex failed")
    endif

endfunction

function ExtCmdStartSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdStartSex_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ExtCmdStartSex_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    arcs_Utility.StoreTimesUsed("ExtCmdStartSex", config.ThePlayer)
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    if arcs_SexLab.ActorInSexScene(akTarget)
        return
    endif

    if config.arcs_GlobalShowSexConfirm.GetValue() == 1 && akTarget == config.ThePlayer
        if !arcs_Utility.ConfirmBox("Have sex with " + akOriginator.GetDisplayName() + "?", "Continue the sex scene", "Skip the sex scene")
            return
        endif
    endif

    arcs_Utility.WriteInfo("ExtCmdStartSex_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 
    string intensity = SkyrimNetApi.GetJsonString(paramsJson, "intensity", "") 

    Actor[] actors = new Actor[2]
    actors[0] = akOriginator
    actors[1] = akTarget

    if config.arcs_GlobalUseOstim.GetValue() == 1 && config.arcs_GlobalHasOstim.GetValue() == 1

        ;ostim
        arcs_Ostim ost = arcs_Ostim.GetOstim()

        if ost.StartSex(actors, type, intensity)
            ;debug.MessageBox("started ostim")
        else
            arcs_Utility.WriteInfo("arcs_Ostim - StartSex failed")
        endif

    else

        ;sex lab
        arcs_SexLab slab = Quest.GetQuest("arcs_MainQuest") as arcs_SexLab
        if slab.StartSex(actors, type, intensity)
        else 
            arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
        endif

    endif

endfunction


function ArcbotSpeedUpSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdStartMasturbation_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ArcbotSpeedUpSex_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    arcs_Utility.StoreTimesUsed("ArcbotSpeedUpSex", config.ThePlayer)

    int ThreadID = OActor.GetSceneID(akOriginator)

    if ThreadID == -1
        return
    endif

    string sceneId = OThread.GetScene(ThreadID)
    float maxSpeed = OMetadata.GetMaxSpeed(sceneId)
    int newOstimSpeed = OThread.GetSpeed(ThreadID) + 1
    if(newOstimSpeed <= maxSpeed)
        OThread.SetSpeed(ThreadID, newOstimSpeed)
    endif

endfunction

function ArcbotSlowDownSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdStartMasturbation_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ArcbotSlowDownSex_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    arcs_Utility.StoreTimesUsed("ArcbotSlowDownSex", config.ThePlayer)

    int ThreadID = OActor.GetSceneID(akOriginator)

    if ThreadID == -1
        return
    endif

    int newOstimSpeed = OThread.GetSpeed(ThreadID) - 1
    if(newOstimSpeed >= 0)
        OThread.SetSpeed(ThreadID, newOstimSpeed)
    endif

endfunction





function ExtCmdStartThreePersonSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;debug.Notification("ExtCmdStartThreePersonSex_Execute - actor: " + akOriginator.GetDisplayName())

    arcs_Utility.WriteInfo("ExtCmdStartThreePersonSex_Execute - actor: " + akOriginator.GetDisplayName() + " contextJson: " + contextJson + " paramsJson: " + paramsJson, 2)

    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    arcs_Utility.StoreTimesUsed("ExtCmdStartThreePersonSex", config.ThePlayer)
    Actor akTarget1 = SkyrimNetApi.GetJsonActor(paramsJson, "target", none) 
    Actor akTarget2 = SkyrimNetApi.GetJsonActor(paramsJson, "sexpartner2", none) 

    ;TODO - need to OK checks since no target in eligibility

    if arcs_SexLab.ActorInSexScene(akTarget1) || arcs_SexLab.ActorInSexScene(akTarget1)
        return
    endif

    if config.arcs_GlobalShowSexConfirm.GetValue() == 1 && (akTarget1 == config.ThePlayer || akTarget2 == config.ThePlayer)
        if !arcs_Utility.ConfirmBox("Have 3 way sex with " + akOriginator.GetDisplayName() + "?", "Continue the sex scene", "Skip the sex scene")
            return
        endif
    endif

    string type = "" ; SkyrimNetApi.GetJsonString(paramsJson, "type", "") 
    string intensity = SkyrimNetApi.GetJsonString(paramsJson, "intensity", "") 

	Actor[] actors = new Actor[3]
	actors[0] = akOriginator
	actors[1] = akTarget1
    actors[2] = akTarget2

    arcs_SexLab slab = Quest.GetQuest("arcs_MainQuest") as arcs_SexLab
    if slab.StartSex(actors, type, intensity)
    else 
        arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
    endif

endfunction

function ExtCmdUpdateSexualPreferences_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdUpdateSexualPreferences", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdUpdateSexualPreferences_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", thePlayer) ;todo - pull this from the quest?

endfunction

function ExtCmdStripTarget_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdStripTarget", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdStripTarget_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none) 

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    Form[] strippedItems = sfx.StripActor(akTarget, akTarget, false, false)
    
    arcs_Utility.StoreStrippedItems(akTarget, strippedItems)

endfunction

function ExtCmdDressTarget_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdDressTarget", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdDressTarget")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", none)

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    Form[] strippedItems = arcs_Utility.GetStrippedItems(akTarget)
    if strippedItems
        sfx.UnstripActor(akTarget, strippedItems, false)
    endif

endfunction

function ExtCmdUndress_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdUndress", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdUndress")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Form[] strippedItems = sfx.StripActor(akOriginator, none, true, false)
    
    arcs_Utility.StoreStrippedItems(akOriginator, strippedItems)

endfunction

function ExtCmdDress_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdDress", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdDress_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Form[] strippedItems = arcs_Utility.GetStrippedItems(akOriginator)
    if strippedItems
        arcs_Movement.PlayDressUndress(akOriginator)
        sfx.UnstripActor(akOriginator, strippedItems, false)
    endif

endfunction

function ExtCmdDecreaseArousal_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdDecreaseArousal", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdDecreaseArousal_Execute")
    ;slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    ;Faction slaArousalFaction = slau.slaArousal

    arcs_Arousal.ChangeActorExposure(akOriginator, -1)

    ;debug.MessageBox(akOriginator.GetFactionRank(slaArousalFaction))

endfunction

function ExtCmdIncreaseArousal_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdIncreaseArousal", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdIncreaseArousal_Execute")
    ;slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    ;Faction slaArousalFaction = slau.slaArousal

    arcs_Arousal.ChangeActorExposure(akOriginator, 1)

    ;debug.MessageBox(akOriginator.GetFactionRank(slaArousalFaction))

endfunction


function ExtCmdDecreaseAttraction_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdDecreaseAttraction", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdDecreaseAttraction_Execute")

    string changeAmount = SkyrimNetApi.GetJsonString(paramsJson, "change_amount", "") 
    int change = 0
    if changeAmount == "somewhat less"
        change = -1
    elseif changeAmount == "less"
        change = -3
    elseif changeAmount == "much less"
        change = -5
    endif

    if change != 0
        arcs_Attraction.ChangeAttractionToPlayer(akOriginator, change)
    endif

endfunction

function ExtCmdIncreaseAttraction_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    Actor thePlayer = Game.GetPlayer()
    arcs_Utility.StoreTimesUsed("ExtCmdIncreaseAttraction", thePlayer)

    arcs_Utility.WriteInfo("ExtCmdIncreaseAttraction_Execute")

    string changeAmount = SkyrimNetApi.GetJsonString(paramsJson, "change_amount", "") 
    int change = 0
    if changeAmount == "somewhat more"
        change = 1
    elseif changeAmount == "more"
        change = 3
    elseif changeAmount == "much more"
        change = 5
    endif

    if change != 0
        arcs_Attraction.ChangeAttractionToPlayer(akOriginator, change)
    endif

endfunction