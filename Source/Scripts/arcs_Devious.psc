Scriptname arcs_Devious extends Quest  

;zadLibs zlib

zadLibs function GetDeviousZadlibs() global
    return Quest.GetQuest("zadQuest") as zadLibs
endfunction

zadDeviceLists function GetDeviousZadDevicesList() global
    return Quest.GetQuest("zadxQuest") as zadDeviceLists
endfunction

function GameLoaded()

    ;zlib = GetDeviousZadlib()

    RegisterDecorators()
    RegisterActions()

endfunction

string function DeviousRestraintsList() global
    return "yoke|armbinder|collar|gag|blindfold|hood|harness|arm cuffs|leg cuffs|gloves|boots|corset|suit/catsuit"
endfunction

function RegisterModEvents()
    
    SkyrimNetApi.RegisterDecorator("arcs_devious_enabled", "arcs_DeviousDecorators", "GetDeviousEnabled")

endfunction

function RegisterActions()

    SkyrimNetApi.RegisterAction("AddBdsmRestraint", "Use this to equip {type} on {target}.", \
                                    "arcs_DeviousEligibility", "ExtCmdAddBdsmDevice_IsEligible", \
                                    "arcs_DeviousExecution", "ExtCmdAddBdsmDevice_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"" + arcs_Devious.DeviousRestraintsList() + "\"}", \
                                    "", "")  

    SkyrimNetApi.RegisterAction("RemoveBdsmRestraint", "Use this to remove a single {type} from {target}.", \
                                    "arcs_DeviousEligibility", "ExtCmdRemoveBdsmDevice_IsEligible", \
                                    "arcs_DeviousExecution", "ExtCmdRemoveBdsmDevice_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"type\":\"" + arcs_Devious.DeviousRestraintsList() + "\"}", \
                                    "", "")  

    SkyrimNetApi.RegisterAction("RemoveAllBdsmRestraints", "Use this to remove ALL restraints from {target}", \                              
                                    "arcs_DeviousEligibility", "RemoveAllBdsmRestraints_IsEligible", \
                                    "arcs_DeviousExecution", "RemoveAllBdsmRestraints_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\"}", \
                                    "", "") 
    ;todo:
    ;add/remove chastity
    ;add/remove plugs
    ;add/remove piercings

endfunction

function RegisterDecorators()

    ;item description decorators

endfunction

Keyword function ItemTypeToKeyword(string type) global

    zadLibs zlib = arcs_Devious.GetDeviousZadlibs()

    if type == "collar"
        return zlib.zad_DeviousCollar
    
    elseif type == "wrist restraints"
        return zlib.zad_DeviousHeavyBondage

    else
        return none
    endif

endfunction

;NOTE - this code will not work in this mod, but will be super handy for binding

; int function CAN_EQUIP_LIST()
;     return 1
; endfunction

; int function CAN_REMOVE_LIST()
;     return 2
; endfunction

; string function CreateDeviousItemsTypes(Actor akActor, int direction)

;     string list = ""

;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Collar", akActor.WornHasKeyword(zlib.zad_DeviousCollar), direction), "|", false)
;     list = arcs_Utility.AppendStringToStringList(list, AddItemToTypesList("Wrist Restraints", akActor.WornHasKeyword(zlib.zad_DeviousHeavyBondage), direction), "|", false)

; endfunction

; string function AddItemToTypesList(string name, bool found, int direction)
;     string result = ""
;     if direction == CAN_EQUIP_LIST()
;         if !found 
;             result = name
;         endif
;     elseif direction == CAN_REMOVE_LIST()
;         if found
;             result = name
;         endif
;     endif
;     return result
; endfunction

