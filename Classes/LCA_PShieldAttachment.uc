//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_PShieldAttachment extends ShieldAttachment;

var xEmitter PinkRings;
var bool bPinkRings;

//=====================
//Emitter Spawn Code
Simulated Function PostBeginPlay()
{
	if( bPinkRings && PinkRings == None && Level.NetMode != NM_Client )
		PinkRings = Spawn( Class'LCA_PinkRings', Self );
	Super.PostBeginPlay();
}

Simulated Function Destroyed()
{
	if( PinkRings != None )
		PinkRings.Destroy();
	Super.Destroyed();
}

//End.
//=====================

DefaultProperties
{
	bPinkRings=True
	LightType=LT_Steady
	LightEffect=LE_NonIncidence
	LightHue=213
	LightSaturation=60
	LightBrightness=150.000000
	LightRadius=5.400000
	LightPeriod=3
	bDynamicLight=True
	HighDetailOverlay=FinalBlend'UT2004Weapons.Shaders.PurpleShockFinal'
}
