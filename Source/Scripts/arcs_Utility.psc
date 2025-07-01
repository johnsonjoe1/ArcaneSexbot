Scriptname arcs_Utility   

function WriteInfo(string msg) global
    ;get global to see if this is enabled
    MiscUtil.PrintConsole("[Arcane Sexbot]: " + msg)
    Debug.Trace("[Arcane Sexbot]: " + msg)
endfunction
