Scriptname arcs_ThePlayer extends ReferenceAlias  

event OnPlayerLoadGame()
    (GetOwningQuest() as arcs_Main).GameLoaded()
    (GetOwningQuest() as arcs_NudityChecker).GameLoaded()
endevent

event OnLocationChange(Location akOldLoc, Location akNewLoc)
    (GetOwningQuest() as arcs_Main).ChangedLocation(akOldLoc, akNewLoc)
endevent

Keyword property ArmorCuirass auto
Keyword property ClothingBody auto