//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_RainbowLight extends Light;

var() float TickUpdateDelay;
var noexport float LastTickUpdate;

event PreBeginPlay()
{
	super.PreBeginPlay();
	if( Level.NetMode == NM_DedicatedServer )
	{
		Disable( 'Tick' );
	}
}

simulated event Tick( float dt )
{
	if( (Level.TimeSeconds - LastTickUpdate) > TickUpdateDelay )
	{
		class'LCA_Util'.static.RGBToHLS( class'LCA_Util'.static.GetFlashColor( Level.TimeSeconds / Level.TimeDilation ), LightHue, LightBrightness, LightSaturation );
	}
	LastTickUpdate = Level.TimeSeconds;
}

defaultproperties
{
	TickUpdateDelay=0.0
	//bNoDelete=true
	bStatic=false
	RemoteRole=ROLE_SimulatedProxy
	bDynamicLight=true
}
