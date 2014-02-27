//==============================================================================
//	LevelConfigManager (C) 2006 - 2014 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyMessage extends PickupMessagePlus;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject
    )
{
	local LCA_KeyPickup pickup;
	local string s;

	pickup = LCA_KeyPickup(OptionalObject);
	if( pickup == none )
		return "";

	Pickup.UpdateDefaults();
    s = pickup.Class.static.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
    Pickup.RestoreDefaults();
    return s;
}

static function color GetColor(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2
    )
{
    return class'LCA_KeyPickup'.default.KeyColor;
}

defaultproperties
{
	DrawColor=(R=255,G=255,B=0,A=255)
}