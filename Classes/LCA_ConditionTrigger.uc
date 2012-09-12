/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : All conditions will be tested, if true ''OnTrueAction'' will be activated, if false ''OnFalseAction'' will be activated.
==============================================================================*/
class LCA_ConditionTrigger extends LCA_Triggers
	hidecategories(Message)
	placeable;

/** List of conditions the Instigator will be tested against. */
var() editinlinenotify export array<LCA_Condition> Conditions;

/** If one of the 'Conditions' is false then this action will be activated if set. */
var() editinlinenotify export LCA_ActorAction OnFalseAction;

/** If all of the 'Conditions' are true then this action will be activated if set. */
var() editinlinenotify export LCA_ActorAction OnTrueAction;

function bool TestConditions( out int i, Pawn Player )
{
	for( i = 0; i < Conditions.Length; ++ i )
	{
		if( Conditions[i] != none )
		{
			if( !Conditions[i].GetCondition( Player ) )
			{
				return false;
			}
		}
	}
	return true;
}

function Trigger( Actor Other, Pawn Player )
{
	local int i;

	if( Player == none )
		super.Trigger( Other, Player );
	else if( IsEnabled() )
	{
		if( TestConditions( i, Player ) )
		{
			if( OnTrueAction != none )
    		{
    			OnTrueAction.ActivateAction( Other, Player );
    		}
    	}
    	else
    	{
    		if( i < Conditions.Length )
    			Player.ClientMessage( Conditions[i].GetDeniedMessage() ) ;
			if( OnFalseAction != none )
			{
				OnFalseAction.ActivateAction( Other, Player );
			}
		}
	}
}

defaultproperties
{
	Info="When triggered, all conditions will need to be meet, if true OnTrueAction will be activated, if false OnFalseAction will be activated."
}
