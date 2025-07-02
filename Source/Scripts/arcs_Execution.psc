Scriptname arcs_Execution extends Quest  

;TODO - move sexlab functions to their own script
function ExtCmdStartSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;TODO - confirm message box?
    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    listMenu.AddEntryItem("Have sex with " + akOriginator.GetDisplayName() + "?")
    listMenu.AddEntryItem("Skip the sex scene ")
    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()
    if listReturn == 1
        return
    endif

    arcs_Utility.WriteInfo("ExtCmdStartSex_Execute")

    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    string type = SkyrimNetApi.GetJsonString(paramsJson, "type", "") 
    string intensity = SkyrimNetApi.GetJsonString(paramsJson, "intensity", "") 

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    if !akTarget
        return ;need a message
    endif

    bool result

    string useTags = type + "," + intensity

    if useTags == ""
        if akOriginator.GetActorBase().GetSex() == 1
            useTags += "F"
        else
            useTags += "M"
        endif
        if akTarget
            if akTarget.GetActorBase().GetSex() == 1
                useTags += "F"
            else
                useTags += "M"
            endif
        endif
        if useTags == "MF"
            useTags = "FM" ;NOTE - might work the other way, but sex lab tags list did not have this version
        endif
    endif

	Actor[] sceneActors = new Actor[2]
	sceneActors[0] = akOriginator
	sceneActors[1] = akTarget
	sslBaseAnimation[] sanims
	; sanims = sfx.GetAnimationsByTags(ActorCount = 2, Tags = "Aggressive", TagSuppress = "", RequireAll = true)
	; If sanism.Length == 0
	; 	sanims = sfx.PickAnimationsByActors(sceneActors)
	; EndIf
	;sanims = sfx.PickAnimationsByActors(Positions = sceneActors, Limit = 64, Aggressive = true)
	sanims = sfx.GetAnimationsByTags(ActorCount = 2, Tags = useTags, TagSuppress = "", RequireAll = true)
	If sanims.Length > 0		
		if sfx.StartSex(Positions = sceneActors, anims = sanims, allowbed = true) == -1
			result = false
		endif
	Else
		Debug.MessageBox("No sexlab animations could be found")
		result = false
    EndIf

    ;been using quick start in binding. need to get SL thread here.

endfunction

function ExtCmdUpdateSexualPreferences_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdUpdateSexualPreferences_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

endfunction

function ExtCmdStripTarget_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdStripTarget_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    Form[] strippedItems = sfx.StripActor(akTarget, akTarget, false, false)
    
    arcs_Execution.StoreStrippedItems(akTarget, strippedItems)

endfunction

function ExtCmdDressTarget_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdDressTarget_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    arcs_Movement.FaceTarget(akOriginator, akTarget)
    arcs_Movement.PlayDoWork(akOriginator)

    Form[] strippedItems = arcs_Execution.GetStrippedItems(akTarget)
    if strippedItems
        sfx.UnstripActor(akTarget, strippedItems, false)
    endif

endfunction

function ExtCmdUndress_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdUndress_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Form[] strippedItems = sfx.StripActor(akOriginator, none, true, false)
    
    arcs_Execution.StoreStrippedItems(akOriginator, strippedItems)

endfunction

function ExtCmdDress_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdDress_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Form[] strippedItems = arcs_Execution.GetStrippedItems(akOriginator)
    if strippedItems
        arcs_Movement.PlayDressUndress(akOriginator)
        sfx.UnstripActor(akOriginator, strippedItems, false)
    endif

endfunction

Form[] function GetStrippedItems(Actor akActor) global 
    string storageKey = "arcs_stripped_items"
    return StorageUtil.FormListToArray(akActor, storageKey)
endfunction

function StoreStrippedItems(Actor akActor, Form[] items) global
    string storageKey = "arcs_stripped_items"
    StorageUtil.FormListClear(akActor, storageKey)
    int i = 0
    while i < items.Length
        StorageUtil.FormListAdd(akActor, storageKey, items[i], true) ;needs to allow duplicates - dual swords / daggers /etc.
        i += 1
    endwhile
endfunction