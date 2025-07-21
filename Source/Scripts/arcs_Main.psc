Scriptname arcs_Main extends Quest  

Actor thePlayer

;dectection quest
float entryDelay = 5.0
float processDelay = 2.0

bool registrationsCompleted = false

;hotkey
bool processingKey
int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

arcs_Main function GetArcsMain() global
    return Quest.GetQuest("arcs_MainQuest") as arcs_Main
endfunction

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()

    thePlayer = Game.GetPlayer()
    config.ThePlayer = thePlayer
    gdata.ThePlayer = thePlayer

    ;REMOVE THIS AFTER TESTING
    ; if gdata.DhlpSuspend != gdata.DHLP_STATE_SUSPENDED_OTHER_MOD
    ;     gdata.DhlpSuspend = gdata.DHLP_STATE_OFF
    ; endif

    ; if thePlayer.IsInFaction(config.arcs_ActorBusyFaction)
    ;     thePlayer.RemoveFromFaction(config.arcs_ActorBusyFaction)
    ; endif

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

    ; UnregisterForUpdate()
    ; GoToState("StartDetectionState")
    ; RegisterForSingleUpdate(entryDelay)

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

state DhlpSuspendedState

    event OnKeyDown(int KeyCode)
    endevent

endstate

event OnSexEndEvent(string eventName, string argString, float argNum, form sender)

    ;TODO - write an event after sex?
    arcs_Utility.WriteInfo("OnSexEndEvent - eventName: " + eventName + " argString: " + argString + " argNum " + argNum + \
        " sender: " + sender.GetName() + " id: " + sender.GetFormID())

endevent

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    gdata.DhlpSuspendByMod = sender.GetName()
    GoToState("DhlpSuspendedState")
    ;debug.MessageBox(config.DhlpSuspendByMod + " - " + sender.GetName())
    arcs_Utility.WriteInfo("OnDhlpSuspend - sender: " + sender.GetName() + " id: " + sender.GetFormID())
    if (sender != self) 
        gdata.DhlpSuspend = gdata.DHLP_STATE_SUSPENDED_OTHER_MOD
    else 
        gdata.DhlpSuspend = gdata.DHLP_STATE_SUSPENDED
    endif
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    ;debug.MessageBox("OnDhlpResume")
    arcs_Utility.WriteInfo("OnDhlpResume - sender: " + sender.GetName() + " id: " + sender.GetFormID())
    gdata.DhlpSuspend = gdata.DHLP_STATE_OFF
    GoToState("")
endevent

bool function StartDhlp() global
    bool result = false
    arcs_Data g = arcs_Data.GetArcsData()
    if g.DhlpSuspend == g.DHLP_STATE_OFF
        g.DhlpSuspend = g.DHLP_STATE_SUSPENDING
        g.SendModEvent("dhlp-Suspend")
        result = true
    endif
    return result
endfunction

function EndDhlp() global
    arcs_Data g = arcs_Data.GetArcsData()
    if g.DhlpSuspend == g.DHLP_STATE_SUSPENDED
        g.DhlpSuspend = g.DHLP_STATE_RESUMING
        g.SendModEvent("dhlp-Resume")
    endif
endfunction

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
                        hotkey.ShowHotkeyMenu(thePlayer, inCrosshairs)
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
        devious.FakeDecorators()
    endif

endfunction

bool function ActorBusy(Actor akActor) global

    bool result = true

    ; SexLabFramework slFramework = arcs_SexLab.GetSexLab()
    ; if slFramework.IsActorActive(akActor)
    ;     result = true
    ; endif

    if (akActor.Is3DLoaded() && !akActor.IsDead() && !akActor.IsDisabled() && akActor.GetCurrentScene() == none && !akActor.IsInCombat())
        result = false
    endif

    arcs_Utility.WriteInfo("ActorBusy - actor: " + akActor.GetDisplayName() + " result: " + result, 2)

    ;Other tests??

    ;vibrated??

    return result

endfunction

Quest property arcs_NudityDetectionQuest auto

arcs_SexLab property slab auto
arcs_ConfigSettings property config auto
arcs_Devious property devious auto
arcs_Data property gdata auto
arcs_HotkeyMenu property hotkey auto
