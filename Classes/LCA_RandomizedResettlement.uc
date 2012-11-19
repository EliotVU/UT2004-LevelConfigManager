//==============================================================================
//	LevelConfigManager (C) 2006 - 2012 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_RandomizedResettlement extends Info
	placeable;
	
var() array<name> ActorTagsToResettle;
var() name ResettleToActorTag;
var() float ResettleTimer;

function MatchStarting()
{
	super.MatchStarting();
	Resettle();
	SetTimer( ResettleTimer, true );
}

event Timer()
{
	Resettle();
}

function Resettle()
{
	local Actor a;
	local array<Actor> locations, usedLocations;
	local int i, j, r, t;
	local bool breakOut;
	
	// Grab all possible locations to randomly settle to.
	foreach AllActors( class'Actor', a, ResettleToActorTag )
	{
		j = locations.Length;
		locations.Length = j + 1;
		locations[j] = a;
	}
	
	if( locations.Length < ActorTagsToResettle.Length )
	{
		Log( "Warning: Not enough actors to select from!", Name );
		return;
	}
	
	// Foreach actor to resettle, grab a random location
	for( i = 0; i < ActorTagsToResettle.Length; ++ i )
	{
		// Lazy-expensive way to find said actor.
		foreach AllActors( class'Actor', a, ActorTagsToResettle[i] )
		{
			t = 0;
		retry:
			r = Rand( locations.Length );
			
			for( j = 0; j < usedLocations.Length; ++ j )
			{
				if( usedLocations[j] == locations[r] )
				{
					breakOut = true;
					break;
				}
			}
			
			// Already in use, reselect a new random location and try again, but breakout if repeated steps fail.
			if( breakOut )
			{
				if( t > 5 )
					break;
					
				++ t;
				goto 'retry';
			}

			a.SetLocation( locations[r].Location );
			a.SetRotation( locations[r].Rotation );
			
			j = usedLocations.Length;
			usedLocations.Length = j + 1;
			usedLocations[j] = a;
			break;
		}
	}
}

defaultproperties
{
	Texture=A_ActorIcon
	ResettleTimer=180.00
}
