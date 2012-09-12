//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_TriggerActorAction extends LCA_ActorAction;

var() array<name> Events;

function ActivateAction( Actor Other, optional Actor Instigator )
{
	local int i;

	for( i = 0; i < Events.Length; ++ i )
	{
		Other.TriggerEvent( Events[i], Other, Pawn(Instigator) );
	}
}
