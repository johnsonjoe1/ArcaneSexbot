Scriptname arcs_Main extends Quest  

Actor thePlayer

float entryDelay = 5.0
float processDelay = 2.0

bool registrationsCompleted = false

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()

    thePlayer = Game.GetPlayer()
    config.ThePlayer = thePlayer

    registrationsCompleted = false ;todo - remove this

    if !registrationsCompleted

        RegisterForCrosshairRef()

        arcs_Utility.WriteInfo("registering key: " + config.arcs_GlobalHotkey.GetValue())
        RegisterForKey(config.arcs_GlobalHotkey.GetValue() as int)

        RegisterForModEvent("AnimationEnd", "OnSexEndEvent")
        RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
        RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

        registrationsCompleted = true

    endif

    RegisterDecorators()
    RegisterActions()

    GoToState("RunSoftChecksState")
    RegisterForSingleUpdate(5.0)

    slab.GameLoaded()

endfunction

function ChangedLocation(Location akOldLoc, Location akNewLoc)

    arcs_Utility.WriteInfo("entered: " + akNewLoc.GetName())

    UnregisterForUpdate()
    GoToState("StartDetectionState")
    RegisterForSingleUpdate(entryDelay)

endfunction

event OnUpdate()
endevent

state RunSoftChecksState

    event OnUpdate()
        RunSoftChecks()
        GoToState("")
    endevent

    function ChangedLocation(Location akOldLoc, Location akNewLoc)
        ;don't run this on soft check startup
    endfunction

endstate

state StartDetectionState

    event OnUpdate()

        if arcs_NudityDetectionQuest.IsRunning()
            arcs_Utility.WriteInfo("stop nudity detection")
            arcs_NudityDetectionQuest.Stop()
            GoToState("StopDetectionState")
            RegisterForSingleUpdate(processDelay)
        else
            arcs_Utility.WriteInfo("start nudity detection")
            arcs_NudityDetectionQuest.Start()
            GoToState("")
        endif

    endevent

endstate

state StopDetectionState

    event OnUpdate()
        if arcs_NudityDetectionQuest.IsRunning()
            arcs_Utility.WriteInfo("waiting for nudity detection stop")
            RegisterForSingleUpdate(processDelay)
        else
            arcs_Utility.WriteInfo("start nudity detection")
            GoToState("StartDetectionState")
            RegisterForSingleUpdate(processDelay)
        endif

    endevent

endstate

function RegisterDecorators()

    SkyrimNetApi.RegisterDecorator("arcs_get_sex_blocked", "arcs_Decorators", "GetActorBlocked")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_purity", "arcs_Decorators", "GetActorSexualPurity")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_preference", "arcs_Decorators", "GetActorSexualPreference")
    SkyrimNetApi.RegisterDecorator("arcs_get_nudity", "arcs_Decorators", "GetActorNudity")
    SkyrimNetApi.RegisterDecorator("arcs_get_arousal", "arcs_Decorators", "GetArousalLevel")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_attraction_to_player", "arcs_Decorators", "GetAttractionToPlayer")
    ;SkyrimNetApi.RegisterDecorator("arcs_sex_min_arousal_check", "arcs_Decorators", "SexMinimumArousalCheck")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_thread_id", "arcs_Decorators", "GetSexThreadId")
    SkyrimNetApi.RegisterDecorator("arcs_in_sex_scene", "arcs_Decorators", "InSexScene")

    SkyrimNetApi.RegisterDecorator("arcs_get_nudity_value", "arcs_Decorators", "GetNudityValue")
    SkyrimNetApi.RegisterDecorator("arcs_get_arousal_value", "arcs_Decorators", "GetArousalValue")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_info", "arcs_Decorators", "GetSexInfo")

    ;other
    ;sex thread ID decorator - pull the sl thread id stored on actor
    ;check sex enjoyment
    ;is victim 
    ;is agressor 

    ;arcs_get_info decorator - return json with nudity, arousal, sex preferences, purity, etc. with one call
    ;min mentioned single calls were more performant

endfunction

