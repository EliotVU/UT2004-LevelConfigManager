/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : The material slot of the specified {{classgames|MaterialSwitch}} will be incremented, if the end is reached it will start all over again.
==============================================================================*/
class LCA_NetMaterialTrigger extends Info
	placeable;

var() editinlineuse MaterialSwitch MaterialSwitch;

var int InitSlot, NewSlot, OldSlot;

replication
{
	reliable if( bNetDirty )
		NewSlot;
}

simulated function SetMaterialNum( int slot )
{
	if( MaterialSwitch != none )
	{
		MaterialSwitch.Current = slot;
		MaterialSwitch.Material = MaterialSwitch.Materials[slot];
	}
	NewSlot = slot;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if( Role == ROLE_Authority && MaterialSwitch != none )
	{
		InitSlot = MaterialSwitch.Current;
		MaterialSwitch.Material = MaterialSwitch.Materials[InitSlot];

		NewSlot = InitSlot;
	}
}

simulated event PostNetBeginPlay()
{
	local int i;

	super.PostNetBeginPlay();
	if( Level.NetMode != NM_Client )
		return;

	SetMaterialNum( NewSlot );
}

simulated event PostNetReceive()
{
	if( NewSlot != OldSlot )
	{
		SetMaterialNum( NewSlot );
		OldSlot = NewSlot;
	}
	super.PostNetReceive();
}

function Trigger( Actor Other, Pawn P )
{
	if( Level.NetMode != NM_Client )
	{
		if( ++ NewSlot >= MaterialSwitch.Materials.Length )
		{
        	NewSlot = 0;
		}
		NetUpdateTime = Level.TimeSeconds - 1;

		if( Level.NetMode == NM_Standalone )
		{
			PostNetReceive();
		}
	}
	super.Trigger( Other, P );
}

function Reset()
{
	if( Level.NetMode != NM_Client )
	{
		NewSlot = InitSlot;
		NetUpdateTime = Level.TimeSeconds - 1;

		if( Level.NetMode == NM_Standalone )
		{
			PostNetReceive();
		}
	}
	super.Reset();
}

defaultproperties
{
	RemoteRole=ROLE_DumbProxy

	bNetNotify=true
	bAlwaysRelevant=true

	bNoDelete=true

	NetUpdateFrequency=0.1

	Texture=A_ActorIcon
}
