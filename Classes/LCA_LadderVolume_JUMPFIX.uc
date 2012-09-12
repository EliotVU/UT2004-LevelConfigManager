/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Resets your jumps when you get off the ladder.
==============================================================================*/
class LCA_LadderVolume_JUMPFIX extends LadderVolume;

simulated event PawnLeavingVolume( Pawn Other )
{
	Super(PhysicsVolume).PawnLeavingVolume(Other);
	if( xPawn(Other) != none )
		xPawn(Other).MultiJumpRemaining = xPawn(Other).MaxMultiJump;
}

defaultproperties
{
}
