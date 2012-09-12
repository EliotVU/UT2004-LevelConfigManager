/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2010
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Just like a [[Trigger]] but with volume collision.
==============================================================================*/
class LCA_EnterTriggerVolume extends LCA_Volumes
	hidecategories(PhysicsVolume);

var() class<Actor> ConstraintActorClass;
var() name ActorLeavingVolumeEvent;

simulated event ActorEnteredVolume( Actor Other )
{
	super(PhysicsVolume).ActorEnteredVolume( Other );
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

simulated event ActorLeavingVolume( Actor Other )
{
	super(PhysicsVolume).ActorLeavingVolume( Other );
	if( bEnabled && Other != none && ClassIsChildOf( Other.Class, ConstraintActorClass ) )
	{
		if( ActorLeavingVolumeEvent != '' )
			TriggerEvent( ActorLeavingVolumeEvent, self, Pawn(Other) );
	}
}

defaultproperties
{
	Info="Triggers its own event whenever entered."
}