function RegisterActions()

    ; SkyrimNetApi.RegisterAction("ExtCmdUpdateSexualPreferences", "Use this to remember that {target} likes {type} as a sexual preference.", \
    ;                                 "arcs_Eligibility", "ExtCmdUpdateSexualPreferences_IsEligible", \
    ;                                 "arcs_Execution", "ExtCmdUpdateSexualPreferences_Execute", \
    ;                                 "", "PAPYRUS", \
    ;                                 1, "{\"target\":\"Actor\",\"type\":\"oral|anal|vaginal|hands\"}", \
    ;                                 "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartSex", "Have {type} sex with {target}.", \
                                    "arcs_Eligibility", "ExtCmdStartSex_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"all|oral|anal|vaginal|hands\",\"intensity\":\"loving|aggressive\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStripTarget", "Remove {target}'s clothing.", \
                                    "arcs_Eligibility", "ExtCmdStripTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdStripTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDressTarget", "Dress {target} back into their clothing.", \
                                    "arcs_Eligibility", "ExtCmdDressTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdDressTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdUndress", "Undress and remove your clothing.", \
                                    "arcs_Eligibility", "ExtCmdUndress_IsEligible", \
                                    "arcs_Execution", "ExtCmdUndress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDress", "Dress back into your clothing.", \
                                    "arcs_Eligibility", "ExtCmdDress_IsEligible", \
                                    "arcs_Execution", "ExtCmdDress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    ;The current serious coversation, lack of sexual stimulus, or combat is making you less horny
    SkyrimNetApi.RegisterAction("ExtCmdDecreaseArousal", "Use this to indicate you are getting less aroused.", \
                                    "arcs_Eligibility", "ExtCmdDecreaseArousal_IsEligible", \
                                    "arcs_Execution", "ExtCmdDecreaseArousal_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    ;The current sexy coversation or sexual events around you are making you horny
    SkyrimNetApi.RegisterAction("ExtCmdIncreaseArousal", "Use this to indicate that you are getting more aroused.", \
                                    "arcs_Eligibility", "ExtCmdIncreaseArousal_IsEligible", \
                                    "arcs_Execution", "ExtCmdIncreaseArousal_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdIncreaseAttraction", "Use this to indicate you are {change_amount} attracted to {target}", \
                                    "arcs_Eligibility", "ExtCmdIncreaseAttraction_IsEligible", \
                                    "arcs_Execution", "ExtCmdIncreaseAttraction_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"change_amount\":\"somewhat more|more|much more\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDecreaseAttraction", "Use this to indicate you are {change_amount} attracted to {target}", \
                                    "arcs_Eligibility", "ExtCmdDecreaseAttraction_IsEligible", \
                                    "arcs_Execution", "ExtCmdDecreaseAttraction_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"change_amount\":\"somewhat less|less|much less\"}", \
                                    "", "")

    ;ExtCmdIncreaseSexualAttraction
    ;ExtCmdDecreaseSexualAttraction


    ;sex_type should be curated tags list, start with tags that minai used for sex events
    ;pull the SL tag selector out of binding?

    ;**********************
    ;other actions
    ;**********************
    ;stop sex
    ;masturbate
    ;multi-party sex?
    
    ;dd items

endfunction

event OnSexEndEvent(string eventName, string argString, float argNum, form sender)

    ;TODO - write an event after sex?
    arcs_Utility.WriteInfo("OnSexEndEvent - eventName: " + eventName + " argString: " + argString + " argNum " + argNum + \
        " sender: " + sender.GetName() + " id: " + sender.GetFormID())

endevent

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpSuspend - sender: " + sender.GetName() + " id: " + sender.GetFormID())
    if (sender != self) 

    endif
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpResume - sender: " + sender.GetName() + " id: " + sender.GetFormID())

endevent

bool processingKey

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

event OnKeyDown(int KeyCode)
    ProcessKey(KeyCode, 0.0)
endevent

function ProcessKey(int keyCode, float holdTime)

    arcs_Utility.WriteInfo("keyCode: " + keyCode)

    if keyCode == config.arcs_GlobalHotkey.GetValue() as int
        if !processingKey                
            processingKey = true

            bool bLeftControPressed = Input.IsKeyPressed(keyCodeLeftControl)
            bool bRightControlPressed = Input.IsKeyPressed(keyCodeRightControl)
            bool bLeftAltPressed = Input.IsKeyPressed(keyCodeLeftAlt)
            bool bRightAltPressed = Input.IsKeyPressed(keyCodeRightAlt)
            bool bLeftShiftPressed = Input.IsKeyPressed(keyCodeLeftShift)
            bool bRightShiftPressed = Input.IsKeyPressed(keyCodeRightShift)
            bool modifiersPressed = (bLeftControPressed || bRightControlPressed || bLeftAltPressed || bRightAltPressed || bLeftShiftPressed || bRightShiftPressed)

            arcs_Utility.WriteInfo("hotkey press time: " + holdTime)

            if (config.arcs_GlobalModifierKey.GetValue() == 0 && !modifiersPressed) || (Input.IsKeyPressed(config.arcs_GlobalModifierKey.GetValue() as int))

                if thePlayer.IsWeaponDrawn()

                    arcs_Utility.WriteInfo("hotkey disabled when combat ready")

                else

                    if holdTime <= 0.5
                        ShowHotkeyMenu()
                    else
                    endif

                endif

            endif

            processingKey = false
        endif
    endif
        

endfunction

function ShowHotkeyMenu()

    ;TODO - hotkey sex stuff needs a reaction from the NPC when you start sex with them
    ;should do a arousal / attraction check and tell the player to piss off if not wanting 
    ;not sure how to handle NC from the players side, should you really need to be able to overpower a target?

    ;sex faction check on actor to block starting more sex
    if thePlayer.IsInFaction(arcs_HavingSexFaction)
        return ;TODO - this should only impact parts of this menu if other settings are available here
    endif

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    
    if inCrosshairs
        listMenu.AddEntryItem("Start sex with " + inCrosshairs.GetDisplayName())
    else
        listMenu.AddEntryItem("No actor targeted for sex")
    endif

    listMenu.AddEntryItem("Masturbate")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1
        if inCrosshairs
            listMenu.AddEntryItem("Devious items for " + inCrosshairs.GetDisplayName())
            listMenu.AddEntryItem("Devious action tests for player")
            listMenu.AddEntryItem("Complex action test for player")

        else
            listMenu.AddEntryItem("No actor targeted for devious items")
            listMenu.AddEntryItem("No actor targeted for action tests")
            listMenu.AddEntryItem("No actor targeted for action tests")
        endif
        
    endif

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0 && inCrosshairs
        bool result = arcs_SkyrimNet.CreateDirectNarration("{{ player.name }} pulls " + inCrosshairs.GetDisplayName() + " close and starts unbuttoning their clothing for sex.", inCrosshairs)
        int arousalVal = arcs_Arousal.GetActorArousalValue(inCrosshairs)
        if arousalVal > 0
            arcs_Utility.WriteInfo("Player started sex event - attraction passed")
            Utility.Wait(5.0)
            Actor[] actors = new Actor[2]
            actors[0] = thePlayer
            actors[1] = inCrosshairs
            if slab.StartSex(actors, "", "")
            else 
                arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
            endif
        else 
            arcs_Utility.WriteInfo("Player started sex event - attraction failed")
        endif

    elseif listReturn == 1
        Actor[] actors = new Actor[1]
        actors[0] = thePlayer
        if slab.StartSex(actors, "", "")
        else 
            arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
        endif

    elseif listReturn == 2 && inCrosshairs
        ShowDeviousMenu(thePlayer, inCrosshairs)

    elseif listReturn == 3 && inCrosshairs
        ShowDeviousMenu(inCrosshairs, thePlayer)

    elseif listReturn == 4 && inCrosshairs
         arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " needs to lock a red ebonite panel gag on " + thePlayer.GetDisplayName(), inCrosshairs, thePlayer)

    ; elseif listReturn == 4 && inCrosshairs
    ;     arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " is removing the metal collar from " + thePlayer.GetDisplayName(), inCrosshairs, thePlayer)

    endif

