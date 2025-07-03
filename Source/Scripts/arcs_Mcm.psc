Scriptname arcs_Mcm extends SKI_ConfigBase

bool skyrimNetFound

int toggleShowSexConfirm

int sliderArousalForSex
int sliderSlightlyAroused
int sliderVeryAroused

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

GlobalVariable property arcs_GlobalArousalForSex auto
GlobalVariable property arcs_GlobalSlightlyAroused auto
GlobalVariable property arcs_GlobalVeryAroused auto
GlobalVariable property arcs_GlobalShowSexConfirm auto

GlobalVariable property arcs_GlobalHotkey auto
GlobalVariable property arcs_GlobalModifierKey auto