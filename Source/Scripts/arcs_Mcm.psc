Scriptname arcs_Mcm extends SKI_ConfigBase

bool skyrimNetFound

int toggleActionStartSex
int toggleActionStripTarget
int toggleActionDressTarget
int toggleActionUndress
int toggleActionDress
int toggleActionDecreaseArousal
int toggleActionIncreaseArousal
int toggleActionDecreaseAttraction
int toggleActionIncreaseAttraction

int toggleActionAllDevious

int toggleShowSexConfirm
int toggleDeviousConfirm

int sliderArousalForSex
int sliderSlightlyAroused
int sliderVeryAroused
int toggleUseSexualityInCheck

int toggleAttractionSystem
int toggleAttractionSeeding

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

int hotkeyKeymapOption
int hotkeyModifierOption

int actorCountMenu
int selectSlPageMenu
int selectedActorCount
int selectedSlPage
string[] actorCountArr
string[] slPagesArr
string[] slEditPageArr
int[] slToggleArr

Actor thePlayer

arcs_Main main
arcs_ConfigSettings config

event OnConfigOpen()

    thePlayer = Game.GetPlayer()

    main = Quest.GetQuest("arcs_MainQuest") as arcs_Main
    config = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings

    Pages = new string[8]

    Pages[0] = "Settings"
    Pages[1] = "Arousal Settings"
    Pages[2] = "Attraction Settings"
    Pages[3] = "SexLab Tags"
    Pages[4] = "Manage Actions"
    Pages[5] = "Devious Devices"
    Pages[6] = "Submission & Slavery"
    Pages[7] = "Diagnostics"

    ;load
    actorCountArr = CreateNumberMenu(5)

    slEditPageArr = new string[12]
    slToggleArr = new int[12]

    if selectedActorCount == 0
        selectedActorCount = 1
        selectedSlPage = 1
    endif

endevent

string[] function CreateNumberMenu(int max)
    string str = ""
    int i = 1
    while i <= max
        if str != ""
            str += "|"
        endif
        str += i
        i += 1
    endwhile
    return StringUtil.Split(str, "|")
endfunction

event OnPageReset(string page)

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
    elseif page == "Arousal Settings"
        DisplayArousal()
    elseif page == "Attraction Settings"
        DisplayAttraction()
    elseif page == "SexLab Tags"
        DisplaySexLabTags()
    elseif page == "Manage Actions"
        DisplayActions()
    elseif page == "Diagnostics"
        DisplayDiagnostics()
    elseif page == "Devious Devices"
        DisplayDevious()
    elseif page == "Submission & Slavery"
        DisplaySlavery()

    endif

    if Game.IsPluginInstalled("SkyrimNet.esp")
        skyrimNetFound = true
    Else
        skyrimNetFound = false
    endif

endevent

function DisplayWelcome()

endfunction

function DisplayDiagnostics()

    AddHeaderOption("Requied Mods")
    AddHeaderOption("")

    string found = "No"
    if skyrimNetFound
        found = "Yes"
    endif

    AddTextOption("SkyrimNet", found)
    AddTextOption("", "")

    AddHeaderOption("Optional Mods")
    AddHeaderOption("")

    AddTextOption("Devious Devices", GlobalDetectionString(config.arcs_GlobalHasDeviousDevices))

endfunction

function DisplaySettings()

    AddHeaderOption("Interface Settings")
    AddHeaderOption("")

    toggleShowSexConfirm = AddToggleOption("Show Confirm Before Sex", arcs_GlobalShowSexConfirm.GetValue() as int)
    AddTextOption("", "")

    AddHeaderOption("Key Settings")
    AddHeaderOption("")

    int mHotkey = arcs_GlobalHotkey.GetValue() as int
    if mHotkey == 0
        mHotkey = -1
    endif
    hotkeyKeymapOption = AddKeyMapOption("Set Hotkey Menu Key", mHotkey)
    hotkeyModifierOption = AddTextOption("Set Hotkey Menu Modifier", GetModifierString(arcs_GlobalModifierKey.GetValue() as int))

endfunction

