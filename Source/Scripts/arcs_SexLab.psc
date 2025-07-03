Scriptname arcs_SexLab extends Quest  

int activeThreads

function GameLoaded()

    activeThreads = 0

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
    SexLabFramework slFramework = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
    return slFramework.IsActorActive(akActor)
endfunction

int function GetActorThreadId(Actor akActor) global
    int result = 0
    SexLabFramework slFramework = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
    result = slFramework.FindActorController(akActor)
    arcs_Utility.WriteInfo("result: " + result)
    int playerThread = slFramework.FindPlayerController() ;for testing
    arcs_Utility.WriteInfo("player threadid : " + playerThread) ;for testing
    return result
endfunction

string function MakeDefaultSLTag(Actor actor1, Actor actor2 = none)
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

bool function StartSex(Actor[] actors, string type, string intensity)

    bool result = false

    string useTags = type

    ;if not type was provided
    if type == ""
        if actors.length == 1
            type = MakeDefaultSLTag(actors[0])
        elseif actors.length == 2
            type = MakeDefaultSLTag(actors[0], actors[1])
        endif
    endif

    string blockTags = ""
    if intensity == "aggressive"
        useTags += ",aggressive"
    else
        blockTags += "aggressive"
    endif

    arcs_Utility.WriteInfo("arcs_SexLab - useTags : " + useTags + " blockTags: " + blockTags)

    sslThreadModel tm = sfx.NewThread()
    if tm
        ;add actors to the thread
        int i = 0
        while i < actors.length
            if !actors[i].IsInFaction(arcs_HavingSexFaction)
                actors[i].AddToFaction(arcs_HavingSexFaction)
            endif
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
            RemoveActorsFromFaction(actors)
            arcs_Utility.WriteInfo("arcs_SexLab - StartThread - StartThread() did not return a thread controller.")   
        endif

    else 
        arcs_Utility.WriteInfo("arcs_SexLab - StartThread - NewTread() creation failed")      

    endif

    arcs_Utility.WriteInfo("arcs_SexLab - result : " + result)

    return result

endfunction

function RemoveActorsFromFaction(Actor[] actors)
    int i = 0
    while i < actors.length
        if actors[i].IsInFaction(arcs_HavingSexFaction)
            actors[i].RemoveFromFaction(arcs_HavingSexFaction)
        endif
        i += 1
    endwhile
endfunction

event OnHavingSexFactionHookOrgasm(Form FormRef, int tid)
    Actor akActor = FormRef as Actor
    arcs_Utility.WriteInfo(akActor.GetDisplayName() + " just had an orgasm")
    if akActor != Game.GetPlayer()

    endif
endevent

event OnStageStart(int tid, bool HasPlayer) ;OnStageStart in minai

endevent

event OnOrgasmStart(int tid, bool HasPlayer) ;PostSexScene in minai

    arcs_Utility.WriteInfo("OnOrgasmStart fired")

endevent

event OnAnimationEnd(int tid, bool HasPlayer) ;EndSexScene in minai

    Actor[] actors = sfx.HookActors(tid)
    RemoveActorsFromFaction(actors)

    arcs_Utility.WriteInfo("OnAnimationEnd fired - sex completed")

endevent

event OnAnimationStart(int tid, bool HasPlayer) ;OnAnimationStart in minai

    Actor[] actors = sfx.HookActors(tid)

    Actor source
    Actor target
    if actors.Length == 1
        source = actors[0]
        target = actors[0]
    else
        source = actors[0]
        target = actors[1]
    endif

    string desc = "Sex started"
    string data = ""

    if actors.length == 1
        data = source.GetDisplayName() + " started to masturbate."
    else
        data = MakeActorsString(actors) + " started to have sex."
    endif

    bool result = arcs_SkyrimNet.CreateShortLivedEvent("Sex_Event_" + tid, "Sex_Event", desc, data, source, target)
    arcs_Utility.WriteInfo("OnAnimationStart - created short term event: " + result)

endevent

event OnOrgasmSeparate(Form actorRef, Int tid) ;SLSOOrgasm in minai

endevent

string function MakeActorsString(Actor[] actorsList) 
    string result = ""
    int i = 0
    while i < actorsList.length
        if result != ""
            result + " and "
        endif
        result += actorsList[i].GetDisplayName()
        i += 1
    endwhile
    return result
endfunction

SexLabFramework property sfx auto

Faction property arcs_HavingSexFaction auto