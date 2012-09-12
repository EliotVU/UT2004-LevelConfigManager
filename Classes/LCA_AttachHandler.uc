//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
// Spawned for ServerAttachActors and LocalAttachActors
Class LCA_AttachHandler Extends Info
	NotPlaceable;

var array<Actor> AttachsToWatch;

Simulated Event PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer( 2, False );
}

Simulated Event Timer()
{
	local int i;

	for( i = 0; i < AttachsToWatch.Length; ++ i )
	{
		if( AttachsToWatch[i] == None )
			continue;

		if( AttachsToWatch[i].Owner == None )
		{
			if( AttachsToWatch[i].IsA('Emitter') )
			{
				Emitter(AttachsToWatch[i]).LifeSpan = 5.0f;
				Emitter(AttachsToWatch[i]).Kill();
				AttachsToWatch[i] = None;
			}
			else
			{
				AttachsToWatch[i].Destroy();
			}
			continue;
		}
	}
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	bAlwaysRelevant=True
}
