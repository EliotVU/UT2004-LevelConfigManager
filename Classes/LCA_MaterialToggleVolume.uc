/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 07/08/2008
 * ;Last Updated : 21/06/2010
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Active Touch

;On Activation : Sets the '''MaterialSwitch''' slot to '''ONSlot''' when a pawn is actively touching(while on ground) this volume, '''OFFSlot''' if nobody if no active touch.
==============================================================================*/
class LCA_MaterialToggleVolume extends PhysicsVolume;

var() editinlineuse MaterialSwitch MaterialSwitch;
var() int ONSlot, OFFSlot;

simulated function SetMaterialNum( int slot )
{
	if( MaterialSwitch != none )
	{
		MaterialSwitch.Current = slot;
		MaterialSwitch.Material = MaterialSwitch.Materials[slot];
	}
}

simulated function KeepOFF()
{
	if( MaterialSwitch == None )
		return;

	if( MaterialSwitch.Current != OFFSlot )
  	{
		SetMaterialNum( OFFSlot );
	}
}

simulated function KeepON()
{
	if( MaterialSwitch == None )
		return;

  	if( MaterialSwitch.Current != ONSlot )
  	{
		SetMaterialNum( ONSlot );
	}
}

simulated event Tick( float DeltaTime )
{
	local Pawn A, P;

	if( Level.NetMode == NM_DedicatedServer )
	{
		Disable( 'Tick' );
		return;
	}

	foreach TouchingActors( Class'Pawn', A )
	{
		if( A.Physics == PHYS_Walking )
		{
			P = A;
			break;
		}
	}

	if( P != none )
	{
		KeepON();
	}
	else
	{
		KeepOFF();
	}
}

defaultproperties
{
	ONSlot=1
	OFFSlot=0

	bStatic=false
	RemoteRole=ROLE_SimulatedProxy
}
