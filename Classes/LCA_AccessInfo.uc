//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_AccessInfo Extends Info;

var LCA_AccessTrigger Master;
var LCA_CodeMenu MyWnd;

Replication
{
	reliable if( bNetOwner && (Role < ROLE_Authority) )
		SendCode, ServerDestroy;
}

Simulated event PostNetBeginPlay()
{
	if( Level.NetMode == NM_DedicatedServer )
		return;

	ForEach AllObjects( Class'LCA_CodeMenu', MyWnd )
		MyWnd.AcInfo = Self;
}

event Tick( float dt )
{
	if( Owner == None )
		Destroy();
}

Function ServerDestroy()
{
	Destroy();
}

Function SendCode( int S, Pawn Other )
{
	if( Master != None )
		Master.CheckCode( S, Other );
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bOnlyRelevantToOwner=True
	bAlwaysRelevant=True
	bNetTemporary=False
}
