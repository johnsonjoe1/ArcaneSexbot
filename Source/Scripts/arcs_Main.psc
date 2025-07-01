Scriptname arcs_Main extends Quest  

float entryDelay = 5.0
float processDelay = 2.0

bool registrationsCompleted = false

event OnInit()

    if self.IsRunning()
        GameLoaded()
    endif

endevent

function GameLoaded()

    registrationsCompleted = false ;todo - remove this

    if !registrationsCompleted

        RegisterDecorators()
        RegisterActions()

        RegisterForModEvent("AnimationEnd", "OnSexEndEvent")
        RegisterForModEvent("dhlp-Suspend", "OnDhlpSuspend")
        RegisterForModEvent("dhlp-Resume", "OnDhlpResume") 

        registrationsCompleted = true

    endif

endfunction

function ChangedLocation(Location akOldLoc, Location akNewLoc)

    arcs_Utility.WriteInfo("entered: " + akNewLoc.GetName())

    UnregisterForUpdate()
    GoToState("StartDetectionState")
    RegisterForSingleUpdate(entryDelay)

endfunction

event OnUpdate()
endevent

state StartDetectionState

    event OnUpdate()

        if arcs_NudityDetectionQuest.IsRunning()
            arcs_Utility.WriteInfo("stop nudity detection")
            arcs_NudityDetectionQuest.Stop()
            GoToState("StopDetectionState")
            RegisterForSingleUpdate(processDelay)
        else
            arcs_Utility.WriteInfo("start nudity detection")
            arcs_NudityDetectionQuest.Start()
            GoToState("")
        endif

    endevent

endstate

state StopDetectionState

    event OnUpdate()
        if arcs_NudityDetectionQuest.IsRunning()
            arcs_Utility.WriteInfo("waiting for nudity detection stop")
            RegisterForSingleUpdate(processDelay)
        else
            arcs_Utility.WriteInfo("start nudity detection")
            GoToState("StartDetectionState")
            RegisterForSingleUpdate(processDelay)
        endif

    endevent

endstate

function RegisterDecorators()

    SkyrimNetApi.RegisterDecorator("arcs_get_sex_blocked", "arcs_Main", "GetActorBlocked")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_purity", "arcs_Main", "GetActorSexualPurity")
    SkyrimNetApi.RegisterDecorator("arcs_get_sex_preference", "arcs_Main", "GetActorSexualPreference")
    SkyrimNetApi.RegisterDecorator("arcs_get_nudity", "arcs_Main", "GetActorNudity")
    SkyrimNetApi.RegisterDecorator("arcs_get_arousal", "arcs_Main", "GetArousalLevel")


endfunction

function RegisterActions()

    SkyrimNetApi.RegisterAction("ExtCmdUpdateSexualPreferences", "Use this to remember that {target} likes {sex_type} as a sexual preference.", \
                                    "arcs_Main", "ExtCmdUpdateSexualPreferences_IsEligible", \
                                    "arcs_Main", "ExtCmdUpdateSexualPreferences_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"sex_type\":\"gentle|rough|oral|anal|vaginal\"}", \
                                    "", "")

    SkyrimNetApi.RegisterAction("ExtCmdStartSex", "Have {sex_type} sex with {target}.", \
                                    "arcs_Main", "ExtCmdStartSex_IsEligible", \
                                    "arcs_Main", "ExtCmdStartSex_Execute", \
                                    "", "PAPYRUS", \
                                    1, "{\"target\":\"Actor\",\"sex_type\":\"gentle|rough\"}", \
                                    "", "")
    ;sex_type should be curated tags list, start with tags that minai used for sex events
    ;pull the SL tag selector out of binding?

    ;**********************
    ;other actions
    ;**********************
    ;stop sex
    ;speed up sex
    ;masturbate
    ;strip target
    ;undress
    ;dress
    ;multi-party sex?
    
    ;dd items

endfunction

;TODO - move decorator functions to their own script
string function GetActorBlocked(Actor akActor) global

    ;sexlab eligibility?
    ;check for appropriate ages
    ;check for player mcm race blocks
    ;check for elderly mcm block
    ;check for player sexual preferences

    return ""
endfunction

string function GetActorSexualPurity(Actor akActor) global

    return ""
endfunction

string function GetActorSexualPreference(Actor akActor) global

    return ""
endfunction

