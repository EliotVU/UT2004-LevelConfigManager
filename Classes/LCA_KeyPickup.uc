//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyPickup extends Pickup
	placeable;

var() bool bTeleportInstigatorToSpawn;
var() bool bDisplayKeysCount;
var() string KeyName;
// Note, you must update Corona.CoronaColor as well when changing this on runtime!.
var() Color KeyColor;
var() bool bOptional;
var() edfindable array<Actor> KeyComponents;

var noexport editconst LCA_KeyEmitter KEmitter;
var() class<LCA_KeyEmitter> KeyEmitterClass;

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if( Level.NetMode != NM_DedicatedServer && KeyEmitterClass != none )
	{
    	KEmitter = Spawn( KeyEmitterClass, self );
	}
}

simulated function Hide()
{
	local int i;

    bHidden = true;
	for( i = 0; i < KeyComponents.Length; ++ i )
	{
		if( KeyComponents[i] != none )
		{
			KeyComponents[i].bHidden = true;
		}
	}

	if( KEmitter != none )
	{
		KEmitter.Hide();
	}
}

simulated function Show()
{
	local int i;

	bHidden = false;
	for( i = 0; i < KeyComponents.Length; ++ i )
	{
		if( KeyComponents[i] != none )
		{
			KeyComponents[i].bHidden = false;
		}
	}

	if( KEmitter != none )
	{
		KEmitter.Show();
	}
}

// Meant to be overriden by custom keypickups, return true to override the original drawing done by LCA_KeyHUD.
simulated function bool RenderKey( Canvas C, LCA_KeyHUD kh, int index )
{
	return false;
}

function NotifyLocalPlayerDead( PlayerController PC )
{
	// Make sure the server does not unhide this or it would unhide for everyone
	if( Level.NetMode != NM_DedicatedServer )
		Show();

	super.NotifyLocalPlayerDead( PC );
}

auto state Pickup
{
	function Touch( Actor Other )
	{
		local inventory Inv;
		local LCA_KeyInventory Key;
		local NavigationPoint NewSpawn;
		local int FoundKeys;

    	if( ValidTouch( Other ) )
    	{
    		// Make sure he don't have this key already!
    		for( Inv = Pawn(Other).Inventory; Inv != None; Inv = Inv.Inventory )
    		{
    			if( LCA_KeyInventory(Inv) != None )
    			{
    				if( LCA_KeyInventory(Inv).KeyName == KeyName )
    					return;
    			}
    		}

    		Key = Spawn( Class'LCA_KeyInventory', Other );
    		Key.PickupSource = self;
    		Key.KeyName = KeyName;
			Key.bOptional = bOptional;
			Key.GiveTo( Pawn(Other), self );
        	AnnouncePickup( Pawn(Other) );

        	if( ASPlayerReplicationInfo(Pawn(Other).PlayerReplicationInfo) != None )
        	{
				++ ASPlayerReplicationInfo(Pawn(Other).PlayerReplicationInfo).DisabledObjectivesCount;
				Pawn(Other).PlayerReplicationInfo.Score += 10;
				Level.Game.ScoreObjective( Pawn(Other).PlayerReplicationInfo, 10 );
			}

			if( bDisplayKeysCount )
			{
				if( !bOptional )
				{
		        	for( Inv = Pawn(Other).Inventory; Inv != None; Inv = Inv.Inventory )
		    		{
		    			if( LCA_KeyInventory(Inv) != None )
		    			{
							++ FoundKeys;
		    			}
		    		}

		    		if( ASGameInfo(Level.Game) != none && LCA_KeyObjective(ASGameInfo(Level.Game).GetCurrentObjective()) != none && FoundKeys > 0 )
		 				Pawn(Other).ClientMessage( "You have"@FoundKeys@"of the"@LCA_KeyObjective(ASGameInfo(Level.Game).GetCurrentObjective()).KeyCondition.RequiredKeys.Length@"Keys" );
				}
				else
				{
					Pawn(Other).ClientMessage( "You picked up an optional key, this does not count towards your found keys!" );
				}
			}

        	if( bTeleportInstigatorToSpawn )
        	{
        		NewSpawn = Level.Game.FindPlayerStart( Pawn(Other).Controller, Pawn(Other).GetTeamNum() );
        		if( NewSpawn != None )
        		{
        			Other.SetLocation( NewSpawn.Location );
        			Other.SetRotation( NewSpawn.Rotation );

        			xPawn(Other).ClientMessage( "You have been teleported back to your spawn location" );
        			xPawn(Other).PlayTeleportEffect( False, True );
        		}
        	}
    	}
	}
}

function SetRespawn()
{
}

simulated event Destroyed()
{
	if( Level.NetMode != NM_DedicatedServer )
	{
		if( KEmitter != none )
		{
			KEmitter.Destroy();
		}
		Hide();
	}
	super.Destroyed();
}

defaultproperties
{
	// We don't want bHidden to be replicated to avoid the server from overwriting the value that the local player did set.
	bOnlyReplicateHidden=false
	bSkipActorPropertyReplication=true

	bDisplayKeysCount=true

	bAmbientGlow=true
	MessageClass=Class'PickupMessagePlus'

	KeyName="Gold Key"
	PickupMessage="You picked up a key."
	PickupSound=Sound'WeaponSounds.BReload9'
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'E_Pickups.FullBomb'
	DrawScale=1.0
	RotationRate=(Yaw=28000)
	RespawnTime=1.0
	Mass=24.0f
	MaxDesireability=1.0

	bNoDelete=true
	bGameRelevant=true
	// Need for emitter to be visible
	bBlockZeroExtentTraces=false
	KeyColor=(R=255,G=255,B=0,A=255)

	bEdShouldSnap=true

	KeyEmitterClass=class'LCA_KeyEmitter'
}
