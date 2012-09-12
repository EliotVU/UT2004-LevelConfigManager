/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : All the set actions will be activated.
==============================================================================*/
class LCA_ActionTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

var() editinlinenotify export array<LCA_ActorAction> Actions;

function Trigger( Actor Other, Pawn Player )
{
	local int i;

	if( Player == none )
		super.Trigger( Other, Player );
	else if( IsEnabled() )
	{
		for( i = 0; i < Actions.Length; ++ i )
		{
			if( Actions[i] != none )
			{
				Actions[i].ActivateAction( Other, Player );
			}
		}
	}
}

defaultproperties
{
	Info="When triggered, all actions will be activated."
}
