/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

This is a bridge trigger between a stand trigger and a trigger not supporting a ''ReTriggerDelay'' feature.
e.g. UseTrigger->TriggerDelayTrigger->Something.
i.e. The TriggerDelayTrigger will only work if it wasn't triggered for a specified amount of time.

;Activation Type : Trigger

;On Activation : A ''LastTriggerTime'' test will be done, if the specified ''TriggerDelay'' has passed then the trigger will trigger his own ''Event'', if not then nothing happens.
==============================================================================*/
class LCA_TriggerDelayTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

var float LastTriggeredTime;

/** The time that must have been passed since the last time this trigger was triggered to trigger its own event. */
var() float TriggerDelay;

function Trigger( Actor Other, Pawn Player )
{
	if( (Level.TimeSeconds - LastTriggeredTime) <= TriggerDelay )
		return;

	LastTriggeredTime = Level.TimeSeconds;
	TriggerEvent( Event, self, Player );
}

defaultproperties
{
	bNoDelete=false
	bCollideActors=false
	Info="Works like the normal trigger's ReTriggerDelay, except this can be used to bind it to any kind of trigger."
}
