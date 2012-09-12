/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Increments the multiple jumps limit to an high enough volume to be considered infinite.
==============================================================================*/
class LCA_InfiniteJumpVolume extends LCA_Volumes;

var() bool bRestoreJumpsWhenLeave, bShowMessages;

simulated event PawnEnteredVolume( Pawn Incomer )
{
	local xPawn X;

	Super.PawnEnteredVolume(Incomer);
	X = xPawn(Incomer);
	if( bEnabled && X != None )
	{
		X.MaxMultiJump += (maxint/2);
		X.MultiJumpRemaining += (maxint/2);
	  	if( bShowMessages )
			X.ClientMessage( "You've entered an area with infinity JumpLimit" );
	}
}

simulated event PawnLeavingVolume( Pawn Leaver )
{
	local xPawn X;

	Super.PawnLeavingVolume(Leaver);
	X = xPawn(Leaver);
	if( bRestoreJumpsWhenLeave && bEnabled && X != None )
	{
		X.MaxMultiJump -= (maxint/2);
		X.MultiJumpRemaining -= (maxint/2);
		if( bShowMessages )
			X.ClientMessage( "You've leaved an area with infinity JumpLimit" );
	}
}

defaultproperties
{
	bRestoreJumpsWhenLeave=true
	bStatic=true
}
