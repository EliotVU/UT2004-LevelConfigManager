//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
// Coded by Eliot,
// Bots really suck with this gun :).
class LCA_AShieldFire extends ShieldFire;

function Timer()
{
	local xPawn P;
	local float Regen;
    local float ChargeScale;

    if( HoldTime > 0.0 && !bNowWaiting )
    {
		if( Instigator != None )
		{
            Instigator.AmbientSound = ChargingSound;
			Instigator.SoundVolume = ChargingSoundVolume;
            ChargeScale = FMin(HoldTime, FullyChargedTime);
            if( ChargingEmitter != None )
            {
                ChargingEmitter.mRegenPause = false;
                Regen = ChargeScale * 10 + 20;
                ChargingEmitter.mRegenRange[0] = Regen;
                ChargingEmitter.mRegenRange[1] = Regen;
                ChargingEmitter.mSpeedRange[0] = ChargeScale * -15.0;
                ChargingEmitter.mSpeedRange[1] = ChargeScale * -15.0;
                Regen = FMax((ChargeScale / 30.0),0.20);
                ChargingEmitter.mLifeRange[0] = Regen;
                ChargingEmitter.mLifeRange[1] = Regen;
            }

            if( !bStartedChargingForce )
            {
                bStartedChargingForce = true;
                ClientPlayForceFeedback( ChargingForce );
            }
        }
    }
    else
    {
		if( Instigator.AmbientSound == ChargingSound )
		{
			Instigator.AmbientSound = None;
			Instigator.SoundVolume = Instigator.Default.SoundVolume;
		}
        SetTimer( 0, False );
    }
	if( Level.NetMode == NM_Client )return;
	P = xPawn(Instigator);
	if( P != None )
	{
		if( P.Health < P.HealthMax )
			P.Health = Min( P.Health + LCA_AirShieldGun(Weapon).HealthBoost, P.HealthMax );
		else if( P.ShieldStrength < P.ShieldStrengthMax )
			P.ShieldStrength = Min( P.ShieldStrength + LCA_AirShieldGun(Weapon).HealthBoost, P.ShieldStrengthMax );
	}
}

function DoFireEffect()
{
	local Vector X,Y,Z;
	local float Scale, Damage, Force;

	Instigator.MakeNoise(1.0);
	Weapon.GetViewAxes(X,Y,Z);
	Scale = (FClamp(HoldTime, MinHoldTime, FullyChargedTime) - MinHoldTime) / (FullyChargedTime - MinHoldTime); // result 0 to 1
	Damage = MinDamage + Scale * (MaxDamage - MinDamage);
	Force = MinForce + Scale * (MaxForce - MinForce);
	if( Instigator != None )
	{
		Instigator.AmbientSound = None;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;

		if( ChargingEmitter != None )
			ChargingEmitter.mRegenPause = true;

		if( xPawn(Instigator).bBerserk )
			Force *= 2.0;
		Instigator.TakeDamage( MinSelfDamage + SelfDamageScale * Damage, Instigator, Instigator.Location, -SelfForceScale * Force * X, DamageType );
	}
	SetTimer( 0, False );
}

defaultproperties
{
	SelfForceScale=1.200000
	SelfDamageScale=0.100000
	MinSelfDamage=3.000000
	FireRate=0.300000
	AmmoClass=Class'LCA_AirEnergy'
	DamageType=Class'LCA_AirDamType'
	AmmoPerFire=1
	BotRefireRate=0.700000
}
