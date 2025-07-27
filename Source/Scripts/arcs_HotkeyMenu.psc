Scriptname arcs_HotkeyMenu extends Quest  

function ShowHotkeyMenu(Actor thePlayer, Actor inCrosshairs)

    arcs_SexLab slab = arcs_SexLab.GetArcSexLab()

    ;TODO - hotkey sex stuff needs a reaction from the NPC when you start sex with them
    ;should do a arousal / attraction check and tell the player to piss off if not wanting 
    ;not sure how to handle NC from the players side, should you really need to be able to overpower a target?

    ;sex faction check on actor to block starting more sex
    if arcs_Main.ActorBusy(thePlayer)
        return ;TODO - this should only impact parts of this menu if other settings are available here
    endif

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu
    
    if inCrosshairs
        listMenu.AddEntryItem("Start sex " + inCrosshairs.GetDisplayName())
    else
        listMenu.AddEntryItem("No actor targeted for sex")
    endif

    listMenu.AddEntryItem("Masturbate")
    listMenu.AddEntryItem("Get Stats")

    if config.arcs_GlobalHasDeviousDevices.GetValue() == 1
        if inCrosshairs
            listMenu.AddEntryItem("Devious items for " + inCrosshairs.GetDisplayName())
            listMenu.AddEntryItem("Devious items for player")
            listMenu.AddEntryItem("TEST - Devious action tests for player")
            listMenu.AddEntryItem("TEST - Action test for npc - masturbate")
            ;listMenu.AddEntryItem("TEST - Action test for npc - kiss")
        else
            listMenu.AddEntryItem("n/a")
            listMenu.AddEntryItem("n/a")
            listMenu.AddEntryItem("n/a")
            listMenu.AddEntryItem("n/a")
            ;listMenu.AddEntryItem("n/a")
        endif
    endif

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0 && inCrosshairs
        
        ;int arousalVal = arcs_Arousal.GetActorArousalValue(inCrosshairs)
        ;debug.MessageBox(arousalVal)
        slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
        int arousalVal = slau.GetActorArousal(inCrosshairs)
        int arousalNeeded = config.arcs_GlobalArousalForSex.GetValue() as int
        if arousalVal >= arousalNeeded || config.arcs_GlobalUseArousal.GetValue() == 0
            Debug.Notification(inCrosshairs.GetDisplayName() + " is aroused enough for sex...")
            ;bool result = arcs_SkyrimNet.CreateDirectNarration("{{ player.name }} wants to have sex, " + inCrosshairs.GetDisplayName() + " is aroused and ready for it.", inCrosshairs)
        ;if arousalVal > 0
            arcs_Utility.WriteInfo("Player started sex event - attraction passed")
            ;Utility.Wait(5.0)
            Actor[] actors = new Actor[2]
            actors[0] = thePlayer
            actors[1] = inCrosshairs
            if config.arcs_GlobalUseOstim.GetValue() == 1 && config.arcs_GlobalHasOstim.GetValue() == 1
                ;ostim
                arcs_Ostim ost = arcs_Ostim.GetOstim()
                if ost.StartSex(actors, "oral", "")
                    debug.MessageBox("started ostim")
                else
                    arcs_Utility.WriteInfo("arcs_Ostim - StartSex failed")
                endif
            else
                ;sex lab
                if slab.StartSex(actors, "", "")
                else 
                    arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
                endif
            endif
        else 
            Debug.Notification(inCrosshairs.GetDisplayName() + " is not aroused enough for sex...")
            bool result = arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " turns down {{ player.name }} trying to start sex.", inCrosshairs)
            arcs_Utility.WriteInfo("Player started sex event - attraction failed")
        endif

    elseif listReturn == 1
        Actor[] actors = new Actor[1]
        actors[0] = thePlayer

        if config.arcs_GlobalUseOstim.GetValue() == 1 && config.arcs_GlobalHasOstim.GetValue() == 1
            ;ostim
            arcs_Ostim ost = arcs_Ostim.GetOstim()
            if ost.StartSex(actors, "", "")
                debug.MessageBox("started ostim")
            else
                arcs_Utility.WriteInfo("arcs_Ostim - StartSex failed")
            endif
        else
            ;sex lab
            if slab.StartSex(actors, "", "")
            else 
                arcs_Utility.WriteInfo("arcs_SexLab - StartSex failed")
            endif
        endif


    elseif listReturn == 2 && inCrosshairs
        debug.MessageBox("Stats - arousal: " + arcs_Arousal.GetActorArousalValue(inCrosshairs) + " attraction to " + config.ThePlayer.GetDisplayName() + ": " + arcs_Attraction.GetAttractionToPlayer(inCrosshairs))

    elseif listReturn == 3 && inCrosshairs
        ShowDeviousMenu(thePlayer, inCrosshairs, false)

    elseif listReturn == 4 && inCrosshairs
        ShowDeviousMenu(inCrosshairs, thePlayer, false)

    elseif listReturn == 5 && inCrosshairs
        ShowDeviousMenu(inCrosshairs, thePlayer, true)

    elseif listReturn == 6 && inCrosshairs
        arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " gets an unstoppable urge to masturbate", inCrosshairs)

    elseif listReturn == 7 && inCrosshairs
        arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " gets an unstoppable urge to kiss " + thePlayer.GetDisplayName(), inCrosshairs)
        ;arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " casts a spell to activate the vibrating plug in " + thePlayer.GetDisplayName() + "'s ass", thePlayer)

    ; elseif listReturn == 4 && inCrosshairs
    ;     arcs_SkyrimNet.CreateDirectNarration(inCrosshairs.GetDisplayName() + " is removing the metal collar from " + thePlayer.GetDisplayName(), inCrosshairs, thePlayer)

    ; elseif listReturn == 8 && inCrosshairs
    ;     if !slab.Kiss(thePlayer, inCrosshairs)
    ;         debug.MessageBox("the kiss failed")
    ;     endif

    endif

