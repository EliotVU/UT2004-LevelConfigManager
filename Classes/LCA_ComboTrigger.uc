/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Use, Touch

;On Activation : Gives a specific combo to the instigator.
==============================================================================*/
Class LCA_ComboTrigger Extends LCA_Triggers
	Placeable;

var() class<Combo> ComboClass;
var() const int ComboTime;
var() enum EActivateType
{
	AT_Use,
	AT_Touch,
} ActivateType;

Function Touch( Actor Other )
{
	if( !IsEnabled() || !IsPawnRelevant( Pawn(Other) ) )return;
	if( Accept( Pawn(Other) ) && ActivateType == AT_Touch )
		SetCombo( xPawn(Other) );
}

Function Usedby( Pawn Other )
{
	if( !IsEnabled() )return;
	if( Accept( Other ) && ActivateType == AT_Use )
		SetCombo( Other );
}

Function bool Accept( Pawn P )
{
	return (xPawn(P).CurrentCombo == None && xPawn(P) != None);
}

Function SetCombo( Pawn Other )
{
	local int temp;

	if( Other.Controller == None )return;
	temp = Other.Controller.Adrenaline;
	Other.Controller.Adrenaline = Other.Controller.AdrenalineMax;
	xPawn(Other).CurrentCombo.AdrenalineCost = 0;
	xPawn(Other).CurrentCombo.Duration = ComboTime;
	xPawn(Other).DoCombo( ComboClass );
	Other.Controller.Adrenaline = temp;
	if( Message == Default.Message )
		Other.ClientMessage( MakeColor( MessageColor )$"You Gained Combo"@ComboClass );
	else Other.ClientMessage( MakeColor( MessageColor )$Message );
}

DefaultProperties
{
	ComboTime=30
	ComboClass=Class'xGame.ComboSpeed'
	Message="You Gained Combo"
	bCollideActors=true
}
