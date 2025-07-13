Scriptname arcs_DeviousEligibility extends Quest  

bool function DeviousEligibilityChecks(Actor akOriginator, arcs_ConfigSettings config) global 
    bool result = true
    if !arcs_Eligibility.ActorIsEligible(akOriginator) 
        result = false
    endif
    if config.arcs_GlobalActionAllDevious.GetValue() == 0
        return false
    endif
    return true
endfunction

bool function DeviousKeywordCheck(Actor akTarget, Keyword checkFor, Keyword blockKeyword1 = none, Keyword blockKeyword2 = none, Keyword blockKeyword3 = none) global
    bool result = false
    if akTarget != none
        if akTarget.WornHasKeyword(checkFor)
            result = true 
        endif
        if blockKeyword1 != none
            if akTarget.WornHasKeyword(blockKeyword1)
                return false
            endif
        endif
        if blockKeyword2 != none
            if akTarget.WornHasKeyword(blockKeyword2)
                return false
            endif
        endif
        if blockKeyword3 != none
            if akTarget.WornHasKeyword(blockKeyword3)
                return false
            endif
        endif
    else
        return false
    endif
    return result
endfunction

bool function IsEligible(zadLibs zlib, Actor akOriginator, string contextJson, string paramsJson, Keyword findKeyword, bool addItem = true, Keyword blockKeyword1 = none, Keyword blockKeyword2 = none, Keyword blockKeyword3 = none) global
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer)    
    bool keywordCheck = arcs_DeviousEligibility.DeviousKeywordCheck(akTarget, findKeyword, blockKeyword1, blockKeyword2, blockKeyword3) 
    if addItem
        if !keywordCheck && arcs_DeviousEligibility.DeviousEligibilityChecks(akTarget, config)
            return true
        else
            return false
        endif
    else
        if keywordCheck && arcs_DeviousEligibility.DeviousEligibilityChecks(akTarget, config)
            return true
        else
            return false
        endif
    endif
endfunction

;VIBRATE

bool function ArcbotStartVibration_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    bool result = arcs_DeviousEligibility.DeviousEligibilityChecks(akOriginator, config)
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) 
    bool foundPlug = false 
    if aktarget != none
        foundPlug = akTarget.WornHasKeyword(zlib.zad_DeviousPlug)
        if !(foundPlug)
            result = false
        endif
        if akTarget.IsInFaction(config.arcs_GettingVibratedFaction)
            result = false ;already being vibrated
        endif
    else
        result = false
    endif
    arcs_Utility.WriteInfo("ArcbotStartVibration_IsEligible: " + result + " plugs: " + foundPlug, 2)
    return result
endfunction

bool function ArcbotStopVibration_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    bool result = arcs_DeviousEligibility.DeviousEligibilityChecks(akOriginator, config)
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) 
    if aktarget != none
        if !akTarget.IsInFaction(config.arcs_GettingVibratedFaction)
            result = false ;not being vibrated
        endif
    else
        result = false
    endif
    arcs_Utility.WriteInfo("ArcbotStartVibration_IsEligible: " + result, 2)
    return result
endfunction

;SHOCK

bool function ArcbotShock_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    bool result = arcs_DeviousEligibility.DeviousEligibilityChecks(akOriginator, config)
    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", config.ThePlayer) 
    bool foundPlug = false 
    bool foundPiercing = false 
    if aktarget != none
        foundPlug = akTarget.WornHasKeyword(zlib.zad_DeviousPlug)
        foundPiercing = akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsNipple) || akTarget.WornHasKeyword(zlib.zad_DeviousPiercingsVaginal)
        if !(foundPlug || foundPiercing)
            result = false
        endif
    else
        result = false
    endif
    arcs_Utility.WriteInfo("ArcbotShock_IsEligible: " + result + " plugs: " + foundPlug + " piercings: " + foundPiercing, 2)
    return result
endfunction

;BINDER

