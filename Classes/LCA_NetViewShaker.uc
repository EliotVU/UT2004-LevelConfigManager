/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

A ViewShaker that works online because ''bNoDelete'' is true so that the trigger remains in the map in online games.

'''Note:''' A NetworkTrigger is needed for this to work properly online.

;Activation Type : Trigger

;On Activation : The instigator his camera will be shaked.
==============================================================================*/
class LCA_NetViewShaker extends ViewShaker;

defaultproperties
{
	// This actor must exist on the client so that the trigger function can be called by a NetworkTrigger on clients.
	bNoDelete=true
}
