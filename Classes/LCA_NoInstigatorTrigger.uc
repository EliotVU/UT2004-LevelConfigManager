/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

Used to get rid of the instigator so that certain triggers can be triggered without an instigator to be responsible.

;Activation Type : Trigger

;On Activation : Redirects the event but removes the instigator so that it can't be responsible for anything anymore.
==============================================================================*/
class LCA_NoInstigatorTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

function Trigger( Actor Other, Pawn Player )
{
	if( Player == none )
		super.Trigger( Other, Player );
	else if( IsEnabled() )
	{
		// Note NONE.
		TriggerEvent( Event, self, none );
	}
}

defaultproperties
{
	bNoDelete=false
	bCollideActors=false

	Info="Redirects the event but removes the instigator so that it can't be responsible for anything anymore."
}
