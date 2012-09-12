//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================

/*
	TODO:
		ScriptedSequence ActorAction.

	Utils:
		ColorTags Operators utils written by Eliot - http://wiki.beyondunreal.com/User:Eliot/ColorTags_Operators

  	Credits:
		.:..: for helping me with learning UnrealScript as this is my first real project and the LCA_Util rainbow color functions.
		Gugi for being nice by making a serverside actor to fix a few LCA bugs(on some servers, was caused by changing the default value) that was present in older LCA versions.

 		Last Modified 2010 - July 10.
*/

/**
 * '''LevelConfigActor''' or '''LCA''' is the main and most important actor of the '''LevelConfigManager''' package.
 * LCA has features such as customized pawn properties i.e. ''Health'', ''HealthMax''.
 * LCA also provides many other features such as '''TimedMessages''' which lets the L.D.s set a custom message about their map that will be displayed to players every few minutes(random)
 * this feature includes Map Author, a notification about LCA and a credits message.
 */
class LevelConfigActor extends Mutator
	dependson(LCA_LocalPlayerInfo)
	config(LevelConfigManager)
	// none of these categories are useful to this actor.
	hidecategories(Lighting,LightColor,Karma,Force,Mutator,Collision,Sound,Events,None)
	placeable
	hidedropdown
	cacheexempt;

#Exec Texture Import File=Textures\S_Master.pcx Name=S_LA MASKED=1 Alpha=1

/** If TRUE then certain debug log messages will be logged. */
var config noexport bool bDebug;

/** Explains what the most of the basic properties do. */
var(Information) localized const noexport editconst array<string> ActorExplain;

/** Author of this mapping tool. */
var(Information) const noexport editconst name Author;

/** Download link to this mapping tool. */
var(Information) const noexport editconst string Download;

/** Version of this mapping tool. */
var(Information) const noexport editconst string Version;

/** A property struct. */
struct sProperty
{
	/** The name of a property to assign the PropertyValue on. */
	var() string PropertyName;

	/** The value to set for the property of PropertyName. */
	var() string PropertyValue;
};

var(AirShieldGun) bool
	bCanDropWeapon,
	bHaveAirShieldGun,
	bNoDynamicLight,
	bNoPinkRings;

var(AirShieldGun) int HealthBoost;

/** Obsolete since bCanDropWeapon has been deprecated. */
struct sWeaponList
{
	/** The weapon class to use as the start weapon. */
	var() class<Inventory> DefaultStartWeapon;

	/** Whether the given weapon can be dropped. */
	//var() bool bCanDropWeapon;
};

/** The properties for in a DefaultStartWeapons list. */
struct sDefWepList
{
	/** A list of weapon classes that players will use as their default weapons they will spawn with. */
	var() export array<sWeaponList> DefaultStartWeapons;

	/** Use this DefaultStartWeapons list instead of the one specified by the game. */
	var() const bool bEnabled;
};

/** A struct with a list of weapon classes and an option bEnabled to decide whether LevelConfigActor should use this list as the default weapon classes. */
var(DefaultWeapons) sDefWepList StartWeaponList;

/** A backup of StartWeaponList set on *BeginPlay(), StartWeaponList will be set to this by Reset(). */
var sDefWepList DefWepBackup;

/** Properties related to the [[Weapon]] class. */
struct sWeapon
{
	/** Whether overriding the new ammocount may be applied. */
	var() const bool bEnabled;

	/** The new ammocount to apply on all weapons. */
	var() int Amount;
};

/** Specific [[Weapon]] related properties. */
var(Weapon) sWeapon Weapons;

/** A set properties to be applied to the specified '''ProjectileClass'''. */
struct sProjectile
{
	/** The projectile class to apply those properties of this struct to. */
	var() class<Projectile> ProjectileClass;

	/** Projectile properties to modify. */
	var() array<sProperty> Properties;
};

/** An list of specified projectile classes that should have their properties modified on spawn. */
var(Projectile) array<sProjectile> Projectiles;

/** The player view mode to force players to. */
var(Extra) enum EForceView
{
	/**  Don't force the players view. */
	FV_None,
	/** Force the players view to first person i.e. the player cannot use BehindView. */
	FV_OnlyFirstPerson,
	/** Force the players view to third person i.e. the player cannot use FirstPerson. */
	FV_OnlyThirdPerson
} ForceView;

/** Because of trials players blocking each other is a major issue therefor mutators have been made to turn off the collision.
However people don't have or don't use those mutators and so it's better to have this implemented in the map itself. */
var(Extra) bool bNoPawnCollision;

/** Sets the respawn time of pickups to 0.5.
Because of trials pickups need to be available anytime, this feature was added so that you don't have to bother configuring the properties of each pickup. */
var(Extra) bool bFastRespawnPickups;

/** The team every newly spawned pawn should be forced to if not already in the specified team. */
var(Extra) enum EForceTeam
{
	/** Don't force the players team. */
	FT_None,
	/** Force the players team to red a.k.a attackers. */
	FT_Red,
	/** Force the players team to blue a.k.a defenders. */
	FT_Blue
} ForceTeam; // The team every newly spawned pawn should be forced to if not already in the specified team.

