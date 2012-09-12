/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2010
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Touch

;On Activation : Teleports any instigating actor(Anything the '''Destination''' teleporter can accept).
==============================================================================*/
class LCA_TeleportVolume extends LCA_Volumes;

var() name Destination;

event Touch( Actor Other )
{
	super.Touch( Other );
	if( bEnabled && Other != none && Other.bCanTeleport )
	{
		PendingTouch = Other;
		Other.PendingTouch = self;
	}
}

simulated event PostTouch( Actor Other )
{
	local Teleporter TP;
	local array<Teleporter> TPList;
	local int i;

	super.PostTouch( Other );
	if( Other != none )
	{
		foreach AllActors( class'Teleporter', TP, Destination )
		{
			TPList[TPList.Length] = TP;
		}

		if( TPList.Length == 0 )
		{
			return;
		}

	 	i = Rand( TPList.Length );
	 	if( Pawn(Other) != none )
	 	{
	 		Other.PlayTeleportEffect( false, true );
	 	}
	 	TPList[i].Accept( Other, self );

	 	if( Pawn(Other) != none )
	 	{
	 		TriggerEvent( Event, self, Pawn(Other) );
	 		// Ensure the player can jump twice.
	 		if( Other.Physics == PHYS_Walking )
 			{
	 			Pawn(Other).Landed( vect( 0, 0, 0 ) );
			}
		}
	}
}
