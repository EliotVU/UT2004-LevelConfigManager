//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_ASGPickup Extends ShieldGunPickup;

DefaultProperties
{
	InventoryType=class'LCA_AirShieldGun'
	PickupMessage="ÿÿYou Picked up a Air ShieldGun."
	PickupSound=Sound'PickupSounds.ShieldGunPickup'
	PickupForce="ShieldGunPickup"
	MaxDesireability=+0.39
	StaticMesh=StaticMesh'WeaponStaticMesh.ShieldGunPickup'
	DrawType=DT_StaticMesh
	DrawScale=0.3
}