/** Game speed scaling. */
var(Extra) float GameSpeed;

/** The kind of trial mode(in terms of momentum) to use. */
var(Extra) enum ETrialMode
{
	/** Use a self-specified momentum scaling. */
	TM_Custom,
	/** Don't change the momentum scaling. */
	TM_Normal,
	/** Use the momentum scaling of Deathmatch in Assault. */
	TM_DM,
	/** Use the momentum scaling of Deathmatch with an additional percent of 1.325. */
	TM_Master,
	/** Use the momentum scaling of Deathmatch with an additional percent of 1.5. */
	TM_Berserk
} TrialMode;

/** An already configured propertie values set for various gamemodes. */
var(Extra) enum EMapType
{
	/** Use the default(or your) configuration of LCA. */
	MT_Default,
	/** Use the LCA BunnyTrack configuration e.g. no wall dodges and no double jump. */
	MT_BunnyTrack
} MapType; // A pre-configured set of property values to apply on runtime.

/** Properties related to a skin of an actor(pawn in this case). */
struct sPawnSkin
{
	/** If TRUE apply the specified Skins and the Model(if not none). */
	var() const bool 						bEnabled;

	/** The skins to apply to all players. */
	var() editinlineuse array<Material> 	Skins;

	/** The model to apply to all players. */
	var() Mesh 								Model;
};

/** Required information for attaching actors to newly spawned pawns. */
struct sAttachActor
{
	/** The actor class to spawn and attach to the specified '''BoneName'''. */
	var() class<Actor> 				ActorClass;

	/** The name of a bone where the spawned ActorClass kind will be attached on. */
	var() name 						BoneName;
};

/** Various properties that require knowledge to use properly. */
struct sExtra_xPawn
{
	/** Whether all the properties below will be applied on newly spawned pawns. */
	var() const bool 				bEnabled;

	/** if TRUE then everyone will be able to dodge right away after landing. */
	var() bool						bNoDodgeDelay;

	/** If TRUE certain functions in MutMultiDodge2k3 will be disabled so that the ability of removing dodgejump will remain to work together with that mod. */
	var() bool 						bMakeSureNoDodgeDoubleJump;

	/** The new scale to apply on ''DrawScale'' of newly spawned pawns. */
	var() float 					PlayerSize;

	/** The new scale to apply on ''HeadScale'' of newly spawned pawns. */
	var() float 					HeadSize;

	/** Additional dodge that a player is allowed to do while in air before landing. */
	var() int						DodgeLimit;

	/** Addtional properties to modify on newly spawned pawns. */
	var() array<sProperty> 			ExtraVariables;

	/** The new skin or mesh to apply on newly spawned pawns. */
	var() sPawnSkin 				Skin;

	/** Actors to spawn and attach to newly spawned pawns. On the clientside only.
	 * '''Note:''' Whether it will work offline/online is completely dependent on the actor class you specified.
	 */
	var() array<sAttachActor> 		LocalAttachActors;

	/** Actors to spawn and attach to newly spawned pawns. On the serverside only.
	 * '''Note:''' Whether it will work offline/online is completely dependent on the actor class you specified.
	 */
	var() array<sAttachActor> 		ServerAttachActors;
};

/** Various properties that require knowledge to use properly. */
var(Extra) sExtra_xPawn 			xPawnExtras;

/** An initial comboclass to give to newly spawned pawns. '''Note:''' Only works if the active gametype supports combos. */
var(Extra) class<Combo> 			DefaultCombo;

/** Various properties to define screen overlaying behavior. */
struct sClientOverlay
{
	/** Whether to add an HudOverlay locally on all clients. */
	var() const bool 				bEnabled;

	/** The color of the specified '''Texture'''. */
	var() color 					color;

	/** The texture to overlay on the screen. */
	var() editinlineuse Material 	Texture;

	/** The HudOverlay class to use for rendering the overlay. */
	var() class<LCA_HudOverlay> 	RenderHandler;

	/** Whether the overlay should not be active for spectators. */
	var() bool 						bNotInSpec;
};

/** A texture and color to overlay on screen for all clients. '''Note:''' Overlays the HUD, it is recommend to use the '''CameraOverlay''' in '''CameraEffects'''. */
var(Extra) sClientOverlay 			ScreenOverlay;

/** CameraEffects to apply locally on all clients. */
var(Extra) editinlinenotify export array<CameraEffect> CameraEffects;

/** Properties related to timed messages. */
struct sTimedMessage
{
	/** TimeMessage is enabled, Credits too if bDisplayAuthor is true as well. */
	var() const bool 				bEnabled;

	/** If true then the author set in LevelProperties will be broadcast along with 'TimeMessage'. */
	var() bool 						bDisplayAuthor;

	/** Additional messages to broadcast. */
	var() localized array<string> 	TimeMessage;

	/** Input names of people who contributed, helped or tested your map, each name should be separated with comma.*/
	var() localized string 			Credits;

	/** The color to use to colourize the 'TimeMessage' messages. */
	var() const color 				MessageColor;
};

