/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Damage

;On Activation : Triggers his own event whenever the specified ''HitCount'' is achieved within the specified ''HitCountTime''.
==============================================================================*/
class LCA_HitCountTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

/** Amount of time available to achieve the 'HitCount'. */
var() float HitCountTime;

/** Number of hits need within the 'HitCountTime'. */
var() int HitCount;

var() int DamageThreshold;
var() class<DamageType> DamageTypeLimitor;

var float InitialHitTime;
var int NumHits;

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	if( IsEnabled() && EventInstigator != none && Damage >= DamageThreshold
	&& (DamageTypeLimitor == none || ClassIsChildOf( DamageType, DamageTypeLimitor )) )
	{
		if( (Level.TimeSeconds - InitialHitTime) > HitCountTime )
		{
			NumHits = 0;
			InitialHitTime = Level.TimeSeconds;
		}

		++ NumHits;
		if( NumHits == HitCount )
		{
			TriggerEvent( Event, self, EventInstigator );
		}
	}
}

function Reset()
{
	super.Reset();
	InitialHitTime = 0;
	NumHits = 0;
}

defaultproperties
{
	bCollideActors=true

	HitCount=3
	HitCountTime=1.5
	DamageThreshold=0
	bProjTarget=true

	Info="Triggers its own event whenever the specified 'HitCount' is achieved within the specified 'HitCountTime'."
}
