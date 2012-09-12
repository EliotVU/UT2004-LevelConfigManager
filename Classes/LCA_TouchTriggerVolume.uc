/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2010
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Touch

;On Activation : Just like a [[Trigger]] but with volume collision.
==============================================================================*/
class LCA_TouchTriggerVolume extends LCA_Volumes
	hidecategories(PhysicsVolume);

var() class<Actor> ConstraintActorClass;
var() name ActorUnTouchVolumeEvent;

simulated event Touch( Actor Other )
{
	super(Volume).Touch( Other );
	if( bEnabled && Other != none && ClassIsChildOf( Other.Class, ConstraintActorClass ) )
	{
		if( bTriggerOnceOnly )
		{
			bEnabled = false;
		}

		if( Event != '' )
			TriggerEvent( Event, self, Pawn(Other) );
	}
}

simulated event UnTouch( Actor Other )
{
	super(Volume).UnTouch( Other );
	if( bEnabled && Other != none && ClassIsChildOf( Other.Class, ConstraintActorClass ) )
	{
		if( ActorUnTouchVolumeEvent != '' )
			TriggerEvent( ActorUnTouchVolumeEvent, self, Pawn(Other) );
	}
}

defaultproperties
{
	Info="Triggers its own event whenever touched."
}