/** A timed message is something that will appear every several minutes. This timed message provides the ability to display the map author(gathered from LevelProperties) with additional messages about your map(This is a replacement for [[UE2:InfoPod (UT2004)|InfoPods]]). */
var(Extra) sTimedMessage 			TimedMessage;

/** Changes the render mode locally of every client. '''Note:''' Recommend for maps that won't be hosted on servers with anti-cheat mutators such as '''ANTITCC''', '''SafeGame''' and '''ClanManager'''. */
var(Extra) int 						RenderMode;

/** Properties related to the [[GameInfo]] class. */
struct GameStruct
{
	/** Whether to override the game's timelimit to new specified '''TimeLimit''' value. */
	var() const bool 				bEnabled;

	/** The new timelimit(in minutes) to use for the current game. */
	var() byte 						TimeLimit;
};

/** Specific [[GameInfo]] related properties. */
var(GameInfo) GameStruct 			Game;

/** The height boost for the first jump. */
var(PawnMutation) int 				JumpHeight;

/** Amount multiple jumps pawns can do. */
var(PawnMutation) int 				MultiJumpLimit;

/** The height boost for every multiple jump. */
var(PawnMutation) int 				MultiJumpHeight;

/** The amount of health pawns will spawn with. */
var(PawnMutation) int 				DefaultHealth;

/** The amount of shield pawns will spawn with. */
var(PawnMutation) int 				DefaultShield;

/** The max health pawns can have. */
var(PawnMutation) int 				MaxHealth;

/** The max superhealth pawns can have. */
var(PawnMutation) int 				MaxSuperHealth;

/** The max supershield pawns can have. */
var(PawnMutation) int 				MaxSuperShield;

/** The distance a pawn can survive from a fall. */
var(PawnMutation) int 				MaxFallSpeed;

/** The distance a pawn can achieve from a dodge. */
var(PawnMutation) float				DodgeSpeedLength;

/** The height a pawn can achieve from a dodge. */
var(PawnMutation) float				DodgeSpeedHeight;

/** The AirControl strength of pawns. */
var(PawnMutation) float				AirControl;

/** The time a pawn can be under water before he starts to drown. */
var(PawnMutation) float				UnderWaterTime;

/** The scaling of the groundspeed, airspeed, waterspeed, crouchspeed and walkspeed of a pawn. */
var(PawnMutation) float				MoveSpeedScaling;

/** The mass scaling of pawns. */
var(PawnMutation) float				MassScaling;

/** The scaling a pawn deals e.g. if you would set this to 2.0 then all damage dealt by a pawn would be doubled, or 0.0 for no pawn dealt damage at all. */
var(PawnMutation) float				DamageScale;

/** Whether players are able to dodge off a wall. */
var(PawnMutation) bool				bAllowWallDodge;

/** Whether players are able to jump after doing a dodge. */
var(PawnMutation) bool				bAllowDodgeJump;

/** Whether players are able to crouch. */
var(PawnMutation) bool				bAllowCrouch;

/** Whether players are able to dodge. */
var(PawnMutation) bool				bAllowDodge;

/** Whether players are in berserk mode. */
var(PawnMutation) bool				bBerserk;

/** This is the KeyHUD class that will be used to render the keys on HUD for players. */
var(Extra) const class<LCA_KeyHUD> 	KeyHUDClass;

//==============================================================================
// Objects, Private/Protected Variables.
var noexport protected MessagingSpectator 	WebAdmin;		// Used to message webadmin.
var noexport LCA_GameRules 					TMRules;						// Momentum and other stuff gamerules.
var noexport private bool 					bTimeHasBeenSet;				// To stop the tick from calling ModifyAssault.
var noexport ASGameInfo 					Trial;
var noexport array<LCA_LocalPlayerInfo> 	LPIActors;
var noexport LCA_AttachHandler				AttachsHandler;			// Only available on local client
var noexport private transient int 			G_Index;

event Tick( float dt )
{
	// if true SetTime;
	if( !bTimeHasBeenSet )
	{
		if( Trial != None && !Trial.IsPracticeRound() )
			ModifyGameInfo( Level.Game, Level.GRI );
		else if( Trial == None )
			ModifyGameInfo( Level.Game, Level.GRI );
	}
	else Disable( 'Tick' );
}

// Called by Tick.
final function ModifyGameInfo( GameInfo TheGame, GameReplicationInfo NetGame )
{
	if( Game.bEnabled && TheGame != None && NetGame != None )
	{
		if( Trial != None )
		{
			bTimeHasBeenSet = True;
			if( Game.TimeLimit >= 0 )
			{
				ASGameReplicationInfo(NetGame).RoundTimeLimit = Game.TimeLimit * 60;
				WebMessage( "ASGameInfo.RoundTimeLimit ="@Game.TimeLimit@"Minutes" );
				return;
			}
		}
		else	// Not assault.
		{
			NetGame.TimeLimit = Game.TimeLimit * 60;
			bTimeHasBeenSet = True;
		}
	}

	if( !Game.bEnabled )
		bTimeHasBeenSet = True;
}

