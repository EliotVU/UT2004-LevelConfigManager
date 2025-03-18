/** Copyright 2006-2025 Eliot Van Uytfanghe. All Rights Reserved. */
class LCA_TouchTriggerVolume extends PhysicsVolume
    hidecategories(Force,Sound,Lighting,LightColor);

var() bool bEnabled "Enabled state of the volume; you can trigger the volume to toggle this state.";
var editconst bool bEnabled_bak;

var() bool bTriggerOnceOnly "Disable the volume after the first trigger event.";
var() bool bAcceptPlayersOnly "Only accept player (bots or human, but no monsters) controlled pawns.";

var() class<Actor> ConstraintActorClass "Restrict the physics volume effects only to actors of this class.";
var deprecated name ActorUnTouchVolumeEvent;

replication
{
    reliable if (bNetDirty)
        bEnabled;
}

simulated protected function OnAcceptedEnter(Actor other)
{
    if (Event != '')
        TriggerEvent(Event, self, Pawn(other));
}

simulated protected function OnAcceptedLeave(Actor other)
{
    if (Event != '')
        UnTriggerEvent(Event, self, Pawn(other));
}

simulated function bool CanAccept(Actor other)
{
    return ClassIsChildOf(other.Class, ConstraintActorClass) && (!bAcceptPlayersOnly || Pawn(other).IsPlayerPawn());
}

simulated event Touch(Actor other)
{
    if (bEnabled && bool(other) && CanAccept(other))
    {
        super(Volume).Touch(other);

        if(bTriggerOnceOnly)
        {
            bEnabled = false;
        }

        OnAcceptedEnter(other);
    }
}

simulated event UnTouch(Actor other)
{
    if (bEnabled && bool(other) && CanAccept(other))
    {
        super(Volume).UnTouch(other);

        OnAcceptedLeave(other);
    }
}

simulated event PawnEnteredVolume(Pawn other);
simulated event PawnLeavingVolume(Pawn other);
function PlayerPawnDiedInVolume(Pawn other)
{
    UnTouch(other);
}

event PostBeginPlay()
{
    super.PostBeginPlay();
    bEnabled_bak = bEnabled;
}

function Trigger(Actor other, Pawn Player)
{
    bEnabled = !bEnabled;

    if (bEnabled) foreach TouchingActors(ConstraintActorClass, other) {
        Touch(other);
    }
    else { foreach TouchingActors(ConstraintActorClass, other) {
        UnTouch(other);
    }}
}

function Reset()
{
    super.Reset();
    bEnabled = bEnabled_bak;
}

defaultproperties
{
    bEnabled=true
    bEnabled_bak=true
}

defaultproperties
{
    bAcceptPlayersOnly=true
    ConstraintActorClass=Class'xPawn'

    bGameRelevant=true
}
