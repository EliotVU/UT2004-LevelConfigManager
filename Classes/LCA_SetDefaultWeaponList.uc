/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : The specified ''StartWeaponList'' will be applied to the DefaultWeapons list in ''LevelConfigActor''.
==============================================================================*/
class LCA_SetDefaultWeaponList extends LCA_Triggers
	hidecategories(Message,LCA_Triggers)
	placeable;

var() LevelConfigActor.sDefWepList StartWeaponList;

var protected LevelConfigActor Master;

event PreBeginPlay()
{
	super.PreBeginPlay();
	Master = GetLCA();
}

function Trigger( Actor Other, Pawn P )
{
	local Controller C;

	if( Master != None )
		Master.StartWeaponList = StartWeaponList;

	for( C = Level.ControllerList; C != None; C = C.NextController )
		ClearPlayer( C );
}

function ClearPlayer( Controller C )
{
	local Inventory INV;

	if( C != None )
		for( INV = C.Pawn.Inventory; INV != None; INV = INV.Inventory )
			if( !IgnoreWeapon( INV ) )
				INV.Destroy();
}

function bool IgnoreWeapon( Inventory INV )
{
	local int i;

	for( i = 0; i < StartWeaponList.DefaultStartWeapons.Length; i ++ )
		if( StartWeaponList.DefaultStartWeapons[i].DefaultStartWeapon.Class == INV )
			return True;
	return False;
}

defaultproperties
{
	Info="New Weaponlist will be applied whenever this actor gets triggered."
}
