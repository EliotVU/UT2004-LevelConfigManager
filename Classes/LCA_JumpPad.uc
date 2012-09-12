//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_JumpPad Extends UTJumpPad;

var() bool bEnabled;
var() float UndoTime;

var bool bEnabled_bak;
var bool bWaitForUndo;

Function PostBeginPlay()
{
	Super.PostBeginPlay();
	bEnabled_bak = bEnabled;
	bBlockNonZeroExtentTraces = bEnabled;
}

Function Trigger( Actor Other, Pawn Player )
{
	if( !bWaitForUndo )
		bEnabled = !bEnabled;

	bBlockNonZeroExtentTraces = bEnabled;
	bWaitForUndo = True;

	// Undo the changes we did above!
	SetTimer( UndoTime, False );
	Instigator = Player;
}

Function Timer()
{
	local Pawn P;

	bWaitForUndo = False;
	bEnabled = !bEnabled;
	bBlockNonZeroExtentTraces = bEnabled;

	TriggerEvent( Event, Self, Instigator );
	Instigator = None;

	if( bEnabled )
	{
		ForEach TouchingActors( Class'Pawn', P )
			PostTouch( P );
	}
}

Function Touch( Actor Other )
{
	if( !bEnabled )
		return;

	Super.Touch(Other);
}

Function Reset()
{
	Super.Reset();
	SetTimer( 0, False );
	bEnabled = bEnabled_bak;
	bWaitForUndo = False;
	bBlockNonZeroExtentTraces = bEnabled;
	Instigator = None;
}

DefaultProperties
{
	bStatic=False
	bEnabled=True
	UndoTime=1.0
}