//==============================================================================
// Initialize everything..
event PreBeginPlay()
{
	super.PreBeginPlay();

	if( ASGameInfo(Level.Game) != none )
		Trial = ASGameInfo(Level.Game);

	DefWepBackup = StartWeaponList;

	Level.Game.BaseMutator.AddMutator( self );
}

//==============================================================================
// Spawn the friends of lca.
simulated event PostBeginPlay()
{
	if( Level.NetMode != NM_Client )
	{
		Super.PostBeginPlay();

		//======================================================================
		// GameRules.
		TMRules = Spawn( Class'LCA_GameRules', Self );
		TMRules.TrialMode = TrialMode;
		Level.Game.AddGameModifier( TMRules );
	    if( GameSpeed != Default.GameSpeed )
			Level.Game.SetGameSpeed( GameSpeed );

        Log( "==================================================================", 'LevelConfigActor' );
		WebMessage( "LevelConfigActor"@Version@"Loaded" );
		Log( "==================================================================", 'LevelConfigActor' );
		if( TimedMessage.bEnabled )
			SetTimer( 40 + Rand( 60 ), True );

		if( xPawnExtras.bEnabled && xPawnExtras.ServerAttachActors.Length > 0 )
		{
			AttachsHandler = Spawn( Class'LCA_AttachHandler', Self );
		}
	}

	// On client and server!
	if( MapType == MT_BunnyTrack )
	{
		bAllowWallDodge = False;
		bAllowDodgeJump = False;
		MultiJumpLimit = 0;
	}
}

final simulated function Initialize()
{
	local LCA_HudOverlay LCAHUD;
	local LCA_KeyHUD myOverlay;
	local PlayerController LocalPC;

	LocalPC = Level.GetLocalPlayerController();
	if( CameraEffects.Length > 0 )
	{
		AddCameraEffects( LocalPC );
	}

	if( RenderMode != LocalPC.RendMap )
	{
		LocalPC.RendMap = RenderMode;
	}

	if( KeyHUDClass != none )
	{
		myOverlay = Spawn( KeyHUDClass, LocalPC );
		LocalPC.myhud.AddHudOverlay( myOverlay );
	}

	if( xPawnExtras.bEnabled && xPawnExtras.LocalAttachActors.Length > 0 )
	{
		AttachsHandler = Spawn( Class'LCA_AttachHandler', Self );
	}

	if( ScreenOverlay.bEnabled && ScreenOverlay.RenderHandler != none )
	{
		LCAHUD = Spawn( ScreenOverlay.RenderHandler, LocalPC );
		LCAHUD.Tex = ScreenOverlay.Texture;
		LCAHUD.Color = ScreenOverlay.Color;
		LCAHUD.bNotInSpec = ScreenOverlay.bNotInSpec;
		LocalPC.myhud.AddHudOverlay( LCAHUD );
	}
}

final simulated function AddCameraEffects( PlayerController PC )
{
	local int i;

	for( i = 0; i < CameraEffects.Length; i ++ )
	{
		PC.AddCameraEffect( CameraEffects[i] );
	}
}

final simulated function AddLocalAttachActors( Pawn Other )
{
	local int j;
	local int i;
	local Actor SpawnedA;

	if( AttachsHandler == None )
		return;

	for( i = 0; i < xPawnExtras.LocalAttachActors.Length; ++ i )
	{
		if( xPawnExtras.LocalAttachActors[i].ActorClass.Default.bStatic || xPawnExtras.LocalAttachActors[i].ActorClass.Default.bNoDelete )
		{
			Log( string(xPawnExtras.LocalAttachActors[i].ActorClass)@"Cannot be spawned nor attached because it is bStatic or bNoDelete!", Name );
			continue;
		}

		SpawnedA = Spawn( xPawnExtras.LocalAttachActors[i].ActorClass, Other,, Other.Location );
		Other.AttachToBone( SpawnedA, xPawnExtras.LocalAttachActors[i].BoneName );

		j = AttachsHandler.AttachsToWatch.Length;
		AttachsHandler.AttachsToWatch.Length = j + 1;
		AttachsHandler.AttachsToWatch[j] = SpawnedA;
	}
}

final function AddServerAttachActors( Pawn Other )
{
	local int j;
	local int i;
	local Actor SpawnedA;

	if( AttachsHandler == None )
		return;

	for( i = 0; i < xPawnExtras.ServerAttachActors.Length; ++ i )
	{
		if( xPawnExtras.ServerAttachActors[i].ActorClass.Default.bStatic || xPawnExtras.ServerAttachActors[i].ActorClass.Default.bNoDelete )
		{
			Log( string(xPawnExtras.ServerAttachActors[i].ActorClass)@"Cannot be spawned nor attached because it is bStatic or bNoDelete!", Name );
			continue;
		}

		SpawnedA = Spawn( xPawnExtras.ServerAttachActors[i].ActorClass, Other,, Other.Location );
		Other.AttachToBone( SpawnedA, xPawnExtras.ServerAttachActors[i].BoneName );

		j = AttachsHandler.AttachsToWatch.Length;
		AttachsHandler.AttachsToWatch.Length = j + 1;
		AttachsHandler.AttachsToWatch[j] = SpawnedA;
	}
}

