//==============================================================================
//	LevelConfigManager (C) 2006 - 2014 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyPickup extends Pickup
	placeable;

var(Pickup) bool bTeleportInstigatorToSpawn;
var(Pickup) bool bDisplayKeysCount;
// Note, you must update Corona.CoronaColor as well when changing this on runtime!.
var(Pickup) bool bOptional;

var(Pickup) string KeyName;
var(Pickup) Color KeyColor;
var(Pickup) edfindable array<edfindable Actor> KeyComponents;
var(Pickup) class<LCA_KeyEmitter> KeyEmitterClass;
var(Pickup) class<LCA_KeyInventory> KeyInventoryClass;

var noexport editconst LCA_KeyEmitter KEmitter;
var private string _TempPickupMessage, _TempKeyName;
var private Color _TempKeyColor;

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

// function NotifyLocalPlayerDead( PlayerController PC )
// {
// 	// Make sure the server does not unhide this or it would unhide for everyone
// 	if( Level.NetMode != NM_DedicatedServer )
// 		Show();

// 	super.NotifyLocalPlayerDead( PC );
// }

auto state Pickup
{
	// HACK: Copy and pasted parent's code to insert a condition between the basic checks and the triggerevent call.
	function bool ValidTouch( actor Other )
	{
		local Inventory Inv;

		// make sure its a live player
		if ( (Pawn(Other) == None) || !Pawn(Other).bCanPickupInventory || (Pawn(Other).DrivenVehicle == None && Pawn(Other).Controller == None) )
			return false;

		// make sure not touching through wall
		if ( !FastTrace(Other.Location, Location) )
			return false;

		for( Inv = Pawn(Other).Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( LCA_KeyInventory(Inv) != None )
			{
				if( LCA_KeyInventory(Inv).KeyName == KeyName )
					return false;
			}
		}

		// make sure game will let player pick me up
		if( Level.Game.PickupQuery(Pawn(Other), self) )
		{
			TriggerEvent(Event, self, Pawn(Other));
			return true;
		}
		return false;
	}

	function Touch( Actor Other )
	{
		local inventory Inv;
		local LCA_KeyInventory Key;
		local NavigationPoint NewSpawn;
		local int FoundKeys;
		local Inventory Copy;

    	if( ValidTouch( Other ) )
    	{
    		Key = Spawn( KeyInventoryClass, Other );
    		Key.PickupSource = self;
    		Key.KeyName = KeyName;
			Key.bOptional = bOptional;
			Key.GiveTo( Pawn(Other), self );
        	AnnouncePickup( Pawn(Other) );

        	if( InventoryType != none )
        	{
        		Copy = SpawnCopy(Pawn(Other));
				if ( Copy != None )
					Copy.PickupFunction(Pawn(Other));
        	}

        	if( ASPlayerReplicationInfo(Pawn(Other).PlayerReplicationInfo) != None )
        	{
				++ ASPlayerReplicationInfo(Pawn(Other).PlayerReplicationInfo).DisabledObjectivesCount;
				Pawn(Other).PlayerReplicationInfo.Score += 10;
				Level.Game.ScoreObjective( Pawn(Other).PlayerReplicationInfo, 10 );
			}

			// Limited to Assault only.
			if( bDisplayKeysCount && ASGameInfo(Level.Game) != none )
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

		    		if( LCA_KeyObjective(ASGameInfo(Level.Game).GetCurrentObjective()) != none && FoundKeys > 0 )
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

function UpdateDefaults()
{
	_TempPickupMessage = default.PickupMessage;
	_TempKeyName = default.KeyName;
	_TempKeyColor = default.KeyColor;
	default.PickupMessage = PickupMessage;
	default.KeyName = KeyName;
	default.KeyColor = KeyColor;
}

function RestoreDefaults()
{
	default.PickupMessage = _TempPickupMessage;
	default.KeyName = _TempKeyName;
	default.KeyColor = _TempKeyColor;
}

function AnnouncePickup( Pawn Receiver )
{
	// HACK: Don't call HandlePickup because we want to use our own message class that uses non-default values.
	// Here we simulate some of the behaviors of HandlePickup.
	// Receiver.HandlePickup(self);
	MakeNoise(0.2);

	Receiver.ReceiveLocalizedMessage( MessageClass, 0, none, none, self );
	PlaySound( PickupSound, SLOT_Interact );
}

static function string GetLocalString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2
	)
{
	return Repl( default.PickupMessage, "%k", default.KeyName );
}

defaultproperties
{
	// We don't want bHidden to be replicated to avoid the server from overwriting the value that the local player did set.
	bOnlyReplicateHidden=false
	bSkipActorPropertyReplication=true


	bAmbientGlow=true
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

	bEdShouldSnap=true

	MessageClass=class'LCA_KeyMessage'
	KeyEmitterClass=class'LCA_KeyEmitter'
	KeyInventoryClass=class'LCA_KeyInventory'
	KeyColor=(R=255,G=255,B=0,A=255)
	KeyName="Gold Key"
	PickupMessage="You picked up a %k."
	bDisplayKeysCount=true
}
