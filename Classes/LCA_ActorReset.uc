/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : Resets all actors of matching the @ActorTag array, and triggers its @Event.
==============================================================================*/
class LCA_ActorReset extends LCA_Triggers
	hidecategories(LCA_Triggers)
	placeable;

#exec Texture Import File=Textures\ResetTrigger.pcx Name=S_ResetTrigger Mips=Off MASKED=1

var() array<name> ActorTag;

function Trigger( Actor other, pawn eventInstigator )
{
	local Actor A;
	local int i;

	if( IsEnabled() )
	{
		for( i = 0; i < ActorTag.Length; i ++ )
		{
			foreach AllActors( class'Actor', A, ActorTag[i] )
				A.Reset();
		}
		TriggerEvent( Event, self, eventInstigator );
	}
}

defaultproperties
{
	Info="When Triggered it calls the Reset() function for all actors with the Tag 'ActorTag'"
	ActorTag(0)=Mover
	bCollideActors=false
	Texture=S_ResetTrigger
}
