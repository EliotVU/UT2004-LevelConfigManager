//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_TakeDamageActorAction extends LCA_ActorAction;

var() int Damage;
var() vector Momentum;
var() class<DamageType> DamageType;

function ActivateAction( Actor Other, optional Actor Instigator )
{
	if( Instigator != none )
	{
		Instigator.TakeDamage( Damage, Pawn(Instigator), Instigator.Location, Momentum, DamageType );
	}
	else
	{
		Other.TakeDamage( Damage, none, Other.Location, Momentum, DamageType );
	}
}
