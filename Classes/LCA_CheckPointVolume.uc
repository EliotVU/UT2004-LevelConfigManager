/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Triggers the 'BTimes_SoloCheckPointVolume' event. This volume is exclusively for [[MutBestTimes]].
==============================================================================*/
class LCA_CheckPointVolume extends PhysicsVolume;

// Handled by an external mutator e.g. MutBestTimes.
var() int CheckPointUses;

simulated event PawnEnteredVolume( Pawn Other )
{
	if( Other != none && Other.Controller != none && PlayerController(Other) != none )
	{
		// Notify BTimes that this user has entered a checkpoint volume!
		TriggerEvent( 'BTimes_SoloCheckPointVolume', self, Other );
	}
}

defaultproperties
{
	// Unlimited.
	CheckPointUses=0
}
