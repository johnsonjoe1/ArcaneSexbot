Scriptname arcs_Utility   

function WriteInfo(string msg) global
    ;get global to see if this is enabled
    MiscUtil.PrintConsole("[Arcane Sexbot]: " + msg)
    Debug.Trace("[Arcane Sexbot]: " + msg)
endfunction

function DoSleep(float f = 0.5) global
    Utility.Wait(f)
endfunction

bool function ConfirmBox(string msg, string yesText = "", string noText = "") global

    arcs_Utility.WriteInfo("displaying confirmbox: " + msg)

    if yesText == ""
        yesText = "Yes"
    else 
        yesText = "Yes - " + yesText
    endif
    if noText == ""
        noText = "No"
    else 
        noText = "No - " + noText
    endif

    int listReturn = 0

    while listReturn < 1

        UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
        listMenu.AddEntryItem(msg)
        listMenu.AddEntryItem(yesText)
        listMenu.AddEntryItem(noText)
        listMenu.OpenMenu()
        listReturn = listMenu.GetResultInt()

    endwhile

    if listReturn == 1
        return true
    else
        return false
    endif

endfunction