/** Returns color A as a color tag. */
static final preoperator string $( Color A )
{
	return (Chr( 0x1B ) $ (Chr( Max( A.R, 1 )  ) $ Chr( Max( A.G, 1 ) ) $ Chr( Max( A.B, 1 ) )));
}

/** Adds B as a color tag to the end of A. */
static final operator(40) string $( coerce string A, Color B )
{
	return A $ $B;
}

/** Adds A as a color tag to the begin of B. */
static final operator(40) string $( Color A, coerce string B )
{
	return $A $ B;
}

event Timer()
{
	GotoState( 'DisplayMessages' );
	SetTimer( 180 + Rand( 300 ), True );
}

state DisplayMessages
{
	event EndState()
	{
		local color CL;
		local int i;

		CL = Class'Canvas'.static.MakeColor( 140, 200, 200 );
		//Level.Game.Broadcast( self, CL $"Notice"$Class'HUD'.default.WhiteColor$": Type 'Mutate LCAInfo' in Console for info about LevelConfigActor!." );
		if( TimedMessage.bDisplayAuthor )
		{
			if( TimedMessage.Credits != "" )
				Level.Game.Broadcast( self, CL $"Map Author"$Class'HUD'.default.WhiteColor$":"@Level.Author@"Credits:"$TimedMessage.Credits );
			else Level.Game.Broadcast( self, CL $"Map Author"$Class'HUD'.default.WhiteColor$":"@Level.Author );
		}
	}

Begin:
	for( G_Index = 0; G_Index < TimedMessage.TimeMessage.Length; ++ G_Index )
	{
		Level.Game.Broadcast( self, TimedMessage.MessageColor $ Repl( TimedMessage.TimeMessage[G_Index], "%DESCRIPTION%", Level.Description ) );
		Sleep( 0.5f );
	}
	GotoState( '' );
}

function ModifyPlayer( Pawn Other )
{
	local int i;
	local xPawn x;

	super.ModifyPlayer( Other );

	x = xPawn(Other);
	if( x != none && x.Controller != none )
	{
		// Send player to a team and keep it.
		if( Level.Game.bTeamGame && ForceTeam != FT_None )
		{
			if( ForceTeam == FT_Red )	// Attackers in assaults case.
			{
				if( !Level.Game.IsOnTeam( x.Controller, Trial.GetAttackingTeam() ) )
				{
					TeamGame(Level.Game).ChangeTeam( x.Controller, Trial.GetAttackingTeam(), True );
					x.Suicide();
					return;
				}
			}
			else if( ForceTeam == FT_Blue )	// Defenders in assaults case.
			{
				if( !Level.Game.IsOnTeam( x.Controller, Trial.GetDefenderNum() ) )
				{
					TeamGame(Level.Game).ChangeTeam( x.Controller, Trial.GetDefenderNum(), True );
					x.Suicide();
					return;
				}
			}
		}

		// Set for the Skins feature, so that dying players their new pawn skin will be changed by other clients
		// ClientModifyPlayer is called aswell
		for( i = 0; i < LPIActors.Length; ++ i )
		{
			if( LPIActors[i] == none )
			{
				LPIActors.Remove( i, 1 );
				-- i;
				continue;
			}

			if( LPIActors[i].Owner == none )
				continue;

			if( X.Controller == LPIActors[i].Owner )
			{
				LPIActors[i].myPawn = X;
				if( Level.NetMode == NM_StandAlone )
				{
					LPIActors[i].NotifyRespawned();
				}
				break;
			}
		}

		MutatePawn( x );

		if( DefaultCombo != none )
			SetDefaultCombo( x );

		if( bNoPawnCollision )
			x.SetCollision( True, False, False );

		if( xPawnExtras.bEnabled )
		{
			if( xPawnExtras.PlayerSize != default.xPawnExtras.PlayerSize )
			{
				x.SetDrawScale( x.default.DrawScale * xPawnExtras.PlayerSize );
				x.SetCollisionSize( x.default.CollisionRadius * xPawnExtras.PlayerSize, x.default.CollisionHeight * xPawnExtras.PlayerSize );
				x.BaseEyeHeight *= xPawnExtras.PlayerSize;
				x.EyeHeight *= xPawnExtras.PlayerSize;
				x.CrouchHeight *= xPawnExtras.PlayerSize;
				x.CrouchRadius *= xPawnExtras.PlayerSize;
				x.DrivingHeight *= xPawnExtras.PlayerSize;
				x.DrivingRadius *= xPawnExtras.PlayerSize;
			}

			if( xPawnExtras.HeadSize != default.xPawnExtras.HeadSize )
			{
				x.SetHeadScale( xPawnExtras.HeadSize );
				x.HeadRadius *= xPawnExtras.HeadSize;
				x.HeadHeight *= xPawnExtras.HeadSize;
			}

			AddServerAttachActors( x );

			ApplySkin( x );
           	ApplyAdditionalProperties( x );
		}

		if( bHaveAirShieldGun )
			x.GiveWeapon( string( Class'LCA_AirShieldGun' ) );
	}
}

