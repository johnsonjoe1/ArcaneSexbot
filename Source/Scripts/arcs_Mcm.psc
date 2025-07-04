Scriptname arcs_Mcm extends SKI_ConfigBase

bool skyrimNetFound

int toggleShowSexConfirm

int sliderArousalForSex
int sliderSlightlyAroused
int sliderVeryAroused

int keyCodeLeftControl = 29
int keyCodeRightControl = 157
int keyCodeLeftAlt = 56
int keyCodeRightAlt = 184
int keyCodeLeftShift = 42
int keyCodeRightShift = 54

int hotkeyKeymapOption
int hotkeyModifierOption

event OnConfigOpen()
    
    Pages = new string[3]

    Pages[0] = "Settings"
    Pages[1] = "Arousal Settings"
    Pages[2] = "SexLab Tags"

endevent

event OnPageReset(string page)

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
    elseif page == "Arousal Settings"
        DisplayArousal()
    elseif page == "SexLab Tags"
        DisplaySexLabTags()
    endif

    if Game.IsPluginInstalled("SkyrimNet.esp")
        skyrimNetFound = true
    Else
        skyrimNetFound = false
    endif

endevent

function DisplayWelcome()

    AddTextOption("SkyrimNet Found", skyrimNetFound)

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
    hotkeyKeymapOption = AddKeyMapOption("Set hotkey menu hotkey", mHotkey)
    hotkeyModifierOption = AddTextOption("Set hotkey menu modifier", GetModifierString(arcs_GlobalModifierKey.GetValue() as int))

endfunction

function DisplayArousal()

    AddHeaderOption("Arousal Settings")
    AddHeaderOption("")

    sliderArousalForSex = AddSliderOption("Arousal Needed For Sex", arcs_GlobalArousalForSex.GetValue() as int, "{0}")
    sliderSlightlyAroused = AddSliderOption("Slightly Aroused Conversation", arcs_GlobalSlightlyAroused.GetValue() as int, "{0}")
    sliderVeryAroused = AddSliderOption("Very Aroused Conversation", arcs_GlobalVeryAroused.GetValue() as int, "{0}")

endfunction

function DisplaySexLabTags()

    AddHeaderOption("SexLab Tags")
    AddHeaderOption("")



endfunction

event OnOptionSelect(int option)

    if option == toggleShowSexConfirm
        toggleGlobalOnOff(arcs_GlobalShowSexConfirm)
        SetToggleOptionValue(option, arcs_GlobalShowSexConfirm.GetValue())

    endif

    if option == hotkeyModifierOption
        int currentModifier = arcs_GlobalModifierKey.GetValue() as int
        int newModifier = AdvanceModifierValue(currentModifier)
        arcs_GlobalModifierKey.SetValue(newModifier)
        SetTextOptionValue(option, GetModifierString(newModifier))

    endif

endevent

function toggleGlobalOnOff(GlobalVariable g)
    if g.GetValue() == 1
        g.SetValue(0)
    else
        g.SetValue(1)
    endif
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

arcs_Main property main auto