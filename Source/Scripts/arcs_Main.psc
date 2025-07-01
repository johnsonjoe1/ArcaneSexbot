Scriptname arcs_Main extends Quest  

float entryDelay = 5.0
float processDelay = 2.0

bool registrationsCompleted = false

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()

    registrationsCompleted = false ;todo - remove this

    if !registrationsCompleted

        RegisterDecorators()
        RegisterActions()

        RegisterForModEvent("AnimationEnd", "OnSexEndEvent")
        RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
        RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

        registrationsCompleted = true

    endif

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


endfunction

function RegisterActions()

    SkyrimNetApi.RegisterAction("ExtCmdUpdateSexualPreferences", "Use this to remember that {target} likes {sex_type} as a sexual preference.", \
                                    "arcs_Eligibility", "ExtCmdUpdateSexualPreferences_IsEligible", \
                                    "arcs_Execution", "ExtCmdUpdateSexualPreferences_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"sex_type\":\"gentle|rough|oral|anal|vaginal\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartSex", "Have {sex_type} sex with {target}.", \
                                    "arcs_Eligibility", "ExtCmdStartSex_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"sex_type\":\"gentle|rough\"}", \
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
    ;strip target
    ;undress
    ;dress
    ;multi-party sex?
    
    ;dd items

endfunction

event OnSexEndEvent(string eventName, string argString, float argNum, form sender)

endevent

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpSuspend - sender: " + sender.GetName() + " id: " + sender.GetFormID())
    if (sender != self) 

    endif
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpResume - sender: " + sender.GetName() + " id: " + sender.GetFormID())

endevent

Quest property arcs_NudityDetectionQuest auto