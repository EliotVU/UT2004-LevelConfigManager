//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyObjective extends UseObjective
	placeable;

var() bool bAutoUse;

// NoClear
var() const editconst editinlinenotify export LCA_KeyRequirementCondition KeyCondition;

function Touch( Actor Other )
{
	if( Pawn(Other) != none && bAutoUse && Pawn(Other).bCanUse && KeyCondition != none && KeyCondition.GetCondition( Pawn(Other) ) )
	{
    	UsedBy( Pawn(Other) );
	}
}

function UsedBy( Pawn User )
{
	if( KeyCondition != none && IsRelevant( User, true ) )
	{
		if( KeyCondition.GetCondition( User ) )
		{

			DisableObjective( User );
		}
		else
		{
			User.ClientMessage( KeyCondition.GetDeniedMessage() );
		}
	}
}

defaultproperties
{
	bAutoUse=true

	Begin Object Class=LCA_KeyRequirementCondition Name=soKeyCond
		RequiredKeys(0)="Gold Key"
	End Object
	KeyCondition=soKeyCond
}

