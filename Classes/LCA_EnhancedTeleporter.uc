/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Touch, Trigger

;On Activation : The instigator will be teleported to the active URL, the URL works like a sequence that may be progressed by triggering this teleporter. This actor can teleport vehicles.
==============================================================================*/
class LCA_EnhancedTeleporter extends Teleporter;

#exec Texture Import File=Textures\Teleport.pcx Name=S_Teleport Mips=Off MASKED=1

var() array<string> Order;
var() class<Emitter> TeleportEffect;
var byte CurrentURL;
var() class<Pawn> AllowedClass;
var bool bEnabled_bak;
var() enum ETeleportType
{
	TP_ToggleEnabled,
	TP_OrderTeleport,
} TeleportType;

event PostBeginPlay()
{
	bEnabled_bak = bEnabled;
	if( TeleportType == TP_OrderTeleport )
		URL = Order[CurrentURL];
	Super.PostBeginPlay();
}

function bool IsAllowed( Actor Other )
{
	return ClassIsChildOf( Other.Class, AllowedClass );
}

event Touch( Actor Other )
{
	if( Other != None && (IsAllowed( Other ) && bEnabled) )
	{
		if( Other.IsA('Vehicle') )
			Other.bCanTeleport = True;

		if( TeleportEffect != None )
			Spawn( TeleportEffect, Self, , Location, Rotation );
		Super.Touch(Other);
	}
}

simulated function bool Accept( Actor Incoming, Actor Source )
{
	super.Accept(Incoming,Source);
	if( Incoming.IsA('Vehicle') )
	{
		// Hack: for karma Vehicles.
		Incoming.SetPhysics( PHYS_None );
		Incoming.Velocity = vect(0,0,0);
		Incoming.SetRotation( Rotation );
		Incoming.bCanTeleport = False;
		Incoming.SetPhysics( PHYS_Karma );
		if( KarmaParamsRBFull(Incoming.KParams) != None )
          Incoming.KSetStayUpright( KarmaParamsRBFull(Incoming.KParams).Default.bKStayUpright, KarmaParamsRBFull(Incoming.KParams).default.bKAllowRotate );
	}
	else if( Incoming.IsA('Pawn') )
		Incoming.SetRotation( Rotation );
	return IsAllowed( Incoming );
}

function Trigger( Actor Other, Pawn EventInstigator )
{
	if( TeleportType == TP_ToggleEnabled )
		Super.Trigger(Other,EventInstigator);
	else if( TeleportType == TP_OrderTeleport )
	{
		if( CurrentURL < Order.Length )
			CurrentURL ++;
		else CurrentURL = 0;
		URL = Order[CurrentURL];
	}
}

function Reset()
{
	super.Reset();
	bEnabled = bEnabled_bak;
	CurrentURL = 0;
	URL = Order[0];
}

// Removed anti-vehicle teleport for bots.
event int SpecialCost( Pawn Other, ReachSpec Path )
{
	if( (Teleporter(Path.Start) == None) || ((Path.reachFlags & 32) == 0) )
		return 0;
	if( !IsAllowed( Other ) )
		return 10000000;
	return 0;
}

defaultproperties
{
	AllowedClass=class'Pawn'
	TeleportType=TP_OrderTeleport
	CurrentURL=0
	Texture=S_Teleport
}
