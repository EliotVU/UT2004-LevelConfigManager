/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type: Touch

;On Activation : Sends a {{classgames|LocalMessage}} to the instigator with the specified ''Message'' and other details.
==============================================================================*/
class LCA_LocalMessageTrigger extends LCA_Triggers
	placeable;

var(Message) bool bBeep, bFade, bShowInConsole;
var(Message) int LifeTime;
struct sPosition
{
	var() float X, Y;
};
var(Message) sPosition Position;

function Touch( Actor Other )
{
	Super.Touch(Other);
	if( Pawn(Other) != None && IsEnabled() )
		SendLocalMessage( Pawn(Other) );
}

function SendLocalMessage( Pawn Other )
{
	local PlayerController PC;

	PC = PlayerController(Other.Controller);
	if( PC != None )
		PC.ReceiveLocalizedMessage( Class'LCA_LocalMessage',,,, Self );
}

DefaultProperties
{
	Position=(X=0.5,Y=0.83)
	bBeep=True
	bFade=True
	LifeTime=3

    bCollideActors=true
	bStatic=true
	bNoDelete=true
}
