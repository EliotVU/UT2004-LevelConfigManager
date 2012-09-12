//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_ActorReset Extends LCA_Triggers
	HideCategories(LCA_Triggers)
	Placeable;

var() array<name> ActorTag;

Function Trigger( actor Other, pawn EventInstigator )
{
	local Actor A;
	local int i;

	if( EventInstigator == None )
		Super.Trigger(Other,EventInstigator);

	if( IsEnabled() )
	{
		TriggerEvent( Event, Self, EventInstigator );

		for( i = 0; i < ActorTag.Length; i ++ )
		{
			ForEach AllActors( Class'Actor', A, ActorTag[i] )
				A.Reset();
		}
	}
}

DefaultProperties
{
	Info="When Triggered it calls the Reset() function for all actors with the Tag 'ActorTag'"
	ActorTag(0)=Mover
	bStatic=False
	bNodelete=False
	bCollideActors=false
}
