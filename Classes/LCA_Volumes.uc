//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_Volumes extends PhysicsVolume
	hidecategories(Karma,Force,Sound,Lighting,LightColor)
	abstract
	hidedropdown
	cacheexempt
	notplaceable;

/** Whether this volume is enabled. This can be toggled by triggering the volume(if the volume has its own trigger functionality then try trigger this one with the '''[[User:Eliot/LevelConfigManager/Triggers/#NoInstigatorTrigger|NoInstigatorTrigger]]). */
var() bool bEnabled;
var editconst bool bEnabled_bak;

/** The volume will function only once. */
var() bool bTriggerOnceOnly;

var LevelConfigActor Master;

/** The behavior of this volume described and viewable from [[UnrealEd]]. */
var() editconst const string Info;

replication
{
	reliable if( bNetDirty && (Role == Role_Authority) )
		bEnabled;
}

simulated function bool IsPawnRelevant( Pawn Other )
{
	if( Other == None || Other.Controller == none )
		return false;

	return (!Other.IsA('Monster') && bEnabled);
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	bEnabled_bak = bEnabled;
}

function Trigger( Actor Other, Pawn Player )
{
	bEnabled = !bEnabled;
}

function Reset()
{
	super.Reset();
	bEnabled = bEnabled_bak;
}

defaultproperties
{
	bEnabled=true
	bEnabled_bak=true
}