function DisplayArousal()

    AddHeaderOption("Arousal Settings")
    AddHeaderOption("")

    sliderArousalForSex = AddSliderOption("Arousal Needed For Sex", arcs_GlobalArousalForSex.GetValue() as int, "{0}")
    sliderSlightlyAroused = AddSliderOption("Slightly Aroused Conversation", arcs_GlobalSlightlyAroused.GetValue() as int, "{0}")
    sliderVeryAroused = AddSliderOption("Very Aroused Conversation", arcs_GlobalVeryAroused.GetValue() as int, "{0}")



endfunction

function DisplayAttraction()

    AddHeaderOption("Attraction Settings")
    AddHeaderOption("")

    toggleAttractionSystem = AddToggleOption("Use Attraction System", config.arcs_GlobalUseAttractionSystem.GetValue() as int)
    toggleAttractionSeeding = AddToggleOption("Use Attraction Seeding", config.arcs_GlobalUseAttractionSeed.GetValue() as int)

    toggleUseSexualityInCheck = AddToggleOption("Use SL Sexuality - Bi, Gay, Straight", config.arcs_GlobalUseSexualityCheck.GetValue() as int)


endfunction

function DisplaySexLabTags()

    AddHeaderOption("SexLab Tags")
    AddHeaderOption("")

    SexLabFramework sfx = arcs_SexLab.GetSexLab()

    string[] tags = sfx.GetAllAnimationTags(selectedActorCount, true)

    slPagesArr = CreateNumberMenu(Math.Ceiling(tags.Length as float / 12.0))

    actorCountMenu = AddMenuOption("View For Actor Count", selectedActorCount)
    selectSlPageMenu = AddMenuOption("Select Page", selectedSlPage)

    AddTextOption("Total For Count", tags.Length)
    AddTextOption("", "")

    int ip = (12 * (selectedSlPage - 1))
    int i = 0
    while ip < tags.Length && i < 12

        slEditPageArr[i] = tags[ip]

        slToggleArr[i] = AddTextOption(slEditPageArr[i], "")

        ip += 1
        i += 1

    endwhile

endfunction

function DisplayActions()

    AddHeaderOption("Manage Actions")
    AddHeaderOption("")

    toggleActionStartSex = AddToggleOption("Action - Start Sex", config.arcs_GlobalActionStartSex.GetValue() as int)
    AddTextOption("Used Times - Start Sex", arcs_Utility.GetTimesUsed("ExtCmdStartSex", thePlayer))
    toggleActionStripTarget = AddToggleOption("Action - Strip Target", config.arcs_GlobalActionStripTarget.GetValue() as int)
    AddTextOption("Used Times - Strip Target", arcs_Utility.GetTimesUsed("ExtCmdStripTarget", thePlayer))
    toggleActionDressTarget = AddToggleOption("Action - Dress Target", config.arcs_GlobalActionDressTarget.GetValue() as int)
    AddTextOption("Used Times - Dress Target", arcs_Utility.GetTimesUsed("ExtCmdDressTarget", thePlayer))
    toggleActionUndress = AddToggleOption("Action - Undress", config.arcs_GlobalActionUndress.GetValue() as int)
    AddTextOption("Used Times - Undress", arcs_Utility.GetTimesUsed("ExtCmdUndress", thePlayer))
    toggleActionDress = AddToggleOption("Action - Dress", config.arcs_GlobalActionDress.GetValue() as int)
    AddTextOption("Used Times - Dres", arcs_Utility.GetTimesUsed("ExtCmdDress", thePlayer))
    toggleActionDecreaseArousal = AddToggleOption("Action - Decrease Arousal", config.arcs_GlobalActionDecreaseArousal.GetValue() as int)
    AddTextOption("Used Times - Decrease Arousal", arcs_Utility.GetTimesUsed("ExtCmdDecreaseArousal", thePlayer))
    toggleActionIncreaseArousal = AddToggleOption("Action - Increase Arousal", config.arcs_GlobalActionIncreaseArousal.GetValue() as int)
    AddTextOption("Used Times - Increase Arousal", arcs_Utility.GetTimesUsed("ExtCmdIncreaseArousal", thePlayer))
    toggleActionDecreaseAttraction = AddToggleOption("Action - Decrease Attraction", config.arcs_GlobalActionDecreaseAttraction.GetValue() as int)
    AddTextOption("Used Times - Decrease Attraction", arcs_Utility.GetTimesUsed("ExtCmdDecreaseAttraction", thePlayer))
    toggleActionIncreaseAttraction = AddToggleOption("Action - Increase Attraction", config.arcs_GlobalActionIncreaseAttraction.GetValue() as int)
    AddTextOption("Used Times - Increase Attraction", arcs_Utility.GetTimesUsed("ExtCmdIncreaseAttraction", thePlayer))

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1

    AddHeaderOption("Devious Device Actions")
    AddHeaderOption("")

    toggleActionAllDevious = AddToggleOption("Action - All Devious Device", config.arcs_GlobalActionAllDevious.GetValue() as int)

    endif

