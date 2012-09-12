//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_MultiActorAction extends LCA_ActorAction;

var() editinlinenotify export array<LCA_ActorAction> Actions;

function ActivateAction( Actor Other, optional Actor Instigator )
{
	local int i;

	for( i = 0; i < Actions.Length; ++ i )
	{
		if( Actions[i] != none )
		{
			Actions[i].ActivateAction( Other, Instigator );
		}
	}
}
