//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyEmitter extends Emitter;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	Update();
}

simulated function Hide()
{
	bHidden = true;
	bCorona = false;
}

simulated function Show()
{
	bHidden = false;
	bCorona = true;
}

simulated protected function Update()
{
	class'LCA_Util'.static.RGBToHLS( LCA_KeyPickup(Owner).KeyColor, LightHue, LightBrightness, LightSaturation );
}

defaultproperties
{
    bCorona=true
    bNoDelete=false
    DrawScale3D=(X=0.300000,Y=0.300000,Z=0.300000)
	Skins(0)=Texture'EmitterTextures.Flares.EFlaredim'
    LightType=LT_Steady
}
