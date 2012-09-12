//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_MomentumActorAction extends LCA_ActorAction;

var() Vector Momentum;
var() bool bResetVelocity;

function ActivateAction( Actor Other, optional Actor Instigator )
{
	if( bResetVelocity )
	{
		Other.Velocity = vect( 0, 0, 0 );
	}
	Other.SetPhysics( PHYS_Falling );

	if( Pawn(Instigator) != none )
	{
		Pawn(Instigator).AddVelocity( Momentum );
	}
	else
	{
		Other.Velocity += Momentum;
	}
}
