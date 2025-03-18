/** Copyright 2006-2025 Eliot Van Uytfanghe. All Rights Reserved. */
class LCA_RequirementVolume extends LCA_TouchTriggerVolume;

var() editinlinenotify export array<LCA_Condition> Requirements;
var() editinlinenotify export LCA_ActorAction OnFalseAction, OnTrueAction;
var() const bool bEmitDeniedMessage;

simulated function int MeetsRequirements(Actor other)
{
    local int i;

    for (i = 0; i < Requirements.Length; ++ i)
    {
        if (bool(Requirements[i]) && !Requirements[i].GetCondition(other))
        {
            return i;
        }
    }

    return -1;
}

simulated protected function OnAcceptedEnter(Actor other)
{
    local int conditionIndex;
    local string deniedMessage;

    super.OnAcceptedEnter(other);

    conditionIndex = MeetsRequirements(other);
    if (conditionIndex != -1)
    {
        if (OnTrueAction != none)
        {
            OnTrueAction.ActivateAction(other, other);
        }
    }
    else
    {
        if (bEmitDeniedMessage && Requirements.Length > 0 && bool(xPawn(other)))
        {
            deniedMessage = Requirements[conditionIndex].GetDeniedMessage();
            if (deniedMessage != "")
            {
                xPawn(other).ClientMessage(deniedMessage);
            }
        }

        if (OnFalseAction != none)
        {
            OnFalseAction.ActivateAction(other, other);
        }
    }
}

simulated protected function OnAcceptedLeave(Actor other)
{
    super.OnAcceptedLeave(other);
}

defaultproperties
{
    bEmitDeniedMessage=true
}
