/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Automatic

;On Activation : Triggers his own event every ''DelayTime''.
==============================================================================*/
class LCA_DelayedTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

var() float DelayTime;
var() bool bLoop;

event PostBeginplay()
{
	super.PostBeginPlay();

	if( IsEnabled() )
	{
		SetTimer( DelayTime, bLoop );
	}
}

function Trigger( Actor Other, Pawn Player )
{
	super.Trigger( Other, Player );

	if( IsEnabled() )
	{
		SetTimer( DelayTime, bLoop );
	}
	else
	{
		SetTimer( 0f, false );
	}
}

event Timer()
{
	if( IsEnabled() )
	{
		TriggerEvent( Event, self, none );
	}
}

defaultproperties
{
	DelayTime=1.00
	bLoop=true
	Info="Triggers its own event every (specified DelayTime)."
}
