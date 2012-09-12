//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_Action_PawnSet extends ScriptedAction
	dependson(LevelConfigActor);

var(Action) array<LevelConfigActor.sProperty> Set;
var(Action) private noexport editconst const string Example;
var noexport Pawn Causer;

Function bool InitActionFor( ScriptedController C )
{
	local int i, l, j;

    Causer = C.GetInstigator();
	if( Set.Length > 0 && Causer != None )
	{
		j = Set.Length;
		for( i = 0; i < j; i ++ )
		{
			l = Len( Set[i].PropertyName );
			if( l > 0 )
			{
				if( Set[i].PropertyName ~= "Rotation" )
				{
					Causer.SetRotation( rotator( Set[i].PropertyValue ) );
					continue;
				}
				else if( Set[i].PropertyName ~= "Location" )
				{
					Causer.SetLocation( vector( Set[i].PropertyValue ) );
					continue;
				}
				else if( Set[i].PropertyName ~= "DrawScale" )
				{
					Causer.SetDrawScale( float( Set[i].PropertyValue ) );
					Causer.SetCollisionSize( Causer.CollisionRadius * float( Set[i].PropertyValue ), Causer.CollisionHeight * float( Set[i].PropertyValue ) );
					continue;;
				}
				else if( Set[i].PropertyName ~= "Collision" )
				{
					Causer.SetCollisionSize( float( Left( Set[i].PropertyValue, InStr( Set[i].PropertyValue, "," ) ) ), float( Mid( Set[i].PropertyValue, InStr( Set[i].PropertyValue, "," ) ) ) );
					continue;
				}
				else Causer.SetPropertyText( Set[i].PropertyName, Set[i].PropertyValue );
			}
		}
		return True;
	}
	return False;
}

DefaultProperties
{
	Example="HealthMax,SuperHealthMax,Health,ShieldStrength,GroundSpeed,WaterSpeed,AirSpeed"
}
