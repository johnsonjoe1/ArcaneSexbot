Scriptname arcs_SexLab extends Quest  

int activeThreads

arcs_SexLab function GetArcSexLab() global
    return Quest.GetQuest("arcs_MainQuest") as arcs_SexLab
endfunction

SexLabFramework function GetSexLab() global
    return Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
endfunction

function GameLoaded()

    activeThreads = 0

    UnregisterForModEvent("HookStageStart")
    UnregisterForModEvent("HookOrgasmStart")
    UnregisterForModEvent("HookAnimationEnd")
    UnregisterForModEvent("HookAnimationStart")
    UnregisterForModEvent("SexLabOrgasmSeparate")
    UnregisterForModEvent("HavingSexFactionHook_Orgasm")

    RegisterForModEvent("HookStageStart", "OnStageStart")
    RegisterForModEvent("HookOrgasmStart", "OnOrgasmStart")
    RegisterForModEvent("HookAnimationEnd", "OnAnimationEnd")
    RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
    RegisterForModEvent("SexLabOrgasmSeparate", "OnOrgasmSeparate")

    sfx.TrackFaction(arcs_HavingSexFaction, "HavingSexFactionHook")

    ;RegisterForModEvent("ActorHook_End", "DoActorHookEnd") 
    RegisterForModEvent("HavingSexFactionHook_Orgasm", "OnHavingSexFactionHookOrgasm") 

    arcs_Utility.WriteInfo("sl loaded")

endfunction

function CreateDefaultTagsList()
    ;TODO - not sure the plan for this yet
endfunction

bool function ActorInSexScene(Actor akActor) global

    if akActor == none
        return false
    endif

    SexLabFramework slFramework = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
    if slFramework.IsActorActive(akActor)
        return true
    endif

    ;NOTE - this will catch in this mod before the sex scene starts
    arcs_ConfigSettings cfg = Quest.GetQuest("arcs_MainQuest") as arcs_ConfigSettings
    if akActor.IsInFaction(cfg.arcs_HavingSexFaction)
        return true
    Else
        return false
    endif

endfunction

int function GetActorThreadId(Actor akActor) global
    if akActor == none
        return -1
    endif
    int result = 0
    SexLabFramework slFramework = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
    result = slFramework.FindActorController(akActor)
    arcs_Utility.WriteInfo("result: " + result)
    int playerThread = slFramework.FindPlayerController() ;for testing
    arcs_Utility.WriteInfo("player threadid : " + playerThread) ;for testing
    return result
endfunction

string function MakeDefaultSLTag(Actor actor1, Actor actor2 = none)
    if actor1 == none
        return ""
    endif
    string tag = ""
    if actor1.GetActorBase().GetSex() == 1
        tag += "F"
    else
        tag += "M"
    endif
    if actor2
        if actor2.GetActorBase().GetSex() == 1
            tag += "F"
        else
            tag += "M"
        endif
    endif
    if tag == "MF"
        tag = "FM" ;NOTE - might work the other way, but sex lab tags list did not have this version
    endif
    return tag
endfunction

bool function Kiss(Actor akActor1, Actor akActor2)

    bool result = true

	Actor[] sceneActors = new Actor[2]
	sceneActors[0] = akActor1
	sceneActors[1] = akActor2
	sslBaseAnimation[] sanims
	sanims = sfx.GetAnimationsByTags(ActorCount = 2, Tags = "Kissing", TagSuppress = "", RequireAll = true)
	If sanims.Length > 0		
		if sfx.StartSex(Positions = sceneActors, anims = sanims, allowbed = true) == -1
			result = false
		endif
	Else
		Debug.MessageBox("No sexlab animations could be found")
		result = false
    EndIf

endfunction