endfunction

function DisplayDevious()

    AddHeaderOption("Devious Device Settings")
    AddHeaderOption("")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1

        toggleDeviousConfirm = AddToggleOption("Show Confirm For Device Change", config.arcs_GlobalDeviousConfirm.GetValue() as int)
        AddTextOption("", "")


    else
        AddTextOption("Devious Devices Not installed", "")
    endif

endfunction

function DisplaySlavery()

    AddHeaderOption("Submission & Slavery")
    AddHeaderOption("")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1




    else
        AddTextOption("Devious Devices Not installed", "")
    endif

endfunction

event OnOptionMenuOpen(int option)

    if option == actorCountMenu
        SetMenuDialogOptions(actorCountArr)
        SetMenuDialogStartIndex(actorCountArr.Find("" + selectedActorCount))

    elseif option == selectSlPageMenu
        SetMenuDialogOptions(slPagesArr)
        SetMenuDialogStartIndex(slPagesArr.Find("" + selectedSlPage))

    endif

endevent

event OnOptionMenuAccept(int option, int index)

    if option == actorCountMenu
        selectedActorCount = index + 1
        selectedSlPage = 1 ;go back to the first page
        SetMenuOptionValue(actorCountMenu, index + 1)
        ForcePageReset()

    elseif option == selectSlPageMenu
        selectedSlPage = index + 1
        SetMenuOptionValue(selectSlPageMenu, index + 1)
        ForcePageReset() 

    endif

endevent

event OnOptionSelect(int option)

    ;globals
    if option == toggleShowSexConfirm
        SetToggleOptionValue(option, toggleGlobalOnOff(arcs_GlobalShowSexConfirm))
    elseif option == toggleActionStartSex
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStartSex))
    elseif option == toggleActionStripTarget
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionStripTarget))
    elseif option == toggleActionDressTarget
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDressTarget))
    elseif option == toggleActionUndress
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionUndress))
    elseif option == toggleActionDress
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDress))
    elseif option == toggleActionDecreaseArousal
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDecreaseArousal))
    elseif option == toggleActionIncreaseArousal
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionIncreaseArousal))
    elseif option == toggleActionAllDevious
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionAllDevious))
    elseif option == toggleDeviousConfirm
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalDeviousConfirm))
    elseif option == toggleUseSexualityInCheck
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseSexualityCheck))
    elseif option == toggleAttractionSystem
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseAttractionSystem))
    elseif option == toggleAttractionSeeding
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalUseAttractionSeed))
    elseif option == toggleActionDecreaseAttraction
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionDecreaseAttraction))
    elseif option == toggleActionIncreaseAttraction
        SetToggleOptionValue(option, toggleGlobalOnOff(config.arcs_GlobalActionIncreaseAttraction))




    endif

    if option == hotkeyModifierOption
        int currentModifier = arcs_GlobalModifierKey.GetValue() as int
        int newModifier = AdvanceModifierValue(currentModifier)
        arcs_GlobalModifierKey.SetValue(newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))

    endif

endevent

int function toggleGlobalOnOff(GlobalVariable g)
    int newValue
    if g.GetValue() == 1
        g.SetValue(0)
        newValue = 0
    else
        g.SetValue(1)
        newValue = 1
    endif
    return newValue
