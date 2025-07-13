Scriptname arcs_DeviousRegister extends Quest  

function RegisterActions() global

    ;******************************
    ;other bondage actions
    ;******************************
    ;hogtied
    ;bondage sets
    ;store favorite set
    ;favorite an item
    ;bind to furniture
    ;vibrate plug
    ;shock?

    SkyrimNetApi.RegisterAction("ArcbotStartVibration", "Starts plugs vibrating to give {taget} sexual pleasure.", "arcs_DeviousEligibility", "ArcbotStartVibration_IsEligible", \
        "arcs_DeviousExecution", "ArcbotStartVibration_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"duration\":\"short|medium|long\"}", "", "")

    SkyrimNetApi.RegisterAction("ArcbotStopVibration", "Starts plugs vibrating to give {taget} sexual pleasure.", "arcs_DeviousEligibility", "ArcbotStopVibration_IsEligible", \
        "arcs_DeviousExecution", "ArcbotStopVibration_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")

    SkyrimNetApi.RegisterAction("ArcbotShock", "Makes piercings and plugs give {target} a shock for sexual pleasure or torment.", "arcs_DeviousEligibility", "ArcbotShock_IsEligible", \
        "arcs_DeviousExecution", "ArcbotShock_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")

    ;BINDER
    SkyrimNetApi.RegisterAction("ArcbotAddArmbinder", "Equip a armbinder on {target} to bind their hands", "arcs_DeviousEligibility", "ArcbotAddArmbinder_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddArmbinder_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveArmbinder", "Remove a armbinder from {target} to unbind their hands", "arcs_DeviousEligibility", "ArcbotRemoveArmbinder_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveArmbinder_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  
 
    ;BELT
    SkyrimNetApi.RegisterAction("ArcbotAddChastityBelt", "Equip a chastity belt over {target}'s hips", "arcs_DeviousEligibility", "ArcbotAddChastityBelt_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddChastityBelt_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"type\":\"open|closed\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveChastityBelt", "Remove a chastity belt from {target}'s hips", "arcs_DeviousEligibility", "ArcbotRemoveChastityBelt_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveChastityBelt_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  
    
    ;BLINDFOLD        
    SkyrimNetApi.RegisterAction("ArcbotAddBlindfold", "Equip a blindfold over {target}'s eyes'", "arcs_DeviousEligibility", "ArcbotAddBlindfold_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddBlindfold_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"cloth|ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveBlindfold", "Remove a blindfold from {target}'s eyes", "arcs_DeviousEligibility", "ArcbotRemoveBlindfold_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveBlindfold_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;BOOTS
    SkyrimNetApi.RegisterAction("ArcbotAddSlaveBoots", "Equip a slave boots on {target}'s feet", "arcs_DeviousEligibility", "ArcbotAddSlaveBoots_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddSlaveBoots_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"metal|ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveSlaveBoots", "Remove a slave boots from {target}'s feet", "arcs_DeviousEligibility", "ArcbotRemoveSlaveBoots_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveSlaveBoots_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;COLLAR
    SkyrimNetApi.RegisterAction("ArcbotAddCollar", "Equip a collar on {target}'s neck", "arcs_DeviousEligibility", "ArcbotAddCollar_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddCollar_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|metal|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveCollar", "Remove a collar from {target}'s neck", "arcs_DeviousEligibility", "ArcbotRemoveCollar_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveCollar_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;CORSET - needs pattern options also
    SkyrimNetApi.RegisterAction("ArcbotAddCorset", "Equip a corset on {target}'s waist", "arcs_DeviousEligibility", "ArcbotAddCorset_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddCorset_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveCorset", "Remove a corset from {target}'s waist", "arcs_DeviousEligibility", "ArcbotRemoveCorset_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveCorset_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;GAG
    SkyrimNetApi.RegisterAction("ArcbotAddGag", "Equip a gag in {target}'s mouth", "arcs_DeviousEligibility", "ArcbotAddGag_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddGag_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|rope\",\"color\":\"black|red|white\",\"type\":\"ball|panel|ring\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveGag", "Remove a gag from {target}'s mouth", "arcs_DeviousEligibility", "ArcbotRemoveGag_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveGag_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;GLOVES
    SkyrimNetApi.RegisterAction("ArcbotAddSlaveGloves", "Equip a slave gloves on {target}'s hands", "arcs_DeviousEligibility", "ArcbotAddSlaveGloves_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddSlaveGloves_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveSlaveGloves", "Remove a slave gloves from {target}'s hands", "arcs_DeviousEligibility", "ArcbotRemoveSlaveGloves_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveSlaveGloves_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;HARNESS
    SkyrimNetApi.RegisterAction("ArcbotAddHarness", "Equip a slave harness over {target}'s chest", "arcs_DeviousEligibility", "ArcbotAddHarness_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddHarness_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"material\":\"ebonite|leather|metal|rope\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveHarness", "Remove a slave harness from {target}'s chest", "arcs_DeviousEligibility", "ArcbotRemoveHarness_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveHarness_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;HOOD
    SkyrimNetApi.RegisterAction("ArcbotAddHood", "Equip a hood over {target}'s head", "arcs_DeviousEligibility", "ArcbotAddHood_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddHood_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\",\"color\":\"black|red|white\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveHood", "Remove a hood from {target}'s head", "arcs_DeviousEligibility", "ArcbotRemoveHood_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveHood_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;NIPPLE PIERCING
    SkyrimNetApi.RegisterAction("ArcbotAddNipplePiercing", "Equip nipple piercings on {target}", "arcs_DeviousEligibility", "ArcbotAddNipplePiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddNipplePiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveNipplePiercing", "Remove nipple piercings from {target}", "arcs_DeviousEligibility", "ArcbotRemoveNipplePiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveNipplePiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;VAGINAL PIERCING
    SkyrimNetApi.RegisterAction("ArcbotAddVaginalPiercing", "Equip vaginal piercing on {target}", "arcs_DeviousEligibility", "ArcbotAddVaginalPiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddVaginalPiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveVaginalPiercing", "Remove vaginal piercing from {target}", "arcs_DeviousEligibility", "ArcbotRemoveVaginalPiercing_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveVaginalPiercing_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;ANAL PLUG
    SkyrimNetApi.RegisterAction("ArcbotAddAnalPlug", "Insert an anal plug in {target}'s ass", "arcs_DeviousEligibility", "ArcbotAddAnalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddAnalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveAnalPlug", "Remove an anal plug from {target}'s ass", "arcs_DeviousEligibility", "ArcbotRemoveAnalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveAnalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    ;VAGINAL PLUG
    SkyrimNetApi.RegisterAction("ArcbotAddVaginalPlug", "Insert an vaginal plug in {target}", "arcs_DeviousEligibility", "ArcbotAddVaginalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotAddVaginalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  

    SkyrimNetApi.RegisterAction("ArcbotRemoveVaginalPlug", "Remove an vaginal plug from {target}", "arcs_DeviousEligibility", "ArcbotRemoveVaginalPlug_IsEligible", \
        "arcs_DeviousExecution", "ArcbotRemoveVaginalPlug_Execute", "", "PAPYRUS", 1, "{\"target\":\"Actor\"}", "", "")  




endfunction

function RegisterDecorators() global

    ;active

    ;turn on when needed
    ;SkyrimNetApi.RegisterDecorator("arcs_get_devious_info", "arcs_DeviousDecorators", "GetDeviousInfo")
    ;SkyrimNetApi.RegisterDecorator("arcs_devious_enabled", "arcs_DeviousDecorators", "GetDeviousEnabled")
    ;SkyrimNetApi.RegisterDecorator("arcs_devious_hours_since_last_shocked", "arcs_DeviousDecorators", "GetDeviousHoursSinceLastShocked") ;{"last_shocked":0} - hours since event rounded down
    ;SkyrimNetApi.RegisterDecorator("arcs_devious_being_vibrated", "arcs_DeviousDecorators", "GetDeviousBeingVibrated") ;{"being_vibrated":1} -1 no actor, 0 no, 1 yes



    ;dd enabled decorator
    ;item description decorators & time worn (return json)


    ;min's example:
    ;{% set my_payload = get_worn_gear_info(actorUUID) %}
    ;{% if worn_has_keyword(actorUUID, "zad_DeviousBelt") %}
    ;  - {{ actor_name }} is locked in a {{ my_payload.belt.description }} for {{ my_payload.belt.duration }}, denying (etc)


    ;what's in the bondage bag decorator
    ;this would use a favorites list to let the dom/top know these are the items that they can use for play
    ;getting a lot of tie in silk ropes comments from LLM when adding metal cuffs

endfunction