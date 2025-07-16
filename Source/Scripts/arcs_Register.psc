Scriptname arcs_Register extends Quest  

function RegisterDecorators() global

    ;active
    SkyrimNetApi.RegisterDecorator("arcs_get_nudity", "arcs_Decorators", "GetActorNudity")
    SkyrimNetApi.RegisterDecorator("arcs_get_arousal", "arcs_Decorators", "GetArousalLevel")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_info", "arcs_Decorators", "GetSexInfo")

    ;turn these back on when they are used
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_blocked", "arcs_Decorators", "GetActorBlocked")
    ;SkyrimNetApi.RegisterDecorator("arcs_in_sex_scene", "arcs_Decorators", "InSexScene")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_nudity_value", "arcs_Decorators", "GetNudityValue")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_arousal_value", "arcs_Decorators", "GetArousalValue")

    
    ;retired?
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_purity", "arcs_Decorators", "GetActorSexualPurity")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_preference", "arcs_Decorators", "GetActorSexualPreference")

    ;SkyrimNetApi.RegisterDecorator("arcs_get_attraction_to_player", "arcs_Decorators", "GetAttractionToPlayer")
    ;SkyrimNetApi.RegisterDecorator("arcs_sex_min_arousal_check", "arcs_Decorators", "SexMinimumArousalCheck")
    ;SkyrimNetApi.RegisterDecorator("arcs_get_sex_thread_id", "arcs_Decorators", "GetSexThreadId")


    ;other
    ;sex thread ID decorator - pull the sl thread id stored on actor
    ;check sex enjoyment
    ;is victim 
    ;is agressor 

    ;arcs_get_info decorator - return json with nudity, arousal, sex preferences, purity, etc. with one call
    ;min mentioned single calls were more performant

endfunction

function RegisterActions() global

    ; SkyrimNetApi.RegisterAction("ExtCmdUpdateSexualPreferences", "Use this to remember that {target} likes {type} as a sexual preference.", \
    ;                                 "arcs_Eligibility", "ExtCmdUpdateSexualPreferences_IsEligible", \
    ;                                 "arcs_Execution", "ExtCmdUpdateSexualPreferences_Execute", \
    ;                                 "", "PAPYRUS", \
    ;                                 1, "{\"target\":\"Actor\",\"type\":\"oral|anal|vaginal|hands\"}", \
    ;                                 "", "")

    SkyrimNetApi.RegisterAction("ExtCmdKiss", "Kiss {target}.", \
                                    "arcs_Eligibility", "ExtCmdKiss_IsEligible", \
                                    "arcs_Execution", "ExtCmdKiss_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartMasturbation", "Start masturbating.", \
                                    "arcs_Eligibility", "ExtCmdStartMasturbation_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartMasturbation_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartSex", "Start two person sex.", \
                                    "arcs_Eligibility", "ExtCmdStartSex_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"all|oral|anal|vaginal|hands\",\"intensity\":\"loving|aggressive\"}", \
                                    "", "")

                                ;with {{ decnpc(npc.UUID).name }}, {target1} and {target2}
    SkyrimNetApi.RegisterAction("ExtCmdStartThreePersonSex", "Start three person sex.", \
                                    "arcs_Eligibility", "ExtCmdStartThreePersonSex_IsEligible", \
                                    "arcs_Execution", "ExtCmdStartThreePersonSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"sexpartner2\":\"Actor\",\"intensity\":\"loving|aggressive\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStripTarget", "Remove {target}'s clothing.", \
                                    "arcs_Eligibility", "ExtCmdStripTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdStripTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDressTarget", "Dress {target} back into clothing.", \
                                    "arcs_Eligibility", "ExtCmdDressTarget_IsEligible", \
                                    "arcs_Execution", "ExtCmdDressTarget_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdUndress", "Undress and remove clothing.", \
                                    "arcs_Eligibility", "ExtCmdUndress_IsEligible", \
                                    "arcs_Execution", "ExtCmdUndress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDress", "Dress back into clothing.", \
                                    "arcs_Eligibility", "ExtCmdDress_IsEligible", \
                                    "arcs_Execution", "ExtCmdDress_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    ;The current serious coversation, lack of sexual stimulus, or combat is making you less horny
    SkyrimNetApi.RegisterAction("ExtCmdDecreaseArousal", "Use this to indicate getting less aroused.", \
                                    "arcs_Eligibility", "ExtCmdDecreaseArousal_IsEligible", \
                                    "arcs_Execution", "ExtCmdDecreaseArousal_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    ;The current sexy coversation or sexual events around you are making you horny
    SkyrimNetApi.RegisterAction("ExtCmdIncreaseArousal", "Use this to indicate getting more aroused.", \
                                    "arcs_Eligibility", "ExtCmdIncreaseArousal_IsEligible", \
                                    "arcs_Execution", "ExtCmdIncreaseArousal_Execute", \
                                    "", "PAPYRUS", \
                                    1, "", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdIncreaseAttraction", "Use this to indicate more attracted to {target}", \
                                    "arcs_Eligibility", "ExtCmdIncreaseAttraction_IsEligible", \
                                    "arcs_Execution", "ExtCmdIncreaseAttraction_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"change_amount\":\"somewhat more|more|much more\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdDecreaseAttraction", "Use this to indicate less attracted to {target}", \
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