Scriptname arcs_NudityDetection extends Quest  

ObjectReference[] actors

event OnInit()

    if self.IsRunning()
        LoadActors()        
        TestActors()
        TestPlayer()
        self.Stop()
    endif

endevent

function TestPlayer()

    Actor thePlayer = Game.GetPlayer() ;needs to pull from main/mcm scripts
    string playerName = thePlayer.GetDisplayName()

    int nudity = ncheck.NudityCheck(thePlayer)

    arcs_Utility.WriteInfo("player: " + playerName + " nudity check: " + nudity)

    ;need llm message queue

    if nudity < 2
        string desc = ""
        string data = ""
        if nudity == 0
            desc = "{{ player.name }} is nude"
            data = "{{ player.name }} is walking around nude."
            ;int result = SkyrimNetApi.DirectNarration(playerName + " is walking around nude.")
        elseif nudity == 1
            desc = "{{ player.name }} in skimpy clothing"
            data = "{{ player.name }} is wearing skimpy clothing that reveals their body."
            ;int result = SkyrimNetApi.DirectNarration(playerName + " is wearing skimpy clothing that reveals their body.")
        endif
        bool result = arcs_SkyrimNet.CreateShortLivedEvent("nudity_event_" + thePlayer.GetDisplayName(), "sex_event_orgasm", desc, data, thePlayer, thePlayer)
        arcs_Utility.WriteInfo("arcs_NudityDetection - created short term event: " + result + " actor: " + playerName)
    endif

endfunction

function LoadActors()

    actors = new ObjectReference[12]

    actors[0] = Actor01.GetReference()
    actors[1] = Actor02.GetReference()
    actors[2] = Actor03.GetReference()
    actors[3] = Actor04.GetReference()
    actors[4] = Actor05.GetReference()
    actors[5] = Actor06.GetReference()
    actors[6] = Actor07.GetReference()
    actors[7] = Actor08.GetReference()
    actors[8] = Actor09.GetReference()
    actors[9] = Actor10.GetReference()
    actors[10] = Actor11.GetReference()
    actors[11] = Actor12.GetReference()

endfunction

function TestActors()
    int i = 0
    while i < actors.Length
        if actors[i] != none
            TestActor(actors[i] as Actor)
        endif
        i += 1
    endwhile
endfunction

function TestActor(Actor a)

    string actorName = a.GetDisplayName()

    int nudity = ncheck.NudityCheck(a)
    int arousal = sla.GetActorArousal(a)
    bool exbitionist = sla.IsActorExhibitionist(a)
    Int genderPreference = sla.GetGenderPreference(a, True)
    int purity = slStats.GetPurityLevel(a)
    int sexuality = slStats.GetSexuality(a)

    arcs_Utility.WriteInfo("actor found - name: " + actorName + " nudity check: " + nudity + " arousal: " + arousal + " purity: " + purity + " sexuality: " + sexuality + " exbitionist: " + exbitionist + " genderPreference: " + genderPreference)

endfunction

arcs_NudityChecker property ncheck auto

slaUtilScr property sla auto
sslActorStats property slStats auto

Keyword property ArmorCuirass auto
Keyword property ClothingBody auto

ReferenceAlias property Actor01 auto
ReferenceAlias property Actor02 auto
ReferenceAlias property Actor03 auto
ReferenceAlias property Actor04 auto
ReferenceAlias property Actor05 auto
ReferenceAlias property Actor06 auto
ReferenceAlias property Actor07 auto
ReferenceAlias property Actor08 auto
ReferenceAlias property Actor09 auto
ReferenceAlias property Actor10 auto
ReferenceAlias property Actor11 auto
ReferenceAlias property Actor12 auto
; ReferenceAlias property Actor13 auto
; ReferenceAlias property Actor14 auto
; ReferenceAlias property Actor15 auto
; ReferenceAlias property Actor16 auto
; ReferenceAlias property Actor17 auto
; ReferenceAlias property Actor18 auto
; ReferenceAlias property Actor19 auto
; ReferenceAlias property Actor20 auto
