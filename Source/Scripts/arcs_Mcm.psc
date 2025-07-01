Scriptname arcs_Mcm extends SKI_ConfigBase

bool skyrimNetFound

event OnConfigOpen()
    
    Pages = new string[1]

    Pages[0] = "Settings"


endevent

event OnPageReset(string page)

    SetCursorFillMode(LEFT_TO_RIGHT)
    SetCursorPosition(0)

    if page == ""
        DisplayWelcome()
    elseif page == "Settings"
        DisplaySettings()
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

endfunction