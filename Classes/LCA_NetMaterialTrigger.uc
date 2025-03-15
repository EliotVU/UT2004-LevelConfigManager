/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : The material slot of the specified {{classgames|MaterialSwitch}} will be incremented, if the end is reached it will start all over again.
==============================================================================*/
class LCA_NetMaterialTrigger extends Triggers
	placeable;

#exec Texture Import File=Textures\NetMaterialTrigger.pcx Name=S_NetMaterialTrigger Mips=Off MASKED=1

var() editinline MaterialSwitch MaterialSwitch;
var int InitSlot;
var protected int NewSlot;

replication
{
	reliable if( bNetDirty )
		NewSlot;
}

simulated function SetMaterialNum( int slot )
{
	if( MaterialSwitch != none && MaterialSwitch.Current != slot )
	{
		MaterialSwitch.Current = slot;
		MaterialSwitch.Material = MaterialSwitch.Materials[slot];
	}
	NewSlot = slot;
}

simulated function UpdateMaterialSlot()
{
	SetMaterialNum( NewSlot );
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
	UpdateMaterialSlot();
	super.PostNetReceive();
}

function Trigger( Actor other, Pawn player )
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
			UpdateMaterialSlot();
		}
	}
	super.Trigger( other, player );
}

function UnTrigger( Actor other, Pawn player )
{
	if( Level.NetMode != NM_Client )
	{
		if( -- NewSlot < 0 )
		{
        	NewSlot = MaterialSwitch.Materials.Length - 1;
		}
		NetUpdateTime = Level.TimeSeconds - 1;

		if( Level.NetMode == NM_Standalone )
		{
			UpdateMaterialSlot();
		}
	}
	super.UnTrigger( other, player );
}

function Reset()
{
	if( Level.NetMode != NM_Client )
	{
		NewSlot = InitSlot;
		NetUpdateTime = Level.TimeSeconds - 1;

		if( Level.NetMode == NM_Standalone )
		{
			UpdateMaterialSlot();
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
	bCollideActors=false

	Texture=S_NetMaterialTrigger
}
