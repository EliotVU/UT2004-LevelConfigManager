/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

This trigger can be used in Constructor maps so that players can move around the map quickly if they want to.

;Activation Type : Use

;On Activation : Increases the speed of the instigator.
==============================================================================*/
Class LCA_SpeedMultiplicaterTrigger Extends LCA_Triggers
	Placeable;

var(Message) localized string UsedMessage;
var() bool bNoFallDamage;
var() bool bIgnoreSecondPress;
var() float MultiplicationSpeed;

Function Usedby( Pawn Other )
{
	if( IsEnabled() )
	{
		Super.Usedby(Other);
		if( Other != None )
		{
			if( bIgnoreSecondPress && CheckMemory( Other ) )return;
			Other.GroundSpeed 	*= MultiplicationSpeed;
			Other.WaterSpeed	*= MultiplicationSpeed;
			Other.AirSpeed 		*= MultiplicationSpeed;
			Other.LadderSpeed 	*= MultiplicationSpeed;
			if( xPawn(Other) != None )
			{
				xPawn(Other).CrouchedPct *= MultiplicationSpeed;
				xPawn(Other).WalkingPct  *= MultiplicationSpeed;
			}
			if( UsedMessage != "" )
				Other.ClientMessage( MakeColor( MessageColor )$UsedMessage@MultiplicationSpeed@"and NoFallDamage:"@bNoFallDamage );
			if( bNoFallDamage )
				Other.MaxFallSpeed = maxint;

			if( bIgnoreSecondPress )
				SetMemory( Other );
		}
	}
}

Function bool CheckMemory( Pawn Other )
{
	local int i;

	for( i = 0; i < 8; i ++ )
		if( Other.ExcludeTag[i] == 'Used_LCA_Speed' )
			return True;
	return False;
}

Function SetMemory( Pawn Other )
{
	local int i;

	for( i = 0; i < 8; i ++ )
		if( Other.ExcludeTag[i] == '' )
		{
			Other.ExcludeTag[i] = 'Used_LCA_Speed';
			Break;
		}
}

Function Touch( Actor Other )
{
	if( IsEnabled() && Pawn(Other) != None )
	{
		Super.Touch(Other);
		if( Message != "" && !CheckMemory( Pawn(Other) ) )
			Pawn(Other).ClientMessage( MakeColor( MessageColor )$Message );

		// Force bot to use...
		if( AIController(Pawn(Other).Controller) != None )
			UsedBy( Pawn(Other) );
	}
}

DefaultProperties
{
	Info="MultiplicationSpeed Increases all type of speed."
	UsedMessage="Your Speed Has Been Increased by"
	bNoFallDamage=True
	bIgnoreSecondPress=False
	bCollideActors=true
	bNoDelete=false
	MultiplicationSpeed=1
	Message="Use to Increase your RunSpeed!"
}
