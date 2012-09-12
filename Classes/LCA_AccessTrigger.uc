/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : ???
 * ;Last Updated : 20/08/2006
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Use

;On Activation : A menu will popup for the instigator, where the instigator may try enter a code and then press the Enter button, if the code is correct then the ''CorrectSnd'' will be played and the ''Event'' will be triggered, if the code is incorrect the ''IncorrectSnd'' will be played.
==============================================================================*/
Class LCA_AccessTrigger Extends LCA_Triggers
	HideCategories(None);

var noexport int Code;
var() bool bActivateOnceOnly;
var() sound CorrectSnd, IncorrectSnd;
var() string Description;

Function UsedBy( Pawn Other )
{
	local LCA_AccessInfo AcInfo;

	if( IsEnabled() )
	{
		if( PlayerController(Other.Controller) != None )
		{
			PlayerController(Other.Controller).ClientOpenMenu( string( Class'LCA_CodeMenu' ) );
			AcInfo = Spawn( Class'LCA_AccessInfo', Other );
			AcInfo.Master = Self;
		}
		else CheckCode( Code, Other );		// Bot.
	}
}

Function Touch( Actor Other )
{
	if( IsEnabled() && Pawn(Other) != None )
	{
		if( Len( Message ) > 0 )
			Pawn(Other).ClientMessage( MakeColor( MessageColor )$Message );

		// Bot.
		if( AIController(Pawn(Other).Controller) != None )
			UsedBy( Pawn(Other) );
	}
}

Simulated Function bool ServerCheckCode( string S, Pawn Other )
{
	if( !IsEnabled() )
		return False;
	if( S == string( Code ) )
		return True;
	return False;
}

Function CheckCode( int S, Pawn Other )
{
	if( S == Code )
	{
		if( bActivateOnceOnly )
			SetEnabled( false );

		TriggerEvent( Event, Self, Other );
	}
}

DefaultProperties
{
	Message="Use to open access window"
	correctSnd=Sound'GeneralAmbience.Beep10'
	IncorrectSnd=Sound'GeneralAmbience.Beep2'
	Info="Triggered when code is cracked."
	bCollideActors=true
	bNoDelete=true
	bStatic=true
}
