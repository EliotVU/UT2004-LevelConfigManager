//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_AirDamType Extends DamageType
	Abstract;

DefaultProperties
{
	DeathString="%o Got owned by %k Shield Gun."
	FemaleSuicide="Silly %o Owned HerSelf with AirShieldGun."
	MaleSuicide="Silly %o Owned HimSelf with AirShieldGun."
	bLocationalHit=False
	bCausedByWorld=True
	GibModifier=9.000000
	DamageOverlayMaterial=FinalBlend'UT2004Weapons.Shaders.PurpleShockFinal'
	DamageOverlayTime=2.000000
	GibPerterbation=7.100000
}
