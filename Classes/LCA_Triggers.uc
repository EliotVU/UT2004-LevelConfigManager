//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
// Coded by Eliot aka ->UT2x<-Eliot @2007-2008.
class LCA_Triggers extends Triggers
	hidecategories(Lighting,Lightcolor,Karma,Force,Sound)
	abstract;

#exec Texture Import File=Textures\Trigger.pcx Name=S_Trigger Mips=Off MASKED=1

var() protected bool bEnabled;
var protected editconst bool bEnabled_Bak;

var() localized editconst noexport const string Info;
var(Message) const color MessageColor;
var(Message) const localized string Message;

Final Function LevelConfigActor GetLCA()
{
	local LevelConfigActor LCA;

	ForEach AllActors( Class'LevelConfigActor', LCA )
		return LCA;
	return None;
}

Final Function string MakeColor( color CL )
{
	return Level.Game.MakeColorCode( Class'Canvas'.Static.MakeColor( CL.r, CL.g, CL.b, CL.a ) );
}

event PostBeginplay()
{
	Super.PostBeginPlay();
	bEnabled_Bak = IsEnabled();
}

simulated function bool IsPawnRelevant( Pawn Other )
{
	return (!Other.IsA('Monster') && Other != None);
}

/*Function Touch( Actor Other )
{
	if( Pawn(Other) != None && IsEnabled() )
		TriggerEvent( Event, Self, Pawn(Other) );
}*/

function Trigger( Actor Other, Pawn Player )
{
	ToggleEnabled();
}

simulated function bool IsEnabled()
{
	return bEnabled;
}

simulated function SetEnabled( bool condition )
{
	bEnabled = condition;
}

simulated function ToggleEnabled()
{
	SetEnabled( !IsEnabled() );
}

Function Reset()
{
	Super.Reset();
	SetEnabled( bEnabled_Bak );
}

Function bool CheckForErrors()
{
	if( MessageColor.A == 0 )
	{
		Log( Self$"MessageColor.A ="@MessageColor.A@"Text will be invisible..." );
		return True;
	}
	return Super.CheckForErrors();
}

DefaultProperties
{
	bEnabled=True
	bEnabled_Bak=True
	bHidden=True
	Texture=S_Trigger
	Info="No Info."
	CollisionRadius=64.0
	CollisionHeight=64.0
	MessageColor=(r=255,g=255,b=255,a=255)

	bCollideActors=false
}
