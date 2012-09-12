/*==============================================================================
LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.

;Activation Type : Trigger

;On Activation : The set ''WeaponsToAdd'' will be given to the instigator.
==============================================================================*/
class LCA_WeaponGiver extends LCA_Triggers
	hidecategories(Message,LCA_Triggers)
	placeable;

var() LevelConfigActor.sDefWepList WeaponsToAdd;

function Trigger( Actor Other, Pawn P )
{
	local int i, j;
	//local Weapon W;
	local class<Inventory> WClass;

	if( P != None )
	{
		j = WeaponsToAdd.DefaultStartWeapons.Length;
		for( i = 0; i < j; ++ i )
		{
			if( Level.Game.BaseMutator != none )
			{
				WClass = Level.Game.BaseMutator.GetInventoryClass( string( WeaponsToAdd.DefaultStartWeapons[i].DefaultStartWeapon ) );
			}

			if( class<Weapon>(WClass) == none )
			{
				WClass = WeaponsToAdd.DefaultStartWeapons[i].DefaultStartWeapon;
			}

			P.GiveWeapon( string( class<Weapon>(WClass) ) );
		}
	}
}

DefaultProperties
{
	Info="Will Give WeaponsToAdd List to the player who caused this trigger event!."
	bCollideActors=false
	bNoDelete=false
}