/** Called by owning Client for personal pawn(Other) */
simulated function ClientModifyPlayer( Pawn Other )
{
	xPawn(Other).MaxMultiJump = MultiJumpLimit;
	xPawn(Other).MultiJumpRemaining = MultiJumpLimit;

	xPawn(Other).ShieldStrengthMax = MaxSuperShield;

	Other.bCanWallDodge = bAllowWallDodge;
	Other.bCanCrouch = bAllowCrouch;
}

/** Called by every Client for specified pawn(Other) */
simulated function SimulateModifyPlayer( Pawn Other )
{
	if( xPawnExtras.bEnabled )
	{
		AddLocalAttachActors( Other );

		ApplySkin( Other );

		ApplyAdditionalProperties( Other );
	}
}

simulated function MutatePawn( xPawn Other )
{
	Other.MaxMultiJump 						= MultiJumpLimit;
	Other.MultiJumpRemaining 				= MultiJumpLimit;
	Other.MultiJumpBoost 					= MultiJumpHeight;
	Other.Jumpz 							= JumpHeight;
	Other.DodgeSpeedFactor 					= DodgeSpeedLength;
	Other.DodgeSpeedZ 						= DodgeSpeedHeight;
	Other.Health 							= DefaultHealth;
	Other.HealthMax 						= MaxHealth;
	Other.SuperHealthMax 					= MaxSuperHealth;
	Other.ShieldStrengthMax 				= MaxSuperShield;
	Other.UnderWaterTime 					= UnderWaterTime;
	Other.AirControl 						= AirControl;
	Other.MaxFallSpeed 						= MaxFallSpeed;
	Other.DamageScaling 					= DamageScale;
	Other.bCanWallDodge 					= bAllowWallDodge;
	Other.bCanDodgeDoubleJump 				= bAllowDodgeJump;
	Other.bCanCrouch 						= bAllowCrouch;
	Other.bBerserk 							= bBerserk;
	Other.Mass 								*= MassScaling;

	Other.AddShieldStrength( DefaultShield );
	SetSpeedScale( Other );
}

final simulated function ApplySkin( Pawn Other )
{
	local int i, j;

	if( xPawnExtras.Skin.bEnabled )
	{
		j = xPawnExtras.Skin.Skins.Length;
		for( i = 0; i < j; ++ i )
			Other.Skins[i] = xPawnExtras.Skin.Skins[i];

		if( xPawnExtras.Skin.Model != None )
		{
			Other.LinkMesh( xPawnExtras.Skin.Model );
			if( xPawn(Other) != none )
				xPawn(Other).AssignInitialPose();
		}
	}
}

final simulated function ApplyAdditionalProperties( Pawn Other )
{
	local int i, j, iLength;

	j = xPawnExtras.ExtraVariables.Length;
	for( i = 0; i < j; ++ i )
	{
		Other.SetPropertyText( xPawnExtras.ExtraVariables[i].PropertyName, xPawnExtras.ExtraVariables[i].PropertyValue );
	}
}

final simulated function SetSpeedScale( xPawn x, optional float ThisScale )
{
	local float tempScale;

	if( ThisScale != 0.f )
		tempScale = ThisScale;
	else tempScale = MoveSpeedScaling;

	x.GroundSpeed = 440 * tempScale;
	x.CrouchedPct = 0.4 * tempScale;
	x.WalkingPct = 0.4 * tempScale;
	x.WaterSpeed = 220 * tempScale;
	x.AirSpeed = 440 * tempScale;
	x.LadderSpeed = 220 * tempScale;
}

// Returns False if failed to create combo.
final function bool SetDefaultCombo( xPawn X )
{
	if( X.Controller.bAdrenalineEnabled )
	{
		X.Controller.Adrenaline = X.Controller.AdrenalineMax;
		X.DoCombo( DefaultCombo );
		if( x.CurrentCombo == None )
			return False;
		x.CurrentCombo.AdrenalineCost = 0;
		x.CurrentCombo.Duration = 0;
		if( DefaultCombo == Class'xGame.ComboSpeed' )
		{
			ComboSpeed(x.CurrentCombo).LeftTrail.LifeSpan = 0;
			ComboSpeed(x.CurrentCombo).RightTrail.LifeSpan = 0;
		}
		else if( DefaultCombo == Class'xGame.ComboBerserk' )
			ComboBerserk(x.CurrentCombo).Effect.LifeSpan = 0;
		else if( DefaultCombo == Class'xGame.ComboDefensive' )
			ComboDefensive(x.CurrentCombo).Effect.LifeSpan = 0;
		X.Controller.Adrenaline = X.Controller.Default.Adrenaline;
		return True;
	}
	return False;
}

