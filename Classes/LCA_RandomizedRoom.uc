//==============================================================================
//	LevelConfigManager (C) 2014 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_RandomizedRoom extends Info
	perobjectconfig
	config
	placeable;

/** An array of possible rooms for the RNG to select from. */
var(Rooms) array<struct sRoomInfo{
	/** A mesh room component to link to this actor's location when selected. */
	var() StaticMesh StaticMesh;

	var() Rotator RelativeRotation;
	var() Vector RelativeLocation;

	/** The event to instigate when this room is selected from RNG. */
	var() name Event;
	var() name Tag;

}> PossibleRooms;

var config int SeedIndex;
var config int SeedDay;
var config int SeedMonth;
var config int SeedYear;

var(Rooms) int SeedLifeSpanInDays;

event PreBeginPlay()
{
	local int dayDifference;

	super.PreBeginPlay();

	dayDifference = DateToDays( Level.Day, Level.Month, Level.Year ) - DateToDays( SeedDay, SeedMonth, SeedYear );
	if( SeedLifeSpanInDays <= 0 || SeedIndex == -1 || dayDifference >= SeedLifeSpanInDays ){
		SeedIndex = Rand( PossibleRooms.Length );

		if( SeedLifeSpanInDays > 0 ){
			SeedDay = Level.Day;
			SeedMonth = Level.Month;
			SeedYear = Level.Year;
			SaveConfig();
		}
	}

	SelectRoom( SeedIndex );
}

private function SelectRoom( int roomIndex )
{
	local sRoomInfo room;
	local Actor component;

	room = PossibleRooms[roomIndex];
	if( room.StaticMesh == none )
	{
		Warn( "No StaticMesh found for room seed: " $ roomIndex );
		return;
	}

	component = Spawn( class'LCA_DynamicMesh', self, room.Tag, self.Location + room.RelativeLocation, self.Rotation + room.RelativeRotation );
	component.SetStaticMesh( room.StaticMesh );

	TriggerEvent( room.Event, component, none );
}

// Thx to: http://alcor.concordia.ca/~gpkatch/gdate-algorithm.html
final function int DateToDays( int y, int m, int d )
{
	m = (m + 9) % 12;
	y -= m/10;
	return 365*y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + ( d - 1 );
}

defaultproperties
{
	SeedIndex=-1	
	SeedLifeSpanInDays=0
}