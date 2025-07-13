Scriptname arcs_DeviousDecorators extends Quest  

string function GetDeviousEnabled(Actor akActor) global
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    return arcs_Utility.JsonIntValueReturn("devious_enabled", config.arcs_GlobalActionAllDevious.GetValue() as int)
endfunction

string function GetDeviousHoursSinceLastShocked(Actor akActor) global
    float lastShocked = -1.0 
    if akActor != none
        lastShocked = StorageUtil.GetFloatValue(akActor, "arcs_devious_hours_since_last_shocked", 0.0)
    endif
    int hoursSince = 0
    if lastShocked > 0.0
        hoursSince = arcs_Utility.GetElapsedHours(lastShocked, arcs_Utility.GetTime(), false)
    endif
    return arcs_Utility.JsonIntValueReturn("last_shocked", hoursSince)
endfunction

string function GetDeviousBeingVibrated(Actor akActor) global
    ;-1 no actor, 0 - no, 1 - yes
    arcs_ConfigSettings config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    int vibrated = -1
    if akActor != none
        if akActor.IsInFaction(config.arcs_GettingVibratedFaction)
            vibrated = 1
        endif
    endif
    return arcs_Utility.JsonIntValueReturn("being_vibrated", vibrated)
endfunction

string function GetDeviousInfo(Actor akActor) global

    return "{\"test\":1}"

    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker

    string[] types = StorageUtil.StringListToArray(akActor, "arcs_dd_items")

    string output = "{"

    ; int idx = 0
    ; while idx < types.Length

    ;     string type = types[idx]

    ;     Form dev = StorageUtil.GetFormValue(akActor, "arcs_worn_item_" + type, none)
    ;     float timeEquipped = StorageUtil.GetFloatValue(akActor, "arcs_worn_time_" + type, 0.0)
    ;     float currentTime = arcs_Utility.GetTime()

    ;     if dev

    ;     output += "\"" + type + "\":{"
    ;     output += "\"description\":\"" + dev.GetName() + "\","
    ;     output += "\"duration\":\"" + arcs_Utility.GetElapsedHours(timeEquipped, currentTime, false) + "}"
    ;     output += "}"

    ;     endif

    ;     idx += 1

    ;     if dev
    ;         if idx < types.length
    ;             output += "," ;more items in list
    ;         endif
    ;     endif

    ; endwhile


    ; Form[] inventory = akActor.GetContainerForms()
    ; int idx = 0
    ; while idx < inventory.Length
    ;     Form item = inventory[idx]
    ;     if akActor.IsEquipped(item)

    ;     endif
    ;     idx += 1
    ; endwhile

        ;StorageUtil.StringListAdd(akTarget, "arcs_dd_items", type, false)
        ;StorageUtil.SetFormValue(akTarget, "arcs_worn_item_" + type, dev)
        ;StorageUtil.SetFloatValue(akTarget, "arcs_worn_time_" + type, arcs_Utility.GetTime())

    ; output += "\"npcname\":\"" + akActor.GetDisplayName() + "\","
    ; output += "\"having_sex\":" + inSceneInt + ","
    ; output += "\"nudity\":" + nudity + ","
    ; output += "\"attraction_enabled\":" + attractionEnabled + ","
    ; output += "\"attraction\":" + attraction + ","
    ; output += "\"arousal_sex\":" + arousalNeeded + ","
    ; output += "\"slightly_aroused\":" + slightlyArousedThreshold + ","
    ; output += "\"very_aroused\":" + veryArousedThreshold + ","
    ; output += "\"arousal\":" + arousal

    output += "}"

    ; output += "\"arousal_needed_for_sex\":" + arousalNeeded + ","
    ; output += "\"needed_for_slightly_aroused\":" + slightlyArousedThreshold + ","
    ; output += "\"needed_for_very_aroused\":" + veryArousedThreshold + ","
    ; output += "\"purity\":" + purity + ","
    ; output += "\"sexuality\":" + sexuality + ","
    ; output += "\"gender\":" + gender + ","
    ; output += "\"attraction_enabled\":" + attractionEnabled + ","
    ; output += "\"attraction\":" + attraction

    ; output += "}"

    arcs_Utility.WriteInfo(output)

    return output

endfunction