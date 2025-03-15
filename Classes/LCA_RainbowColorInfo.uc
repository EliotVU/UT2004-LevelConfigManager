//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//
//	Created @ 2009.
//==============================================================================
class LCA_RainbowColorInfo extends Info
	placeable;

var() editconst noexport const private string Info;
var() editinlineuse array<ConstantColor> ColorMaterials; // Not available on server!

event PreBeginPlay()
{
	super.PreBeginPlay();
	if( Level.NetMode == NM_DedicatedServer )
	{
		Disable( 'Tick' );
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if( ColorMaterials.Length == 0 )
	{
		Destroy();
		return;
	}
}

simulated event Tick( float DeltaTime )
{
	local int CurMat, NumMats;

	if( Level.NetMode != NM_DedicatedServer )
	{
   		for( CurMat = 0; CurMat < ColorMaterials.Length; ++ CurMat )
		{
			ColorMaterials[CurMat].Color = class'LCA_Util'.static.GetFlashColor( Level.TimeSeconds / Level.TimeDilation );
			continue;
		}
	}
}

defaultproperties
{
	Info="Changes the color of all set 'ColorMaterials' to fade like a rainbow."

    bStatic=false
	bNoDelete=true
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysTick=true
}
