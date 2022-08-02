//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_EventCore extends LCA_Triggers
	placeable;

var(Events) name BeginPlayEvent;
var(Events) name MatchStartingEvent;
var(Events) name ResetEvent;

simulated event BeginPlay()
{
	super.BeginPlay();
	TriggerEvent( BeginPlayEvent, self, none );
}

function MatchStarting()
{
	super.MatchStarting();
	TriggerEvent( MatchStartingEvent, self, none );
}

function Reset()
{
	super.Reset();
	TriggerEvent( ResetEvent, self, none );
}

defaultproperties
{
	bCollideActors=false
}