bool function StartSex(Actor[] actors, string type, string intensity)

    Actor thePlayer = Game.GetPlayer()
    bool playerInScene = false 
    bool busyActors = false
    int i = 0
    while i < actors.length
        if actors[i] == thePlayer
            playerInScene = true
        endif
        if arcs_SexLab.ActorInSexScene(actors[i])
            busyActors = true
        endif
        i += 1
    endwhile

    if busyActors
        arcs_Utility.WriteInfo("arcs_SexLab - StartSex - Failed due to busy actors", 2)
        return false
    endif

    if playerInScene
        ;NOTE - having a problem with sex actions coming in in batches, need to block
        if arcs_API.IsDhlpActive()
            arcs_Utility.WriteInfo("arcs_SexLab - StartSex - DHLP blocked from starting", 2)
            return false
        endif

        if !arcs_Main.StartDhlp()
            arcs_Utility.WriteInfo("arcs_SexLab - StartSex - DHLP suspend failed", 2)
            return false
        endif
    endif
        
    ;TODO - test this with 3p and starting orgies

    bool result = false

    i = 0
    while i < actors.length
        if !actors[i].IsInFaction(arcs_HavingSexFaction)
            actors[i].AddToFaction(arcs_HavingSexFaction)
        endif
        ; if !actors[i].IsInFaction(config.arcs_ActorBusyFaction)
        ;     actors[i].AddToFaction(config.arcs_ActorBusyFaction)
        ; endif
        i += 1
    endwhile

    string useTags = ""
    if type != "all"
        useTags = type
    endif

    ;if not type was provided
    if useTags == ""
        if actors.length == 1
            useTags = MakeDefaultSLTag(actors[0])
        elseif actors.length == 2
            useTags = MakeDefaultSLTag(actors[0], actors[1])
        elseif actors.length == 3
            useTags = "" ;see what it finds??
        endif
    endif

    string blockTags = ""
    if actors.Length > 1
        ;this is not needed for masturbation
        if intensity == "aggressive"
            useTags += ",aggressive"
        else
            blockTags += "aggressive"
        endif
    endif

    arcs_Utility.WriteInfo("arcs_SexLab - type: " + type + " useTags : " + useTags + " blockTags: " + blockTags)

    sslThreadModel tm = sfx.NewThread()
    if tm
        ;add actors to the thread
        i = 0
        while i < actors.length
            ; if !actors[i].IsInFaction(arcs_HavingSexFaction)
            ;     actors[i].AddToFaction(arcs_HavingSexFaction)
            ; endif
            tm.AddActor(actors[i])
            i += 1
        endwhile

        sslBaseAnimation[] ba = sfx.GetAnimationsByTags(ActorCount = actors.Length, Tags = useTags, TagSuppress = blockTags, RequireAll = true)
        if ba.length > 0
            tm.SetAnimations(ba)
        else
            arcs_Utility.WriteInfo("arcs_SexLab - StartThread - GetAnimationsByTags() returned no animations")
        endif

        sslThreadController tc = tm.StartThread()
        if tc           
            result = true
            activeThreads += 1
        else 
            ;RemoveActorsFromFaction(actors)
            arcs_Utility.WriteInfo("arcs_SexLab - StartThread - StartThread() did not return a thread controller.")   
        endif

    else 
        arcs_Utility.WriteInfo("arcs_SexLab - StartThread - NewTread() creation failed")      
        ;RemoveActorsFromFaction(actors)
    endif

    arcs_Utility.WriteInfo("arcs_SexLab - result : " + result)

    if !result
        RemoveActorsFromFaction(actors)
        if arcs_API.IsDhlpActive()
            arcs_Main.EndDhlp()
        endif
        Debug.Notification("Arcane Sexbot - could not start sex scene")
    endif

    return result

endfunction 

function RemoveActorsFromFaction(Actor[] actors)
    int i = 0
    while i < actors.length
        if actors[i].IsInFaction(arcs_HavingSexFaction)
            actors[i].RemoveFromFaction(arcs_HavingSexFaction)
        endif
        ; if actors[i].IsInFaction(config.arcs_ActorBusyFaction)
        ;     actors[i].RemoveFromFaction(config.arcs_ActorBusyFaction)
        ; endif
        i += 1
    endwhile
endfunction

