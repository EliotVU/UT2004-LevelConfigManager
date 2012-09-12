//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_PinkRings Extends xEmitter;

Simulated Function Tick( float Delta )
{
	if( Owner != None )
	{
		LifeSpan = 3;
		if( Owner.bNetOwner && Pawn(Owner.Owner) != None && Pawn(Owner.Owner).Controller != None && PlayerController(Pawn(Owner.Owner).Controller) != None ) // The owner client.
		{
			if( PlayerController(Pawn(Owner.Owner).Controller).bBehindView )
			{
				if( Physics != PHYS_Trailer )
					SetPhysics( PHYS_Trailer );
			}
			else
			{
				if( Physics != PHYS_None )
				{
					SetPhysics( PHYS_Trailer );
					SetLocation( Owner.Owner.Location );
				}
			}
		}
		else if( Physics != PHYS_Trailer )
			SetPhysics( PHYS_Trailer );
	}
	else Destroy();
	Super.Tick(Delta);
}

DefaultProperties
{
	mSpawningType=ST_Explode
	mStartParticles=0
	mMaxParticles=20
	mLifeRange(0)=2.000000
	mLifeRange(1)=2.000000
	mRegenRange(0)=10.000000
	mRegenRange(1)=10.000000
	mPosDev=(X=35.000000,Y=35.000000,Z=45.000000)
	mSpeedRange(0)=0.000000
	mSpeedRange(1)=0.000000
	mMassRange(0)=-0.100000
	mMassRange(1)=-0.100000
	mAirResistance=2.000000
	mOwnerVelocityFactor=1.000000
	mSizeRange(0)=6.000000
	mSizeRange(1)=6.000000
	mAttenKa=0.500000
	mAttenFunc=ATF_ExpInOut
	bTrailerSameRotation=True
	bNetTemporary=False
	bReplicateMovement=False
	Physics=PHYS_Trailer
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=180.000000
	Skins(0)=Texture'XEffectMat.Ion.ion_ring'
	Style=STY_Additive
}
