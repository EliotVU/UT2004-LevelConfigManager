//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
//======================================================================
// a Todolist for mappers that map with a friend
// to fill a list with ideas etc for when its ur partner turn to map.
//======================================================================
class LCA_TodoList extends Note
	hidecategories(Events,Display,Object,Movement,Advanced,Collision,Sound,Lighting,Karma,Force,LightColor,Note)
	collapsecategories;

var() localized const array<string> Todo;

defaultproperties
{
	Text="This is an todolist, click me to see all tasks"
	Todo(0)="Input an unfinished task here"
}