event OnHavingSexFactionHookOrgasm(Form FormRef, int tid)

    Actor akActor = FormRef as Actor
    arcs_Utility.WriteInfo(akActor.GetDisplayName() + " just had an orgasm")

    bool result = arcs_SkyrimNet.CreateDirectNarration(akActor.GetDisplayName() + " is having an orgasm", akActor)
    arcs_Utility.WriteInfo("OnHavingSexFactionHookOrgasm - registered dialogue: " + result + " actor: " + akActor.GetDisplayName())

    ; if akActor != Game.GetPlayer()
    ; endif
    string desc = "Had orgasm"
    string data = akActor.GetDisplayName() + " had an orgasm."
    
    result = arcs_SkyrimNet.CreateShortLivedEvent("sex_event_" + tid + "_" + akActor.GetDisplayName(), "sex_event_orgasm", desc, data, akActor, akActor)
    arcs_Utility.WriteInfo("OnHavingSexFactionHookOrgasm - created short term event: " + result + " actor: " + akActor.GetDisplayName())

endevent

event OnStageStart(int tid, bool HasPlayer) ;OnStageStart in minai

endevent

event OnOrgasmStart(int tid, bool HasPlayer) ;PostSexScene in minai

    arcs_Utility.WriteInfo("OnOrgasmStart fired")

endevent

event OnAnimationEnd(int tid, bool HasPlayer) ;EndSexScene in minai

    Actor[] actors = sfx.HookActors(tid)
    RemoveActorsFromFaction(actors)

    string content = ""
    if actors.length == 1
        content = GetSourceActor(actors).GetDisplayName() + " masturbated."
    else
        content = MakeActorsString(actors) + " had sex."
    endif

    bool result = arcs_SkyrimNet.CreateLongLivedEvent("sex_event", content, GetSourceActor(actors), GetTargetActor(actors))
    arcs_Utility.WriteInfo("OnAnimationStart - created long term event: " + result)

    arcs_Utility.WriteInfo("OnAnimationEnd fired - sex completed")

    if actors.length == 1
        result = arcs_SkyrimNet.CreateDirectNarration(GetSourceActor(actors).GetDisplayName() + " finished masturbating.")
    else
        result = arcs_SkyrimNet.CreateDirectNarration(MakeActorsString(actors) + " finished having sex.") 
    endif

    if arcs_API.IsDhlpActive()
        arcs_Main.EndDhlp()
    endif

endevent

event OnAnimationStart(int tid, bool HasPlayer) ;OnAnimationStart in minai

    Actor[] actors = sfx.HookActors(tid)

    string desc = "Sex started"
    string data = ""

    if actors.length == 1
        data = GetSourceActor(actors).GetDisplayName() + " started to masturbate."
    else
        data = MakeActorsString(actors) + " started to have sex."
    endif

    bool result = arcs_SkyrimNet.CreateShortLivedEvent("sex_event_" + tid, "sex_event", desc, data, GetSourceActor(actors), GetTargetActor(actors))
    arcs_Utility.WriteInfo("OnAnimationStart - created short term event: " + result)
    
    result = arcs_SkyrimNet.CreateDirectNarration(data) 

endevent

event OnOrgasmSeparate(Form actorRef, Int tid) ;SLSOOrgasm in minai

endevent

string function MakeActorsString(Actor[] actorsList) 
    string result = ""
    int i = 0
    while i < actorsList.length
        if result != ""
            if i == actorsList.length - 1
                result += " and "
            else
                result += ", "
            endif
        endif
        result += actorsList[i].GetDisplayName()
        i += 1
    endwhile
    return result
endfunction

Actor function GetSourceActor(Actor[] actorsList) 
    return actorsList[0]
endfunction

Actor function GetTargetActor(Actor[] actorsList) 
    if actorsList.Length == 1
        return none ;if only 1 actor return no value
    else
        return actorsList[1] 
        ;for 2 or more actors, grab the 2nd in the list as the target
        ;TODO - confirm this is OK based on the source/target limitation or if items like events need more entires with different actors?
    endif
endfunction

SexLabFramework property sfx auto

Faction property arcs_HavingSexFaction auto

arcs_ConfigSettings property config auto