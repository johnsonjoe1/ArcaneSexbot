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

Form[] function GetStrippedItems(Actor akActor) global 
    string storageKey = "arcs_stripped_items"
    return StorageUtil.FormListToArray(akActor, storageKey)
endfunction

function StoreStrippedItems(Actor akActor, Form[] items) global
    string storageKey = "arcs_stripped_items"
    StorageUtil.FormListClear(akActor, storageKey)
    int i = 0
    while i < items.Length
        StorageUtil.FormListAdd(akActor, storageKey, items[i], true) ;needs to allow duplicates - dual swords / daggers /etc.
        i += 1
    endwhile
endfunction

string function AppendStringToStringList(string list, string item, string seperator, bool spaceAfterSeperator = false) global
    if item == ""
        return list
    endif
    if list == ""
        list = item
    else
        list += seperator
        if spaceAfterSeperator
            list += " "
        endif
        list += item
    endif
    return list
endfunction

function StoreTimesUsed(string actionName, Actor akActor) global
    actionName = "arcs_times_used_" + actionName
    StorageUtil.SetIntValue(akActor, actionName, StorageUtil.GetIntValue(akActor, actionName, 0) + 1)
endfunction

int function GetTimesUsed(string actionName, Actor akActor) global
    actionName = "arcs_times_used_" + actionName
    return StorageUtil.GetIntValue(akActor, actionName, 0)
endfunction

string function JsonIntValueReturn(string name, int value) global
    return "{\"" + name + "\":\"" + value + "\"}"    
endfunction