bool function ArcbotAddArmbinder_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousHeavyBondage, true)
    arcs_Utility.WriteInfo("ArcbotAddArmbinder_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveArmbinder_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousHeavyBondage, false)
    arcs_Utility.WriteInfo("ArcbotRemoveArmbinder_IsEligible: " + result)
    return result
endfunction

;BELT

bool function ArcbotAddChastityBelt_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBelt, true)
    arcs_Utility.WriteInfo("ArcbotAddChastityBelt_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveChastityBelt_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBelt, false, zlib.zad_DeviousCorset, zlib.zad_DeviousHarness, zlib.zad_DeviousSuit)
    arcs_Utility.WriteInfo("ArcbotRemoveChastityBelt_IsEligible: " + result)
    return result
endfunction

;BLINDFOLD

bool function ArcbotAddBlindfold_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBlindfold, true)
    arcs_Utility.WriteInfo("ArcbotAddBlindfold_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveBlindfold_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBlindfold, false, zlib.zad_DeviousHood)
    arcs_Utility.WriteInfo("ArcbotRemoveBlindfold_IsEligible: " + result)
    return result
endfunction

;BOOTS

bool function ArcbotAddSlaveBoots_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBoots, true) ;NOTE - ankles shackles and boots sometimes work together
    arcs_Utility.WriteInfo("ArcbotAddSlaveBoots_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveSlaveBoots_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator,contextJson, paramsJson, zlib.zad_DeviousBoots, false)
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveBoots_IsEligible: " + result)
    return result
endfunction

;COLLAR

bool function ArcbotAddCollar_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousCollar, true)
    arcs_Utility.WriteInfo("ArcbotAddCollar_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveCollar_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousCollar, false, zlib.zad_DeviousHarness)
    arcs_Utility.WriteInfo("ArcbotRemoveCollar_IsEligible: " + result)
    return result
endfunction

;CORSET

bool function ArcbotAddCorset_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousCorset, true)
    arcs_Utility.WriteInfo("ArcbotAddCorset_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveCorset_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousCorset, false)
    arcs_Utility.WriteInfo("ArcbotRemoveCorset_IsEligible: " + result)
    return result
endfunction

;GAG

bool function ArcbotAddGag_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousGag, true)
    arcs_Utility.WriteInfo("ArcbotAddGag_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveGag_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousGag, false, zlib.zad_DeviousHood)
    arcs_Utility.WriteInfo("ArcbotRemoveGag_IsEligible: " + result)
    return result
endfunction

;GLOVES

bool function ArcbotAddSlaveGloves_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousGloves, true)
    arcs_Utility.WriteInfo("ArcbotAddSlaveGloves_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveSlaveGloves_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousGloves, false, zlib.zad_DeviousSuit) ;TODO - look at suits and see if they have this keyword
    arcs_Utility.WriteInfo("ArcbotRemoveSlaveGloves_IsEligible: " + result)
    return result
endfunction

;HARNESS

bool function ArcbotAddHarness_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousHarness, true) ;needs to do a NC check on the item when it equips?
    arcs_Utility.WriteInfo("ArcbotAddHarness_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveHarness_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousHarness, false)
    arcs_Utility.WriteInfo("ArcbotRemoveHarness_IsEligible: " + result)
    return result
endfunction

;HOOD

bool function ArcbotAddHood_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousHood, true)
    arcs_Utility.WriteInfo("ArcbotAddHood_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveHood_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousHood, false)
    arcs_Utility.WriteInfo("ArcbotRemoveHood_IsEligible: " + result)
    return result
endfunction

;NIPPLE PIERCING

bool function ArcbotAddNipplePiercing_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPiercingsNipple, true)
    arcs_Utility.WriteInfo("ArcbotAddNipplePiercing_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveNipplePiercing_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPiercingsNipple, false)
    arcs_Utility.WriteInfo("ArcbotRemoveNipplePiercing_IsEligible: " + result)
    return result
endfunction

;VAGINAL PIERCING

bool function ArcbotAddVaginalPiercing_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPiercingsVaginal, true, zlib.zad_DeviousBelt)
    arcs_Utility.WriteInfo("ArcbotAddVaginalPiercing_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveVaginalPiercing_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPiercingsVaginal, false)
    if akOriginator.GetActorBase().GetSex() != 1
        result = false ;females only
    endif
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPiercing_IsEligible: " + result)   
    return result
endfunction

;ANAL PLUG

bool function ArcbotAddAnalPlug_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPlugAnal, true, zlib.zad_DeviousBelt) ;note - these might work with open belts??
    arcs_Utility.WriteInfo("ArcbotAddAnalPlug_IsEligible: " + result)
    return result
endfunction

bool function ArcbotRemoveAnalPlug_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPlugAnal, false)
    arcs_Utility.WriteInfo("ArcbotRemoveAnalPlug_IsEligible: " + result)
    return result
endfunction

;VAGINAL PLUG

bool function ArcbotAddVaginalPlug_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPlugVaginal, true, zlib.zad_DeviousBelt)
    arcs_Utility.WriteInfo("ArcbotAddVaginalPlug_IsEligible: " + result)
    if akOriginator.GetActorBase().GetSex() != 1
        result = false ;females only
    endif
    return result
endfunction

bool function ArcbotRemoveVaginalPlug_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()
    bool result = arcs_DeviousEligibility.IsEligible(zlib, akOriginator, contextJson, paramsJson, zlib.zad_DeviousPlugVaginal, false)
    arcs_Utility.WriteInfo("ArcbotRemoveVaginalPlug_IsEligible: " + result)
    return result
endfunction