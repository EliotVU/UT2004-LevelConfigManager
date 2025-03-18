/** Copyright 2006-2025 Eliot Van Uytfanghe. All Rights Reserved. */
class LCA_TouchTriggerVolume extends PhysicsVolume
    hidecategories(Force,Sound,Lighting,LightColor);

var() bool bEnabled "Enabled state of the volume; you can trigger the volume to toggle this state.";
var editconst bool bEnabled_bak;

var() bool bTriggerOnceOnly "Disable the volume after the first trigger event.";
var() bool bAcceptPlayersOnly "Only accept player (bots or human, but no monsters) controlled pawns.";

var() Class<Actor> ConstraintActorClass "Restrict the triggering event only to actors of this class.";
var deprecated name ActorUnTouchVolumeEvent;

replication
{
    reliable if (bNetDirty)
        bEnabled;
}

simulated protected function OnAcceptedEnter(Actor other)
{
    TriggerEvent(Event, self, Pawn(other));
}

simulated protected function OnAcceptedLeave(Actor other)
{
    UnTriggerEvent(Event, self, Pawn(other));
}

simulated function bool CanAccept(Actor other)
{
    return ClassIsChildOf(other.Class, ConstraintActorClass) && (!bAcceptPlayersOnly || Pawn(other).IsPlayerPawn());
}

simulated event Touch(Actor other)
{
    local vector HitLocation,HitNormal;
    local Actor SpawnedEntryActor;

    // Copied from super class.
    // p.s. bWaterVolume logic cannot be controlled, (hard coded in C++)
    // So we keep this code active regardless of our restrictions.
    if (bWaterVolume && Pawn(other) != none) {
        if ( (Level.TimeSeconds - Pawn(Other).SplashTime > 0.3) && (PawnEntryActor != None) && !Level.bDropDetail && (Level.DetailMode != DM_Low) && EffectIsRelevant(Other.Location,false) )
        {
            if ( !TraceThisActor(HitLocation, HitNormal, Other.Location - Other.CollisionHeight*vect(0,0,1), Other.Location + Other.CollisionHeight*vect(0,0,1)) )
            {
                SpawnedEntryActor = Spawn(PawnEntryActor,Other,,HitLocation,rot(16384,0,0));
            }
        }

        // Disabled, better logic below; simulated and not exclusive to player pawns.
        // if ( (Role == ROLE_Authority) && Other.IsPlayerPawn() )
        //     TriggerEvent(Event,self, Other);
    }

    if (bEnabled && bool(other) && CanAccept(other)) {
        if (bTriggerOnceOnly && Role == ROLE_Authority) {
            bEnabled = false;
        }

        // Water splash effect and damage effects etc.
        super.Touch(other);

        OnAcceptedEnter(other);
    } else {
        // Water splash effect. (We cannot disable the swimming physics even if we don't accept the pawn)
        if ( bWaterVolume && Other.CanSplash() )
            PlayEntrySplash(Other);
    }
}

simulated event UnTouch(Actor other)
{
    // Water splash effect. (We cannot disable the swimming physics even if we don't accept the pawn)
    super.UnTouch(other);

    if (bEnabled && bool(other) && CanAccept(other)) {
        OnAcceptedLeave(other);
    }
}

simulated event PawnEnteredVolume(Pawn other);
simulated event PawnLeavingVolume(Pawn other);
function PlayerPawnDiedInVolume(Pawn other)
{
    if (bEnabled && bool(other) && CanAccept(other)) {
        OnAcceptedLeave(other);
    }
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
        if (CanAccept(other)) {
            super.Touch(other);

            OnAcceptedEnter(other);
        }
    }
    else { foreach TouchingActors(ConstraintActorClass, other) {
        if (CanAccept(other)) {
            super.UnTouch(other);

            OnAcceptedLeave(other);
        }
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
