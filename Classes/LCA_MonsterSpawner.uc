/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger, Automatic

;On Activation : Spawns monsters will with specified properties. This can be either automatic by a timer or whenever triggered. A max monsters limit can be set but keep in mind that if you are gonna use more than one ''MonsterSpawner'' then please set a unique ''Tag'' for each ''MonsterSpawner''.
==============================================================================*/
class LCA_MonsterSpawner extends LCA_Triggers
	placeable
	hidecategories(Message);

var() float SpawnTime;									// Amount of time before spawning next monster.
struct sMonsterData
{
	var() class<Monster> MonsterClass;					// Monster to spawn.
	var() class<AIController> MonsterController;		// Controller which handles how this monster acts.
	var() array<LevelConfigActor.sProperty> Properties;
	var() float MonsterSize;
};
var() array<sMonsterData> MonsterList;					// Monster elements.
var noexport int Num, NumMonsters;						// Num element to spawn and amount of monsters spawned by this actor.
var() int RequiredPlayers;								// Players need before spawning any monsters.
var() int MaxMonsters;									// Max monsters this actor may spawn.
var() class<Emitter> SpawnEffect;						// Spawned when a monster spawns.
var() enum ESpawnType									// When to spawn monster.
{
	ST_Timer,						// Spawn when timer ends.
	ST_Triggered,					// Spawn when triggered.
} SpawnType;
var() enum ESpawnOrder									// Order of element selection.
{
	SO_Ordered,						// Start from element one to last and repeat.
	SO_Random,						// Take a random element to be spawned as next monster.
} SpawnOrder;
var() enum ESpawnLocation								// Place to spawn monster at.
{
	SL_Self,						// Spawn monster at this actor.
	SL_PlayerStart,					// Spawn monster at a random navigation point.
} SpawnLocation;

function MatchStarting()
{
	if( MonsterList.Length == 0 )
		return;
	SpawnTime = Max( SpawnTime, 1 );
	if( SpawnType == ST_Timer )
		SetTimer( SpawnTime, true );
	else if( SpawnOrder == SO_Random )
		Num = Rand( MonsterList.Length );
}

event Timer()
{
	SpawnMonster();
}

final function SpawnMonster()
{
	local Monster M;
	local int i;
	local NavigationPoint N;

	if( IsEnabled() && Level.Game.NumPlayers >= RequiredPlayers )				// Only spawn when there are actualy enough people playing in the server.
	{
		if( NumMonsters >= MaxMonsters && MaxMonsters > 0 )
			return;
       	// Loop the array again from the begin.
		if( SpawnOrder == SO_Ordered && Num >= MonsterList.Length )
		{
			Num = 0;
		}
		if( SpawnLocation == SL_Self )
		{
			M = Spawn( MonsterList[Num].MonsterClass,,, Location, Rotation );
		}
		else if( SpawnLocation == SL_PlayerStart )
		{
			N = Level.Game.FindPlayerStart( None );
			if( N != none )
			{
				M = Spawn( MonsterList[Num].MonsterClass,,, N.Location, N.Rotation );
			}
			else
			{
				M = Spawn( MonsterList[Num].MonsterClass,,, Location, Rotation );
			}
		}
		if( M != None )
		{
			++ NumMonsters;
			if( SpawnEffect != None )
				Spawn( SpawnEffect,,, M.Location, M.Rotation );
			if( MonsterList[Num].MonsterController != None )
				M.ControllerClass = MonsterList[Num].MonsterController;
			for( i = 0; i < MonsterList[Num].Properties.Length; ++ i )
			{
				M.SetPropertyText( MonsterList[Num].Properties[i].PropertyName, MonsterList[Num].Properties[i].PropertyValue );
			}
			if( MonsterList[Num].MonsterSize != 0 )
			{
				M.SetDrawScale( MonsterList[Num].MonsterSize );
				M.SetCollisionSize( M.Default.CollisionRadius * MonsterList[Num].MonsterSize, M.Default.CollisionHeight * MonsterList[Num].MonsterSize );
			}
			// So monster will trigger this actor when it dies and then we decrement monsternum so monsters are allowed to be spawned again.
			M.Event = Tag;
		}
		// Change num even if failed to spawn, to avoid from failing to spawn again.
		if( SpawnOrder == SO_Ordered )
			++ Num;
		else if( SpawnOrder == SO_Random )
			Num = Rand( MonsterList.Length );
	}
}

function Trigger( Actor Other, Pawn Player )
{
	// An monster died.
	if( IsEnabled() && Monster(Player) != none )
	{
		-- NumMonsters;
		return;
	}
	// Toggle enabled and reset element to zero.
	if( SpawnType == ST_Timer )
		bEnabled = !bEnabled;
	else if( SpawnType == ST_Triggered && IsEnabled() )
		SpawnMonster();
	// Act like a new actor when disabled for when later activated...
	if( !IsEnabled() )
	{
		if( SpawnOrder == SO_Ordered )
			Num = 0;
		else if( SpawnOrder == SO_Random )
			Num = Rand( MonsterList.Length );
	}
}

// Don't reset NumMonsters because the monsters actually still might be alive!.
function Reset()
{
	super.Reset();
	if( SpawnOrder == SO_Ordered )
		Num = 0;
	else if( SpawnOrder == SO_Random )			// Make sure it will be random next round so it wont start next round at zero.
		Num = Rand( MonsterList.Length );
}

defaultproperties
{
	Info="Leave the properties like they are by default if u want the monster to use his own default properties."

	Num=0
	SpawnTime=35
	RequiredPlayers=1
	MaxMonsters=10
	NumMonsters=0

	MonsterList(0)=(MonsterClass=Class'SkaarjPack.Krall',MonsterController=None,MonsterSize=0,Properties=((PropertyName="ScoringValue",PropertyValue="5"),(PropertyName="Health",PropertyValue="360")))
	bDirectional=true
}
