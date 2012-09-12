//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
//=================================================================
// Funky stuff...
// Coded by Eliot aka ->UT2X<-Eliot.
//=================================================================
Class LCA_DodgePickup Extends TournamentPickup
	Placeable;

var() float DodgeLengthBonus;
var() sound AnnounceSound;

Auto State Pickup
{
	Function Touch( Actor Other )
	{
    	if( ValidTouch( Other ) )
    	{
	    	xPawn(Other).DodgeSpeedFactor = DodgeLengthBonus;
	    	if( AnnounceSound != None )
				PlaySound( AnnounceSound, SLOT_None, 2 * TransientSoundVolume );
        	AnnouncePickup( xPawn(Other) );
	    	SetRespawn();
    	}
	}
}

DefaultProperties
{
	DodgeLengthBonus=2.5
	AnnounceSound=Sound'Announcer.(All).nicecatch'
	RespawnTime=0.5
	PickupMessage="You picked up DodgePower!."
	PickupSound=Sound'PickupSounds.AdrenelinPickup'
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'XPickups_rc.AdrenalinePack'
	DrawScale=0.1
	Skins(0)=Shader'XGameShaders.BRShaders.BombIconYS'
	TransientSoundVolume=100.0
	TransientSoundRadius=600.0
	RotationRate=(Yaw=28000)
}
