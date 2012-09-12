//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyCorona extends Effects;

var protected ColorModifier CoronaColor;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	Update();
}

simulated function Hide()
{
	bHidden = true;
}

simulated function Show()
{
	bHidden = false;
}

simulated protected function Update()
{
 	CoronaColor.Color = LCA_KeyPickup(Owner).KeyColor;
 	Skins[0] = CoronaColor;
 	Texture = CoronaColor;
}

defaultproperties
{
    Style=STY_Translucent
    begin object class=ColorModifier name=soCM
    	Material=Texture'EmitterTextures.Flares.EFlaredim'
    end object
    CoronaColor=soCM
    bUnlit=true
    bStasis=true
}
