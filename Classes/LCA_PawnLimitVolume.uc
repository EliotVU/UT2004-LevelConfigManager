/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2006
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : When a pawn enters this volume the ''PawnsLimit'' is incremented by 1(and vice versa), if it reaches the '''RequiredPawns''' limit then it will trigger its own ''Event''.
==============================================================================*/
class LCA_PawnLimitVolume extends LCA_Volumes;

var protected int PawnsLimit;
var() int RequiredPawns;
var() bool bAllowMonsters;

simulated event PawnEnteredVolume( Pawn Other )
{
	if( (PawnsLimit >= RequiredPawns) || ((Other.IsA('Monster') && !bAllowMonsters)) )return;
	if( Other != None && (bEnabled) )
	{
		++ PawnsLimit;
		if( PawnsLimit >= RequiredPawns )
		{
			TriggerEvent( Event, Self, Other );
			if( bTriggerOnceOnly )
				bEnabled = False;
		}
	}
}

simulated event PawnLeavingVolume( Pawn Other )
{
	if( Other != None && (bEnabled && !((Other.IsA('Monster') && !bAllowMonsters))) )
		-- PawnsLimit;
}


function Reset()
{
	Super.Reset();
	PawnsLimit = 0;
}

defaultproperties
{
	RequiredPawns=4
	Info="If there enter more than $RequiredPawns$ or have entered, then volume will trigger its event."
}
