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

    registrationsCompleted = false ;todo - remove this

    if !registrationsCompleted

        arcs_Utility.WriteInfo("registering key: " + config.arcs_GlobalHotkey.GetValue())
        RegisterForKey(config.arcs_GlobalHotkey.GetValue() as int)

        RegisterDecorators()
        RegisterActions()

        RegisterForModEvent("AnimationEnd", "OnSexEndEvent")
        RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
        RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

        registrationsCompleted = true

    endif

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
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_purity", "arcs_Decorators", "GetActorSexualPurity")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_preference", "arcs_Decorators", "GetActorSexualPreference")
    SkyrimNetApi.RegisterDecorator("arcs_get_nudity", "arcs_Decorators", "GetActorNudity")
    SkyrimNetApi.RegisterDecorator("arcs_get_arousal", "arcs_Decorators", "GetArousalLevel")
    SkyrimNetApi.RegisterDecorator("arcs_get_attraction_to_player", "arcs_Decorators", "GetAttractionToPlayer")
    SkyrimNetApi.RegisterDecorator("arcs_sex_min_arousal_check", "arcs_Decorators", "SexMinimumArousalCheck")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_thread_id", "arcs_Decorators", "GetSexThreadId")
    SkyrimNetApi.RegisterDecorator("arcs_in_sex_scene", "arcs_Decorators", "InSexScene")

    ;other
    ;sex thread ID decorator - pull the sl thread id stored on actor
    ;check sex enjoyment
    ;is victim 
    ;is agressor 

endfunction

function RegisterActions()

    SkyrimNetApi.RegisterAction("ExtCmdUpdateSexualPreferences", "Use this to remember that {target} likes {type} as a sexual preference.", \
                                    "arcs_Eligibility", "ExtCmdUpdateSexualPreferences_IsEligible", \
                                    "arcs_Execution", "ExtCmdUpdateSexualPreferences_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"oral|anal|vaginal|hands\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartSex", "Have {type} sex with {target}.", \
                                    "arcs_Eligibility", "ExtCmdStartSex_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"oral|anal|vaginal|hands\",\"intensity\":\"loving|aggressive\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStripTarget", "Remove {target}'s clothing'.", \
                                    "arcs_Eligibility", "ExtCmdStripTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdStripTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDressTarget", "Dress {target} back into their clothing'.", \
                                    "arcs_Eligibility", "ExtCmdDressTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdDressTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdUndress", "Undress and remove your clothing.'.", \
                                    "arcs_Eligibility", "ExtCmdUndress_IsEligible", \
                                    "arcs_Execution", "ExtCmdUndress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDress", "Dress back into your clothing.'.", \
                                    "arcs_Eligibility", "ExtCmdDress_IsEligible", \
                                    "arcs_Execution", "ExtCmdDress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")


    ;sex_type should be curated tags list, start with tags that minai used for sex events
    ;pull the SL tag selector out of binding?

    ;**********************
    ;other actions
    ;**********************
    ;stop sex
    ;speed up sex
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

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    listMenu.AddEntryItem("Start Sex with ...")
    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

endfunction

Quest property arcs_NudityDetectionQuest auto

arcs_SexLab property slab auto
arcs_ConfigSettings property config auto