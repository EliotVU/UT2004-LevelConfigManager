//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyRequirementCondition extends LCA_Condition;

var() export array<string> RequiredKeys;
var() bool bRequireOptionals;
var private transient Pawn CachedInstigator;
var private transient array<string> CachedKeyNames;

// Optional does not count!
function bool ContainsAllKeys( Pawn Other, out array<LCA_KeyInventory> FoundKeys, out array<string> MissingKeys, optional bool bRequireOptional )
{
	local Inventory Inv;
	local LCA_KeyInventory FoundKey;
	local int i;

	for( i = 0; i < RequiredKeys.Length; ++ i )
	{
		for( Inv = Other.Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( LCA_KeyInventory(Inv) != None && (!LCA_KeyInventory(Inv).bOptional || bRequireOptional) )
			{
				if( LCA_KeyInventory(Inv).KeyName == Requiredkeys[i] )
				{
					FoundKey = LCA_KeyInventory(Inv);
					FoundKeys[FoundKeys.Length] = FoundKey;
					break;
				}
			}
		}

		if( FoundKey == none )
		{
			MissingKeys[MissingKeys.Length] = RequiredKeys[i];
		}

		FoundKey = none;
	}
	return FoundKeys.Length >= RequiredKeys.Length;
}

function bool GetCondition( Actor Other )
{
	local array<LCA_KeyInventory> FoundKeys;
	local array<string> MissingKeys;

	if( Pawn(Other) != None )
	{
		if( ContainsAllKeys( Pawn(Other), FoundKeys, MissingKeys, bRequireOptionals ) )
		{
			return true;
		}

        CachedInstigator = Pawn(Other);
        CachedKeyNames = MissingKeys;
	}
	return false;
}

// HACK:
function string GetDeniedMessage()
{
	local int i;

	if( CachedInstigator != none )
	{
		CachedInstigator.ClientMessage( super.GetDeniedMessage() );
		for( i = 0; i < CachedKeyNames.Length; ++ i )
		{
			CachedInstigator.ClientMessage( "  " $ CachedKeyNames[i] );
		}
		return "";
	}
	else
	{
  		return "You do not have all the required keys, you must collect all required keys";
  	}
}

defaultproperties
{
	DeniedMessage="You do not have all the required keys, collect all the missing keys listed below to complete this objective!."
}