endfunction

string function GlobalOnOffToString(GlobalVariable g)
    string result = "N/A"
    if g.GetValue() == 0
        result = "No"
    elseif g.GetValue() == 1
        result = "Yes"
    endif
    return result
endfunction

string function GlobalDetectionString(GlobalVariable g)
    string result = "Detecting..."
    if g.GetValue() == 2
        result = "No"
    elseif g.GetValue() == 1
        result = "Yes"
    endif
    return result
endfunction

event OnOptionSliderOpen(Int option)

    if option == sliderArousalForSex
        SetSlider(arcs_GlobalArousalForSex.GetValue(), 50, 1, 100, 1)

    elseif option == sliderSlightlyAroused
        SetSlider(arcs_GlobalSlightlyAroused.GetValue(), 30, 1, 100, 1)

    elseif option == sliderVeryAroused
        SetSlider(arcs_GlobalVeryAroused.GetValue(), 70, 1, 100, 1)

    endif

endevent

function SetSlider(float start, int default, int min, int max, int interval)
    SetSliderDialogStartValue(start)
    SetSliderDialogDefaultValue(default)
    SetSliderDialogRange(min, max)
    SetSliderDialogInterval(interval)
endfunction

event OnOptionSliderAccept(Int option, Float value)

    if option == sliderArousalForSex
        arcs_GlobalArousalForSex.SetValue(value as int)
    elseif option == sliderSlightlyAroused
        arcs_GlobalSlightlyAroused.SetValue(value as int)
    elseif option == sliderVeryAroused
        arcs_GlobalVeryAroused.SetValue(value as int)


    endif

    SetSliderOptionValue(option, value, "{0}")  

endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)

	bool continue = true
	if (conflictControl != "" && keyCode != 1)
		string msg
		if (conflictControl != "")
			msg = "This key is mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\nDo you want to continue?"
		else
			msg = "This key is mapped to:\n'" + conflictControl + "'\n\nDo you want to continue?"
		endIf
		continue = ShowMessage(msg, true, "$Yes", "$No")
	endIf

	; clear if escape key
	if (keyCode == 1)
		keyCode = -1
	endIf

	if (continue)
        if option == hotkeyKeymapOption
            main.ChangeHotkey(keyCode)
            RegisterForKey(keyCode)
            SetKeyMapOptionValue(hotkeyKeymapOption, keyCode)
        endif
    endif

endevent

string function GetModifierString(int modifierValue)
    string modifierStr = "None"
    if modifierValue == keyCodeLeftAlt
        modifierStr = "Left Alt"
    elseif modifierValue == keyCodeRightAlt
        modifierStr = "Right Alt"
    elseif modifierValue == keyCodeLeftShift
        modifierStr = "Left Shift"
    elseif modifierValue == keyCodeRightShift
        modifierStr = "Right Shift"
    elseif modifierValue == keyCodeRightControl
        modifierStr = "Right Control"
    endif
    return modifierStr
endfunction

int function AdvanceModifierValue(int currentModifier)
    int newModifier = 0
    if currentModifier == 0
        newModifier = keyCodeLeftAlt
    elseif currentModifier == keyCodeLeftAlt
        newModifier = keyCodeRightAlt
    elseif currentModifier == keyCodeRightAlt
        newModifier = keyCodeLeftShift
    elseif currentModifier == keyCodeLeftShift
        newModifier = keyCodeRightShift
    elseif currentModifier == keyCodeRightShift
        newModifier = keyCodeRightControl
    elseif currentModifier == keyCodeRightControl
        newModifier = 0
    endif
    return newModifier
endfunction

GlobalVariable property arcs_GlobalArousalForSex auto
GlobalVariable property arcs_GlobalSlightlyAroused auto
GlobalVariable property arcs_GlobalVeryAroused auto
GlobalVariable property arcs_GlobalShowSexConfirm auto

GlobalVariable property arcs_GlobalHotkey auto
GlobalVariable property arcs_GlobalModifierKey auto

; arcs_Main property main auto
; arcs_ConfigSettings property config auto