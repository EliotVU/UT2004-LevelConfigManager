/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2006
 * ;Last Updated : 12/12/2006
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Touch

;On Activation : Blows up any pawn that touches this volume.
==============================================================================*/
class LCA_LandMineVolume extends LCA_Volumes;

var() class<DamageType> DeathType;
var() class<Emitter> DeathEffect;
var() sound DeathSound;
var() int DeathSoundVolume;
var() vector DeathThrowRange;

simulated event Touch( Actor Other )
{
	super.Touch( Other );
	if( bEnabled && Pawn(Other) != none )
	{
		if( bTriggerOnceOnly )
		{
			bEnabled = false;
		}

		Pawn(Other).Died( none, DeathType, Other.Location );
		Pawn(Other).AddVelocity( DeathThrowRange );
		PlaySound( DeathSound, , DeathSoundVolume * TransientSoundVolume );
		Spawn( DeathEffect, , , Other.Location - Other.CollisionHeight * vect( 0, 0, 1 ) );
	}
}

defaultproperties
{
	bTriggerOnceOnly=false
	DeathSoundVolume=3.0
	DeathEffect=Class'xEffects.LandMineExplosion'
	DeathSound=Sound'WeaponSounds.BaseImpactAndExplosion.explosion3'
	DeathThrowRange=(X=0.0,Y=0.0,Z=1000.0)
	DeathType=Class'LCA_DamTypeLandMine'
}
