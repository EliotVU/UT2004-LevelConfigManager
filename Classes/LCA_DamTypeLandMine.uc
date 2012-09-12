//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
// Used by LandMineVolume.
Class LCA_DamTypeLandMine Extends DamageType
	Abstract;

DefaultProperties
{
	DeathString="%o Stepped a little to close"
	FemaleSuicide="%o Stepped a little to close"
	MaleSuicide="%o Stepped a little to close"

	DamageOverlayMaterial=Texture'ONSDeadVehicles-TX.RVDead'
	DamageOverlayTime=5.000000
}
