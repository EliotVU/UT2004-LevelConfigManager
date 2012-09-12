/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2010
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Checks all the set '''Requirements''' if all are met then it will activate the '''OnFalseAction'', if one is not met then it will activate the '''OnTrueAction'''.
==============================================================================*/
class LCA_RequirementVolume extends LCA_Volumes;

var() editinlinenotify export array<LCA_Condition> Requirements;
var() editinlinenotify export LCA_ActorAction OnFalseAction, OnTrueAction;

simulated function bool MeetsRequirements( Pawn Other, out int i )
{
	for( i = 0; i < Requirements.Length; ++ i )
	{
		if( Requirements[i] != none && !Requirements[i].GetCondition( Other ) )
		{
			return false;
		}
	}
	return true;
}

simulated event PawnEnteredVolume( Pawn Other )
{
	local int i;
	local string s;

	// Ignore bots!
	if( IsPawnRelevant( Other ) && Other.PlayerReplicationInfo != none && !Other.PlayerReplicationInfo.bBot )
	{
		if( MeetsRequirements( Other, i ) )
		{
			if( bTriggerOnceOnly )
				bEnabled = False;

			if( OnTrueAction != none )
			{
				OnTrueAction.ActivateAction( Other, Other );
			}
		}
		else
		{
			if( Requirements.Length > 0 )
			{
				s = Requirements[i].GetDeniedMessage();
				if( s != "" )
				{
					xPawn(Other).ClientMessage( s );
				}
			}

			if( OnFalseAction != none )
			{
				OnFalseAction.ActivateAction( Other, Other );
			}
		}
	}
}

defaultproperties
{
	Info="Players must meet the specified requirements in order to enter this volume."
}
