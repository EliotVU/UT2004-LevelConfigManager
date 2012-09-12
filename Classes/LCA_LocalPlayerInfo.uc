//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_LocalPlayerInfo extends Info
	notplaceable;

var int MaxMultiDodges, RemainingMultiDodges;

var LevelConfigActor LCA;
var Pawn myPawn, OldPawn;
var PlayerInput PlayerInput;
var bool bInitialized;

replication
{
	reliable if( bNetDirty && (Role == ROLE_Authority) && bNetOwner )
		RemainingMultiDodges, MaxMultiDodges;

	reliable if( bNetDirty && (Role == ROLE_Authority) )
		myPawn;

		// Idiot me, bnetowner no wonder skins don't work.
	reliable if( bNetInitial && (Role == ROLE_Authority) )
		LCA;
}

simulated event PreBeginPlay()
{
	local PlayerController LocalPC;

	super.PreBeginPlay();
	if( Level.NetMode != NM_DedicatedServer )
	{
		LocalPC = Level.GetLocalPlayerController();
		foreach AllObjects( Class'PlayerInput', PlayerInput )
		{
			if( PlayerInput.Outer == LocalPC )
				break;
		}
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	if( PlayerInput != none && LCA.xPawnExtras.bEnabled )
	{
		if( LCA.xPawnExtras.DodgeLimit != 1 )
			MaxMultiDodges = LCA.xPawnExtras.DodgeLimit;
	}
}

simulated event PostNetReceive()
{
	super.PostNetReceive();
	if( xPawn(myPawn) != none && myPawn != OldPawn )
	{
		ClientModifyPlayer();
		NotifyRespawned();

		OldPawn = myPawn;
	}
}

simulated function NotifyRespawned()
{
	LCA.SimulateModifyPlayer( myPawn );
}

// Only if Online-Game
// Change those values on clientside.
simulated function ClientModifyPlayer()
{
	local xPawn Pawn;

	if( Owner == None )
		return;

	Pawn = xPawn(PlayerController(Owner).Pawn);
	if( Pawn != None )
	{
		LCA.ClientModifyPlayer( Pawn );
	}
}

simulated event Tick( float f )
{
	// Server only!
	if( Level.NetMode != NM_Client )
		ServerTick( f );

	// Client only!
	if( Level.NetMode != NM_DedicatedServer )
	{
		if( !bInitialized )
		{
			LCA.Initialize();
			bInitialized = True;
		}
	}

	ClientTick( f );	// Both.
}

function ServerTick( float f )
{
	if( PlayerController(Owner) == None )
	{
		Destroy();
		return;
	}
}

// Client and server.
simulated function ClientTick( float f )
{
	local xPawn Pawn;
	local PlayerController PC;

	PC = PlayerController(Owner);
	if( PC == None || LCA == None )
		return;

	Pawn = xPawn(PC.Pawn);
	if( Pawn != None )
	{
		// Change viewmode server and client.
		if( LCA.ForceView != FV_None )
		{
			if( LCA.ForceView == FV_OnlyThirdPerson && !PC.bBehindView )
				PC.bBehindView = True;
			else if( LCA.ForceView == FV_OnlyFirstPerson && PC.bBehindView )
				PC.bBehindView = False;
		}

		if( !LCA.bAllowDodge )
		{
			if( !Pawn.bCanWallDodge )
			{
				PC.DoubleClickDir = DClick_Active;
			}
			else if( Pawn.Physics == PHYS_Walking )
			{
				PC.DoubleClickDir = DClick_Done;
			}
			else if( Pawn.Physics == PHYS_Falling )
			{
				if( PlayerInput != None )
				{
					PC.ClearDoubleClick();
					PlayerInput.DoubleClickTimer = PlayerInput.DoubleClickTime;
				}
			}
		}

		if( LCA.xPawnExtras.bEnabled )
		{
			if( LCA.xPawnExtras.DodgeLimit != 1 )
			{
				if( (MaxMultiDodges != -1) && Pawn.Physics == PHYS_Walking && RemainingMultiDodges != MaxMultiDodges )
					RemainingMultiDodges = MaxMultiDodges - 1;

				if( (!Pawn.bIsCrouched && !Pawn.bWantsToCrouch) && Pawn.Physics != PHYS_Walking )
				{
			   		if( PC.DoubleClickDir >= DClick_Active && (RemainingMultiDodges > 0 || MaxMultiDodges == -1) )
					{
						-- RemainingMultiDodges;
						Pawn.MultiJumpRemaining = Pawn.MaxMultiJump;
						PC.ClearDoubleClick();
						PC.DoubleClickDir = DClick_None;
					}
				}
			}

			if( LCA.xPawnExtras.bNoDodgeDelay )
			{
				if( PC.DoubleClickDir >= DClick_Active )
				{
					//PC.ClearDoubleClick();
					if( Pawn.Physics == PHYS_Walking )
						PC.DoubleClickDir = DClick_None;

					if( PlayerInput != None )
						PlayerInput.DoubleClickTimer = PlayerInput.DoubleClickTime;
				}
			}
		}
	}
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=True
	bSkipActorPropertyReplication=False
	bAlwaysTick=True
	bNetNotify=True
}