endfunction

function ShowDeviousMenu(Actor akSource, Actor akTarget)

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    listMenu.AddEntryItem("<-- Back")
    listMenu.AddEntryItem("Add devious item")

    string[] types = StorageUtil.StringListToArray(akTarget, "arcs_dd_items")
    int i = 0
    while i < types.Length
        listMenu.AddEntryItem("Remove - " + arcs_Devious.GetDeviousDisplayName(types[i]))
        i += 1
    endwhile

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0
        ShowHotkeyMenu()
    elseif listReturn == 1
        ShowDeviousAddMenu(akSource, akTarget)
    else 
        int idx = listReturn - 2
        ;debug.MessageBox("listreturn: " + listReturn + " idx: " + idx)
        if idx < types.Length
            string selectedType = types[idx]
           ;debug.MessageBox("selectedType: " + selectedType + " idx: " + idx)
            if selectedType != ""
                if akTarget == thePlayer
                    arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " needs to remove " + selectedType + " from " + akTarget.GetDisplayName(), akSource, akTarget)
                else
                    if arcs_API.RemoveDeviousItem(akSource, akTarget, selectedType, true) == 1
                        arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " removed a " + arcs_Devious.GetDeviousDisplayName(selectedType) + " from " + inCrosshairs.GetDisplayName(), akSource, akTarget)
                        debug.MessageBox("Devious " + arcs_Devious.GetDeviousDisplayName(selectedType) + " removed from " + akTarget.GetDisplayName())
                    endif
                endif
            endif
        endif
    endif

