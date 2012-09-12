/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2009
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : Modifies various common properties on the entering pawn owned [[ShieldGun]] weapon(if any).
==============================================================================*/
Class LCA_ShieldGunVolume Extends LCA_Volumes;

var() float
	MaxChargeTime,
	MaxHoldTime,
	MinHoldTime,
	FireRate,
	MinForce,
	MaxForce,
	SelfForceScale,
	ShieldRange;

var() bool bResetVolume;

Simulated Function PawnEnteredVolume( Pawn Other )
{
	local Inventory Inv;
	local ShieldFire F;

	if( IsPawnRelevant( Other ) )
	{
		for( Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( Weapon(Inv) != None && Weapon(Inv).GetFireMode( 0 ).IsA('ShieldFire') )
			{
				F = ShieldFire(Weapon(Inv).GetFireMode( 0 ));
				if( F != None )
				{
					if( bResetVolume )
					{
						F.FullyChargedTime = 2.5;
						F.MaxHoldTime = 0.0;
						F.MinHoldTime = 0.4;
						F.FireRate = 0.6;
						F.ShieldRange = 112.0;
						F.MinForce = 65000.0;
						F.MaxForce = 100000.0;
						F.SelfForceScale = 1.0;
						continue;
					}

					if( MaxChargeTime != 2.5 )
						F.FullyChargedTime = MaxChargeTime;

					if( MaxHoldTime != 0.0 )
						F.MaxHoldTime = MaxHoldTime;

					if( MinHoldTime != 0.4 )
						F.MinHoldTime = MinHoldTime;

					if( FireRate != 0.6 )
						F.FireRate = FireRate;

					if( ShieldRange != 112.0 )
						F.ShieldRange = ShieldRange;

					if( MinForce != 65000.0 )
						F.MinForce = MinForce;

					if( MaxForce != 100000.0 )
						F.MaxForce = MaxForce;

					if( SelfForceScale != 1.0 )
						F.SelfForceScale = SelfForceScale;
				}
			}
		}
	}
}

DefaultProperties
{
	Info="This volume changes the ShieldGun Fire properties on enter."

	MaxHoldTime=0.0
	MinHoldTime=0.4
	MaxChargeTime=2.5
	FireRate=0.6
	ShieldRange=112.0
	MinForce=65000.0
	MaxForce=100000.0
	SelfForceScale=1.0
}
