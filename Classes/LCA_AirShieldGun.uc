//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
//=============================================================================
// fly in the air!.
// Coded by Eliot,
// Bots really suck with this gun :).
//=============================================================================
Class LCA_AirShieldGun Extends ShieldGun;

var() int HealthBoost;
var bool bIsZoomed;

Replication
{
	reliable if( bNetDirty && (Role == ROLE_Authority) )
		HealthBoost;
}

Simulated Function ClientStartFire( int Mode )
{
	if( Mode == 1 )
	{
		FireMode[Mode].bIsFiring = True;
		if( Instigator != None && Instigator.Controller.IsA('PlayerController') && !PlayerController(Instigator.Controller).bBehindView )
		{
			PlayerController(Instigator.Controller).ToggleZoom();
			bIsZoomed = True;
		}
		else if( PlayerController(Instigator.Controller).bBehindView )
			PlayerController(Instigator.Controller).StopZoom();
	}
	else Super.ClientStartFire(mode);
}

Simulated Function ClientStopFire( int Mode )
{
	if( Mode == 1 )
	{
		FireMode[Mode].bIsFiring = False;
		if( Instigator != None && Instigator.Controller.IsA('PlayerController') )
			PlayerController(Instigator.Controller).StopZoom();
		bIsZoomed = False;
	}
	else Super.ClientStopFire(mode);
}

Simulated function bool PutDown()
{
	if( Instigator != None && Instigator.Controller.IsA('PlayerController') )
		PlayerController(Instigator.Controller).EndZoom();
	bIsZoomed = False;
	return Super.PutDown();
}

Simulated Function ClientWeaponThrown()
{
	if( Instigator != None && Instigator.Controller.IsA('PlayerController') )
		PlayerController(Instigator.Controller).EndZoom();
	bIsZoomed = False;
	Super.ClientWeaponThrown();
}

Simulated Function float ChargeBar()
{
	return FMin( 1 ,FireMode[0].HoldTime/LCA_AShieldFire(FireMode[0]).FullyChargedTime );
}

DefaultProperties
{
	HealthBoost=10

	FireModeClass(0)=Class'LCA_AShieldFire'
	FireModeClass(1)=Class'SniperZoom'
	Description="AirShieldGun."
	InventoryGroup=1
	AttachmentClass=Class'LCA_PShieldAttachment'
	PickupClass=Class'LCA_ASGPickup'
	IconMaterial=FinalBlend'HUDContent.Generic.HUDPulse'
	ItemName="ÿÿAir Boost Gun"
	LightType=LT_Steady
	LightEffect=LE_NonIncidence
	LightHue=213
	LightSaturation=60
	LightBrightness=150.000000
	LightRadius=5.400000
	LightPeriod=3
	bDynamicLight=True
	DrawScale=0.200000
	HighDetailOverlay=FinalBlend'UT2004Weapons.Shaders.PurpleShockFinal'
}
