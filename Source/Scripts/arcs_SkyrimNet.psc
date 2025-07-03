Scriptname arcs_SkyrimNet extends Quest  

bool function CreateShortLivedEvent(string eventId, string eventType, string description, string data, Actor sourceActor, Actor targetActor, int expires = 120) global

    ; int function RegisterShortLivedEvent(String eventId, String eventType, String description, \
    ;                                     String data, int ttlMs, Actor sourceActor, Actor targetActor) Global Native

    int result = SkyrimNetApi.RegisterShortLivedEvent(eventId, eventType, description, data, (expires * 1000), sourceActor, targetActor)

    ;NOTES
    ;ttlMs should be 60-120 seconds generally, some less
    ;eventId - freeform but the recommended syntax is event_type_{actor uuid} - the same event Id can be used to overwrite events
    ;eventType - freeform
    
    return (result == 1)

endfunction