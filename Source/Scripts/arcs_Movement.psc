Scriptname arcs_Movement extends Quest  

function FaceTarget(Actor a, ObjectReference target) global
    float zOffset = a.GetHeadingAngle(target)
    a.SetAngle(a.GetAngleX(), a.GetAngleY(), a.GetAngleZ() + zOffset)
endfunction

function PlayDoWork(Actor a, float seconds = 3.0) global
    Debug.SendAnimationEvent(a, "IdleLockPick")
    arcs_Utility.DoSleep(seconds)
endfunction

Function PlayDressUndress(Actor a) global
    int Gender = a.GetLeveledActorBase().GetSex()
    Debug.SendAnimationEvent(a, "Arrok_Undress_G" + Gender)
EndFunction