string function GetActorNudity(Actor akActor) global
    arcs_NudityChecker ncheck = Quest.GetQuest("arcs_MainQuest") as arcs_NudityChecker
    int nudity = ncheck.NudityCheck(akActor)
    string nudityString = ""
    if nudity == 0
        nudityString = "actor_nude"
    elseif nudity == 1
        nudityString = "actor_dressed_skimpy"
    elseif nudity == 2
        nudityString = "actor_dressed"
    endif
    arcs_Utility.WriteInfo("GetActorNudity decorator - actor: " + akActor.GetDisplayName() + " nudity: " + nudity + " output: " + nudityString)
    return nudityString
endfunction

string function GetArousalLevel(Actor akActor) global
    slaUtilScr slau = Quest.GetQuest("sla_Framework") as slaUtilScr
    int arousal = slau.GetActorArousal(akActor)
    string outputString = "actor_not_aroused"
    if arousal > 30 && arousal < 70
        outputString = "actor_mildly_aroused"
    elseif arousal > 70
        outputString = "actor_very_aroused"
    endif
    arcs_Utility.WriteInfo("GetArousalLevel decorator - actor: " + akActor.GetDisplayName() + " arousal: " + arousal + " output: " + outputString)
    return outputString
endfunction

;TODO - move eligibility checks to their own script
;TODO - create function to add to IsEligible calls to run high level checks like DHLP so not duplicated or missed
bool function ExtCmdStartSex_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global

    bool result = true 
    
    if akOriginator.IsChild() ;adults only
        result = false
    endif

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    string targetName = ""
    if !akTarget
        result = false
    Else
        targetName = akTarget.GetDisplayName()
        if akTarget.IsChild()
            result = false
        endif


    endif

    arcs_Utility.WriteInfo("ExtCmdStartSex_IsEligible decorator - akOriginator: " + akOriginator.GetDisplayName() + " akTarget: " + targetName + " result: " + result)

    return result

endfunction

bool function ExtCmdUpdateSexualPreferences_IsEligible(Actor akOriginator, string contextJson, string paramsJson) global
    return true ;TODO - make this work
endfunction

;TODO - move sexlab functions to their own script
function ExtCmdStartSex_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    ;TODO - confirm message box?



    arcs_Utility.WriteInfo("ExtCmdStartSex_Execute")

    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

    if !akTarget
        return ;need a message
    endif

    bool result

    string useTags = ""

    if useTags == ""
        if akOriginator.GetActorBase().GetSex() == 1
            useTags += "F"
        else
            useTags += "M"
        endif
        if akTarget
            if akTarget.GetActorBase().GetSex() == 1
                useTags += "F"
            else
                useTags += "M"
            endif
        endif
        if useTags == "MF"
            useTags = "FM" ;NOTE - might work the other way, but sex lab tags list did not have this version
        endif
    endif

	Actor[] sceneActors = new Actor[2]
	sceneActors[0] = akOriginator
	sceneActors[1] = akTarget
	sslBaseAnimation[] sanims
	; sanims = sfx.GetAnimationsByTags(ActorCount = 2, Tags = "Aggressive", TagSuppress = "", RequireAll = true)
	; If sanism.Length == 0
	; 	sanims = sfx.PickAnimationsByActors(sceneActors)
	; EndIf
	;sanims = sfx.PickAnimationsByActors(Positions = sceneActors, Limit = 64, Aggressive = true)
	sanims = sfx.GetAnimationsByTags(ActorCount = 2, Tags = useTags, TagSuppress = "", RequireAll = false)
	If sanims.Length > 0		
		if sfx.StartSex(Positions = sceneActors, anims = sanims, allowbed = true) == -1
			result = false
		endif
	Else
		Debug.MessageBox("No sexlab animations could be found")
		result = false
    EndIf

    ;been using quick start in binding. need to get SL thread here.

endfunction

function ExtCmdUpdateSexualPreferences_Execute(Actor akOriginator, string contextJson, string paramsJson) global

    arcs_Utility.WriteInfo("ExtCmdUpdateSexualPreferences_Execute")
    arcs_Utility.WriteInfo("contextJson: " + contextJson)
    arcs_Utility.WriteInfo("paramsJson: " + paramsJson)

    SexLabFramework sfx = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework

    Actor akTarget = SkyrimNetApi.GetJsonActor(paramsJson, "target", Game.GetPlayer()) ;todo - pull this from the quest?

endfunction


event OnSexEndEvent(string eventName, string argString, float argNum, form sender)

endevent

event OnDhlpSuspend(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpSuspend - sender: " + sender.GetName() + " id: " + sender.GetFormID())
    if (sender != self) 

    endif
endevent

event OnDhlpResume(string eventName, string strArg, float numArg, Form sender)
    arcs_Utility.WriteInfo("OnDhlpResume - sender: " + sender.GetName() + " id: " + sender.GetFormID())

endevent

Quest property arcs_NudityDetectionQuest auto