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

    arcs_Register.RegisterDecorators()
    arcs_Register.RegisterActions()

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
                        arcs_HotkeyMenu.ShowHotkeyMenu(thePlayer, inCrosshairs)
                    else
                    endif

                endif

            endif

            processingKey = false
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