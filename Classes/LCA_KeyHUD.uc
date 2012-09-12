//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
#Exec obj load file="UT2003Fonts.utx"
class LCA_KeyHUD extends HUDOverlay
	notplaceable
	hidedropdown;

var protected array<LCA_KeyPickup> CachedKeys;
var protected PlayerController LocalPC;
var protected Font KeyFont;

simulated event PostBeginPlay()
{
	local LCA_KeyPickup Key;

	LocalPC = Level.GetLocalPlayerController();
	CachedKeys.Length = 0;
	foreach AllActors( Class'LCA_KeyPickup', Key )
	{
		CachedKeys[CachedKeys.Length] = Key;
	}

	if( CachedKeys.Length == 0 )
	{
		// Were useless :(
		Destroy();
	}
}

simulated function bool HasKey( int index )
{
	local Inventory Inv;

	if( LocalPC.Pawn != none )
		for( Inv = LocalPC.Pawn.Inventory; Inv != none; Inv = Inv.Inventory )
			if( LCA_KeyInventory(Inv) != none && CachedKeys[index].KeyName == LCA_KeyInventory(Inv).KeyName )
				return true;

	return false;
}

simulated function bool IsWithinView( int index )
{
	//local vector HitLocation, HitNormal;
	local vector CamPos;
	local rotator CamRot;
	local vector X, Y, Z;
	local float Dist;
	local vector Dir;
	local Actor view;

    LocalPC.PlayerCalcView( view, CamPos, CamRot );
	//return !CachedKeys[index].TraceThisActor( HitLocation, HitNormal, CachedKeys[index].Location, CamPos, CachedKeys[index].GetCollisionExtent() );

	GetAxes( CamRot, X, Y, Z );
	Dir = CachedKeys[index].Location - CamPos;
	Dist = VSize( Dir );
	Dir /= Dist;
	return (Dir dot X) > 0.2 && Dist < 3000;
}

simulated protected function RenderKey( Canvas C, int index )
{
	if( CachedKeys[index].RenderKey( C, self, index ) || HasKey( index ) || !IsWithinView( index ) )
	{
		return;
	}

	C.DrawColor = CachedKeys[index].KeyColor;
	Class'HUD_Assault'.static.Draw_2DCollisionBox
	(
		C,
		CachedKeys[index],
		C.WorldToScreen( CachedKeys[index].Location ),
		Eval( CachedKeys[index].bOptional, "Optional ", "" ) $ CachedKeys[index].KeyName,
		CachedKeys[index].DrawScale,
		true
	);
}

simulated function Render( Canvas C )
{
	local int i;

    C.Font = KeyFont;
	for( i = 0; i < CachedKeys.Length; ++ i )
	{
		if( CachedKeys[i] == none )
			continue;

		RenderKey( C, i );
	}
}

defaultproperties
{
	KeyFont=Font'UT2003Fonts.jFontSmallText800x600'
}