function bool CheckReplacement( Actor Other, out byte b )
{
	local int i, j;
	local Projectile Proj;

	// Set all weapons ammo...
	if( Weapon(Other) != None && Weapons.bEnabled )
	{
		for( i = 0; i < arraycount(class'Weapon'.default.FireModeClass); ++ i )
		{
			if( Weapons.Amount > 0 )
				Weapon(Other).ClientForceAmmoUpdate( i, Weapons.Amount );
			else Weapon(Other).SuperMaxOutAmmo();
		}
	}
	else if( Pickup(Other) != none && (bFastRespawnPickups && WeaponPickup(Other) == none && Pickup(Other).RespawnTime != 0.5) )
 	{
		Pickup(Other).RespawnTime = 0.5;
	}
	else if( xPickUpBase(Other) != none && (bFastRespawnPickups) )
	{
		xPickUpBase(Other).bDelayedSpawn = False;
	}
	else if( LCA_AirShieldGun(Other) != None )
	{
		if( bNoDynamicLight )
		{
			Other.bDynamicLight = False;
			Other.LightType = LT_None;
		}
		LCA_AirShieldGun(Other).bCanThrow = bCanDropWeapon;
		LCA_AirShieldGun(Other).HealthBoost = HealthBoost;
	}
	else if( LCA_PShieldAttachment(Other) != None )
	{
		if( bNoPinkRings )
			LCA_PShieldAttachment(Other).bPinkRings = False;

		if( bNoDynamicLight )
		{
			Other.bDynamicLight = False;
			Other.LightType = LT_None;
		}
	}
	else if( xPawn(Other) != None )
	{
		// Set default start weapons for players...
		if( StartWeaponList.bEnabled )
		{
			xPawn(Other).bNoDefaultInventory = False;
			j = StartWeaponList.DefaultStartWeapons.Length;
			if( j == 0 )
			{
				xPawn(Other).RequiredEquipment[0] = "";
				xPawn(Other).RequiredEquipment[1] = "";
			}
			else
			{
				if( j == 1 )
					xPawn(Other).RequiredEquipment[1] = "";

				for( i = 0; i < j; ++ i )
				{
					if( StartWeaponList.DefaultStartWeapons[i].DefaultStartWeapon == None )
						xPawn(Other).RequiredEquipment[i] = "";
					else xPawn(Other).RequiredEquipment[i] = string( StartWeaponList.DefaultStartWeapons[i].DefaultStartWeapon );
				}
			}
		}
	}
	else if( Projectile(Other) != none && Projectiles.Length > 0 )
	{
		Proj = Projectile(Other);
		for( i = 0; i < Projectiles.Length; ++ i )
		{
			if( Projectiles[i].ProjectileClass != none && ClassIsChildOf( Proj.Class, Projectiles[i].ProjectileClass ) )
			{
				for( j = 0; j < Projectiles[i].Properties.Length; ++ j )
				{
					Proj.SetPropertyText( Projectiles[i].Properties[j].PropertyName, Projectiles[i].Properties[j].PropertyValue );
				}
				break;
			}
		}
	}
	else if( MessagingSpectator(Other) != none )
	{
		WebAdmin = MessagingSpectator(Other);
	}
	else if( PlayerController(Other) != none )
	{
		j = LPIActors.Length;
		LPIActors.Length = j+1;
		LPIActors[j] = Spawn( Class'LCA_LocalPlayerInfo', Other );
		LPIActors[j].LCA = self;
	}
	else if( Other.IsA('DodgeHandler') )
	{
		if( xPawnExtras.bMakeSureNoDodgeDoubleJump )
		{
			Other.SetPropertyText( "bAlwaysAllowDodgeDoubleJump", "0" );
			Other.SetPropertyText( "bFastDodging", "1" );
			Other.SetPropertyText( "bGatherJumpStats", "0" );
		}
	}
	return true;
}

function Mutate( string TypedString, PlayerController PC )
{
	local int i;
	local Color CL;

	if( PC != none )
	{
		if( TypedString ~= "LCAInfo" )
		{
			PC.ClientMessage( "=============================LevelConfigManager=============================" );
			PC.ClientMessage( "LevelConfigManager is a mutator that provides triggers, volumes and many other things for L.D.s(Level Designers)." );
			PC.ClientMessage( "Here are some of the many things of what LCA(LevelConfigActor) can do." );
			PC.ClientMessage( "ForceView - Force players to play in third person or first person." );
			PC.ClientMessage( "ForceTeam - Force players to the selected team." );
			PC.ClientMessage( "TrialMode - Increment/Decrement the weapons boost scaling i.e. TM_DM makes assault use the scaling of DeathMatch." );
			PC.ClientMessage( "PlayerSize - Play like a rat or a giant player!." );
			PC.ClientMessage( "And of course you can customize alot more things, such as the Health value players spawn with, max Health and moving speed etc" );
			PC.ClientMessage( "" );
			PC.ClientMessage( "Author:"@Author );
			PC.ClientMessage( "Download:"@Download );
			PC.ClientMessage( "Version:"@Version );
			PC.ClientMessage( "============================================================================" );
			return;
		}
		else if( TypedString ~= "LCADownload" )
		{
			PC.ClientMessage( "Opening" @ Download );
			PC.ClientTravel( Download, TRAVEL_Absolute, false );
			return;
		}
		else if( TypedString ~= "LCAShowMessage" )
		{
			for( i = 0; i < TimedMessage.TimeMessage.Length; ++ i )
			{
				PC.ClientMessage( TimedMessage.MessageColor $ Repl( TimedMessage.TimeMessage[i], "%DESCRIPTION%", Level.Description ) );
			}
			Mutate( "LCAShowAuthor", PC );
			return;
		}
		else if( TypedString ~= "LCAShowAuthor" || TypedString ~= "LCAShowCredits" )
		{
			CL = Class'Canvas'.static.MakeColor( 140, 200, 200 );
			if( TimedMessage.Credits != "" )
				PC.ClientMessage( CL $"Map Author"$Class'HUD'.default.WhiteColor$":"@Level.Author@"Credits:"$TimedMessage.Credits );
			else PC.ClientMessage( CL $"Map Author"$Class'HUD'.default.WhiteColor$":"@Level.Author );
			return;
		}
	}
	super.Mutate(TypedString,PC);
}