endfunction

function ShowDeviousMenu(Actor akSource, Actor akTarget, bool useDirectNarration = false)

    Actor thePlayer = Game.GetPlayer()

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    listMenu.AddEntryItem("<-- Back")
    listMenu.AddEntryItem("Add devious item")

    string[] types = StorageUtil.StringListToArray(akTarget, "arcs_dd_items")
    int i = 0
    while i < types.Length
        listMenu.AddEntryItem("Remove - " + arcs_Devious.GetDeviousDisplayName(types[i]))
        i += 1
    endwhile

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0
        if akSource == thePlayer
            ShowHotkeyMenu(akSource, akTarget)
        else
            ShowHotkeyMenu(akTarget, akSource)
        endif
    elseif listReturn == 1
        ShowDeviousAddMenu(akSource, akTarget, useDirectNarration)
    else 
        int idx = listReturn - 2
        ;debug.MessageBox("listreturn: " + listReturn + " idx: " + idx)
        if idx < types.Length
            string selectedType = types[idx]
           ;debug.MessageBox("selectedType: " + selectedType + " idx: " + idx)
            if selectedType != ""
                if akTarget == thePlayer
                    if useDirectNarration
                        arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " wants to remove " + arcs_Devious.GetDeviousDisplayName(selectedType) + " from " + akTarget.GetDisplayName(), akSource, akTarget)
                    else
                        if arcs_API.RemoveDeviousItem(akSource, akTarget, selectedType, true) == 1
                            arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " removed a " + arcs_Devious.GetDeviousDisplayName(selectedType) + " from " + akTarget.GetDisplayName(), akSource, akTarget)
                            debug.MessageBox("Devious " + arcs_Devious.GetDeviousDisplayName(selectedType) + " removed from " + akTarget.GetDisplayName())
                        endif
                    endif
                else
                    if arcs_API.RemoveDeviousItem(akSource, akTarget, selectedType, true) == 1
                        arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " removed a " + arcs_Devious.GetDeviousDisplayName(selectedType) + " from " + akTarget.GetDisplayName(), akSource, akTarget)
                        debug.MessageBox("Devious " + arcs_Devious.GetDeviousDisplayName(selectedType) + " removed from " + akTarget.GetDisplayName())
                    endif
                endif
            endif
        endif
    endif

endfunction

function ShowDeviousAddMenu(Actor akSource, Actor akTarget, bool useDirectNarration = false)

    string types = arcs_Devious.DeviousList()
    string[] typesList = StringUtil.Split(types, "|")
    string displayNames = arcs_Devious.DeviousListDisplayNames()
    string[] displayNamesList = StringUtil.Split(displayNames, "|")

    UIListMenu listMenu = UIExtensions.GetMenu("UIListMenu") as UIListMenu

    listMenu.AddEntryItem("<-- Back")

    int i = 0
    while i < typesList.Length
        listMenu.AddEntryItem(displayNamesList[i])
        i += 1
    endwhile

    listMenu.OpenMenu()
    int listReturn = listMenu.GetResultInt()

    if listReturn == 0
        ShowDeviousMenu(akSource, akTarget)
    else 
        int idx = listReturn - 1
        if idx < typesList.Length
            string selectedType = typesList[idx]
            string selectedTypeDisplayName = displayNamesList[idx]
            if selectedType != ""
                if akTarget == Game.GetPlayer()
                    if useDirectNarration
                        string prompt = akSource.GetDisplayName() + " wants to lock a " + arcs_Devious.GetDeviousDisplayName(selectedType) + " on " + akTarget.GetDisplayName()
                        arcs_SkyrimNet.CreateDirectNarration(prompt, akSource, akTarget)
                    else
                        if arcs_API.AddRandomDeviousItem(akSource, akTarget, selectedType, true) == 1
                            arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " locked a " + selectedTypeDisplayName + " on " + akTarget.GetDisplayName(), akSource, akTarget)
                            debug.MessageBox("Devious " + selectedTypeDisplayName + " added to " + akTarget.GetDisplayName())
                        endif
                    endif
                else
                    if arcs_API.AddRandomDeviousItem(akSource, akTarget, selectedType, true) == 1
                        arcs_SkyrimNet.CreateDirectNarration(akSource.GetDisplayName() + " locked a " + selectedTypeDisplayName + " on " + akTarget.GetDisplayName(), akSource, akTarget)
                        debug.MessageBox("Devious " + selectedTypeDisplayName + " added to " + akTarget.GetDisplayName())
                    endif
                endif
            endif
        endif
    endif
    

endfunction

arcs_ConfigSettings property config auto