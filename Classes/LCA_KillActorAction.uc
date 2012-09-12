//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KillActorAction extends LCA_ActorAction;

function ActivateAction( Actor Other, optional Actor Instigator )
{
	if( Pawn(Instigator) != none )
	{
		Pawn(Instigator).Suicide();
	}
	else if( Other != none )
	{
		Other.Destroy();
	}
}

defaultproperties
{
}