endfunction

function ShowDeviousAddMenu(Actor akSource, Actor akTarget)

    string types = arcs_Devious.DeviousList()
    string[] typesList = StringUtil.Split(types, "|")
    string displayNames = arcs_Devious.DeviousListDisplayNames()
    string[] displayNamesList = StringUtil.Split(displayNames, "|")

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    listMenu.AddEntryItem("<-- Back")

    int i = 0
    while i < typesList.Length
        listMenu.AddEntryItem(displayNamesList[i])
        i += 1
    endwhile

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0
        ShowDeviousMenu(akSource, akTarget)
    else 
        int idx = listReturn - 1
        if idx < typesList.Length - 1
            string selectedType = typesList[idx]
            string selectedTypeDisplayName = displayNamesList[idx]
            if selectedType != ""
                if akTarget == thePlayer
                    string prompt = akSource.GetDisplayName() + " wants to lock a " + selectedType + " on " + akTarget.GetDisplayName()
                    arcs_SkyrimNet.CreateDirectNarration(prompt, akSource, akTarget)
                else
                    if arcs_API.AddRandomDeviousItem(akSource, akTarget, selectedType, true) == 1
                        arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " locked a " + selectedTypeDisplayName + " on " + akTarget.GetDisplayName(), akSource, akTarget)
                        debug.MessageBox("Devious " + selectedTypeDisplayName + " added to " + akTarget.GetDisplayName())
                    endif
                endif
            endif
        endif
    endif
    

endfunction

function ChangeHotkey(int newKeycode)
    if config.arcs_GlobalHotkey.GetValue() > 0
        UnregisterForKey(config.arcs_GlobalHotkey.GetValue() as int)
    endif
    config.arcs_GlobalHotkey.SetValue(newKeycode) 
    RegisterForKey(newKeycode)
endfunction

Actor inCrosshairs

Event OnCrosshairRefChange(ObjectReference ref)
	inCrosshairs = none
	if ref != none
        if ref as Actor
            inCrosshairs = ref as Actor
            arcs_Utility.WriteInfo("OnCrosshairRefChange actor: " + inCrosshairs.GetDisplayName())
        endif
	endIf
EndEvent

function RunSoftChecks()

    if Game.IsPluginInstalled("Devious Devices - Assets.esm")
        config.arcs_GlobalHasDeviousDevices.SetValue(1)
        devious.GameLoaded()
    Else
        config.arcs_GlobalHasDeviousDevices.SetValue(2)
    endif

endfunction

Quest property arcs_NudityDetectionQuest auto

arcs_SexLab property slab auto
arcs_ConfigSettings property config auto
arcs_Devious property devious auto

Faction property arcs_HavingSexFaction auto