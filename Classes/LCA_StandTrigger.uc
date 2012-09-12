/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

Can be used in shooting maps e.g. say if theres a moving mover and a target to hit, this target is visible anywhere even if you won't go on the mover and thus the player can cheat it unless this actor is used by the target to check if the instigator is actually standing on that mover.

;Activation Type : Trigger

;On Activation : Checks if the instigator is standing on the specified ''StandingOnClass'' if true then it will trigger his own ''Event'', if false nothing happens.
==============================================================================*/
class LCA_StandTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

var() class<Actor> StandingOnClass;

function Trigger( Actor Other, Pawn Player )
{
	if( Player == None )
		super.Trigger(Other,Player);
	else if( IsEnabled() )
	{
		if( Player.Base != None && Player.Base.Class == StandingOnClass )
			TriggerEvent( Event, self, Player );
	}
}

defaultproperties
{
	Info="Will only trigger if instigator is standing on the required class type."
	bCollideActors=false
	bNoDelete=false
}