function Reset()
{
	super.Reset();
	Level.Game.SetGameSpeed( GameSpeed );
	bTimeHasBeenSet = false;
	Enable( 'Tick' );

	StartWeaponList = DefWepBackup;
}

event Destroyed()
{
	if( TMRules != none )
		TMRules.Destroy();
	super.Destroyed();
}

//==============================================================================
// Sends a message to spectator WebAdmin.
final function WebMessage( coerce string S )
{
	if( WebAdmin != none )
		WebAdmin.ClientMessage( S );
	Log( S, 'LevelConfigActor' );
}

simulated function string GetHumanReadableName()
{
	return "LevelConfigManager"@Version;
}

defaultproperties
{
	//==========================================================================
	// String List
	Author="Eliot"
	Download="http://wiki.beyondunreal.com/User:Eliot/LevelConfigManager"
	Version="3.0"
	ActorExplain(0)="PlayerSize - Size for the players to be spawned with."
	ActorExplain(1)="DefaultCombo - Give each spawning player this selected Combo!."
	ActorExplain(2)="TimeMessage - Display this meessage to everyone every 3-5 Minutes, use for information about ur map."
	ActorExplain(3)="bDisplayAuthor - Show(Like TimeMessage) the LevelProperties->LevelSummary->Author on screen every 3-5 Minutes."
	ActorExplain(4)="ForceView - Force every player to this selected View."
	ActorExplain(5)="ForceTeam - Force spawned player to this selected Team."
	ActorExplain(6)="TrialMode - Momentum power when damaging yourself."
	ActorExplain(7)="DefaultHealth - Amount of Health player spawns with."
	ActorExplain(8)="DefaultShield - Amount of Shield player spawns with."
	ActorExplain(9)="MultiJumpHeight - The height boost for every multi jump."
	ActorExplain(10)="MultiJumpLimit - Amount of multi jumps players can do."
	ActorExplain(11)="JumpHeight - The first jump height boost."
	ActorExplain(12)="AirControl - The AirControl limit when moving in air."

	//==========================================================================
	// Int List
	MultiJumpLimit=1
	MultiJumpHeight=25
	DefaultHealth=100
	DefaultShield=0
	MaxHealth=100
	MaxSuperHealth=199
	MaxSuperShield=150
	JumpHeight=340
	HealthBoost=10
	MaxFallSpeed=1200
	RenderMode=5

	//==========================================================================
	// Float List
	DodgeSpeedLength=1.500000
	DodgeSpeedHeight=210.000000
	AirControl=0.350000
	UnderWaterTime=20.000000
	DamageScale=1.000000
	GameSpeed=1.0
	MoveSpeedScaling=1.000000
	MassScaling=1.000000

	//==========================================================================
	// Bool List
	bAllowWallDodge=True
	bAllowDodgeJump=True
	bAllowCrouch=True
	bAllowDodge=True
	bNoPawnCollision=True
	bCanDropWeapon=True
	bNoPinkRings=False
	bNoDynamicLight=False
	bHaveAirShieldGun=False
	bFastRespawnPickups=True
	bBerserk=False

	//==========================================================================
	// Class List
	DefaultCombo=None
	KeyHUDClass=Class'LCA_KeyHUD'

	//==========================================================================
	// Struct List
	Weapons=(bEnabled=False,Amount=50)
	Game=(bEnabled=False,TimeLimit=45)
	xPawnExtras=(bEnabled=False,HeadSize=1.0,PlayerSize=1.0,DodgeLimit=1)
	StartWeaponList=(bEnabled=False,DefaultStartWeapons=((DefaultStartWeapon=Class'xWeapons.AssaultRifle'),(DefaultStartWeapon=Class'xWeapons.ShieldGun')))
	TimedMessage=(bEnabled=True,bDisplayAuthor=True,MessageColor=(R=255,G=255,B=255,A=255))
	ScreenOverlay=(bEnabled=False,Color=(R=255,G=255,B=255,A=255),RenderHandler=Class'LCA_HudOverlay')

	//==========================================================================
	// Enum List
	ForceView=FV_None
	ForceTeam=FT_None
	TrialMode=TM_Normal
	MapType=MT_Default

	//==========================================================================
	// Properties from extends
	Description="An UnrealEd Mutator allowing you to modify the game to your choice."

	Texture=S_La

	bEdShouldSnap=True

	DrawScale=1.5

	RemoteRole=ROLE_None
	bNoDelete=True
}
// End of Script.
//==============================================================================
