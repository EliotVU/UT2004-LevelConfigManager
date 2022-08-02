/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : The game speed will be set to the specified value.
==============================================================================*/
Class LCA_GameSpeedModifier Extends LCA_Triggers
	HideCategories(Message,LCA_Triggers)
	Placeable;

var() const float GameSpeed;
var() bool bShowMessage;

Function Trigger( Actor Other, Pawn Player )
{
	Level.Game.SetGameSpeed( GameSpeed );
	if( bShowMessage )
		Level.Game.Broadcast( Self, "GameSpeed is now"@GameSpeed );
}

DefaultProperties
{
	GameSpeed=1.0
	Info="The GameSpeed will be changed to the specified 'GameSpeed' when this actor gets triggerd."
	bShowMessage=True
}
