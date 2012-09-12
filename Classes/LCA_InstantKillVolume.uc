/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Touch

;On Activation : Forces suicide on the pawn that touches this volume.
==============================================================================*/
class LCA_InstantKillVolume extends LCA_Volumes
	hidecategories(PhysicsVolume);

event Touch( Actor Other )
{
	super(Volume).Touch( Other );
	if( bEnabled && Pawn(Other) != none && Other.bCanBeDamaged )
	{
		if( bTriggerOnceOnly )
		{
			bEnabled = false;
		}

		Pawn(Other).Suicide();
	}
}

defaultproperties
{
	Info="Kills the entering player instantly."
}
