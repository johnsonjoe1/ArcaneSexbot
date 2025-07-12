Scriptname arcs_SkyrimNet extends Quest  

bool function CreateShortLivedEvent(string eventId, string eventType, string description, string data, Actor sourceActor, Actor targetActor, int expires = 120) global

    ;debug.MessageBox("short event messagebox")

    ; int function RegisterShortLivedEvent(String eventId, String eventType, String description, \
    ;                                     String data, int ttlMs, Actor sourceActor, Actor targetActor) Global Native

    int result = SkyrimNetApi.RegisterShortLivedEvent(eventId, eventType, description, data, (expires * 1000), sourceActor, targetActor)

    ;NOTES
    ;ttlMs should be 60-120 seconds generally, some less
    ;eventId - freeform but the recommended syntax is event_type_{actor uuid} - the same event Id can be used to overwrite events
    ;eventType - freeform
    
    return (result == 0)

endfunction

bool function CreateLongLivedEvent(string eventType, string content, Actor sourceActor, Actor targetActor) global

    ;int function RegisterEvent(String eventType, String content, Actor originatorActor, Actor targetActor) Global Native

    int result = SkyrimNetApi.RegisterEvent(eventType, content, sourceActor, targetActor)

    return (result == 0)

endfunction

bool function CreateDirectNarration(string content, Actor sourceActor = none, Actor targetActor = none) global

    ;debug.MessageBox("dn messagebox")

    arcs_Utility.WriteInfo("DN prompt: " + content)

    ;int function DirectNarration(String content, Actor originatorActor = None, Actor targetActor = None) Global Native

    int result = SkyrimNetApi.DirectNarration(content, sourceActor, targetActor)

    return (result == 0)

endfunction

bool function CreateRegisterDialogue(string dialogue, Actor sourceActor, Actor targetActor = none) global

    ;NOTE - this writes a text entry in the log without spoken text

    ;int function RegisterDialogue(Actor speaker, String dialogue) Global Native
    ;int function RegisterDialogueToListener(Actor speaker, Actor listener, String dialogue) Global Native

    int result = SkyrimNetApi.RegisterDialogue(sourceActor, dialogue)

    return (result == 0)

endfunction