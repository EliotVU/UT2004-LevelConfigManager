//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_GameRules Extends GameRules
	DependsOn(LevelConfigActor)
	NotPlaceable;

var float MomentumPower;
var LevelConfigActor.ETrialMode TrialMode;

Function int NetDamage( int OriginalDamage, int Damage, Pawn injured, Pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local int i;
	local bool bVolumesControlMomentum;
	local bool bIsInVolume;

	if( Injured == None )
		return Super.NetDamage(OriginalDamage,Damage,Injured,InstigatedBy,HitLocation,Momentum,DamageType);
	if( instigatedBy == injured || instigatedBy == None ) // if Causer is Self.
	{
		bIsInVolume = ( injured.PhysicsVolume != None );
		if( bIsInVolume )
		{
			for( i = 0; i < 8; i ++ )
			{
				if( injured.PhysicsVolume.ExcludeTag[i] == 'SetNeutralZone' )
				{
					Damage = 0;
					continue;
				}
				else if( Left( injured.PhysicsVolume.ExcludeTag[i], 14 ) ~= "SetDamagePlus_" )
				{
					Damage += int( Mid( injured.PhysicsVolume.ExcludeTag[i], 14 ) );
					continue;
				}
				if( bVolumesControlMomentum )continue;								// No need to do those again momentum should only be done once.
				if( injured.PhysicsVolume.ExcludeTag[i] == 'SetZeroMomentum' )
				{
					Momentum *= 0/0.3;
					bVolumesControlMomentum = True;
					continue;
				}
				else if( injured.PhysicsVolume.ExcludeTag[i] == 'TM_Normal' )
				{
					bVolumesControlMomentum = True;
					continue;
				}
				else if( injured.PhysicsVolume.ExcludeTag[i] == 'TM_DM' )
				{
					Momentum *= 1.0/0.3;
					bVolumesControlMomentum = True;
					continue;
				}
				else if( injured.PhysicsVolume.ExcludeTag[i] == 'TM_Master' )
				{
					Momentum *= 1.325/0.3;
					bVolumesControlMomentum = True;
					continue;
				}
				else if( injured.PhysicsVolume.ExcludeTag[i] == 'TM_Berserk' )
				{
					Momentum *= 1.5/0.3;
					bVolumesControlMomentum = True;
					continue;
				}
				else if( injured.PhysicsVolume.ExcludeTag[i] == 'TM_Custom' )
				{
					Momentum *= MomentumPower/0.3;
					bVolumesControlMomentum = True;
					continue;
				}
				else if( Left( injured.PhysicsVolume.ExcludeTag[i], 3 ) ~= "TM_" )
				{
					bVolumesControlMomentum = True;
					Momentum *= float( Mid( injured.PhysicsVolume.ExcludeTag[i], 3 ) )/0.3;
					continue;
				}
			}
		}
		if( !bVolumesControlMomentum )
		{
			switch( TrialMode )
			{
				case TM_DM:
					Momentum *= 1.0/0.3;
					break;

				case TM_Master:
					Momentum *= 1.325/0.3;
					break;

				case TM_Berserk:
					Momentum *= 1.5/0.3;
					break;

				case TM_Custom:
					Momentum *= MomentumPower/0.3;
					break;
			}
		}
	}
	return Super.NetDamage(OriginalDamage,Damage,Injured,InstigatedBy,HitLocation,Momentum,DamageType);
}

DefaultProperties
{
	MomentumPower=1.0
	bHidden=True
}
