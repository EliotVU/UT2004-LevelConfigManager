/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2006
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Modifies various common properties on the entering pawn.
==============================================================================*/
Class LCA_PawnModifyVolume Extends LCA_Volumes;

var() int NewJumplimit, NewJumpHeight, NewJumpBoost;
var() float NewMoveSpeedScaling, NewAirControl;
var() bool bCanWallDodge;
var() bool bOnlyInside;
var() string NoteMessage;

simulated event PreBeginPlay()
{
	super.PreBeginPlay();
	foreach AllActors( Class'LevelConfigActor', Master )
		break;
}

simulated event PawnEnteredVolume( Pawn Other )
{
	local xPawn X;

	X = xPawn(Other);
	if( IsPawnRelevant( X ) )
	{
		if( NoteMessage != "" )
			X.ClientMessage( NoteMessage );

		X.Jumpz = NewJumpHeight;
		X.MultiJumpBoost = NewJumpBoost;
		X.MaxMultiJump = NewJumplimit;
		X.MultiJumpRemaining = NewJumplimit;
		X.AirControl = NewAirControl;
		X.bCanWallDodge = bCanWallDodge;
		if( Master != None )
			Master.SetSpeedScale( X, NewMoveSpeedScaling );
	}

	if( bTriggerOnceOnly )
		bEnabled = False;

	Super.PawnEnteredVolume(Other);
}

simulated event PawnLeavingVolume( Pawn Other )
{
	local xPawn X;

	Super.PawnLeavingVolume(Other);
	X = xPawn(Other);
	if( X != None && bOnlyInside && Master != None )
	{
		X.Jumpz = Master.JumpHeight;
		X.MultiJumpBoost = Master.MultiJumpHeight;
		X.MaxMultiJump = Master.MultiJumplimit;
		X.MultiJumpRemaining = Master.MultiJumplimit;
		X.AirControl = Master.AirControl;
		X.bCanWallDodge = Master.bAllowWallDodge;
		Master.SetSpeedScale( X );
	}
}

defaultproperties
{
	bTriggerOnceOnly=False
	bCanWallDodge=True
	NewJumplimit=2
	NewAirControl=0.350000
	NewMoveSpeedScaling=1.000000
	Info="Whenever this volume is entered, the player will experience changes of your choice."
}
