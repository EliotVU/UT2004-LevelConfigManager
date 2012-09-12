/**
 * ;Author : Eliot Van Uytfanghe
 * ;Created At : 2010
 * ;Last Updated : ???
 */

/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Touch

;On Activation : Restricts(Removes) the specified inventory(and weapons) class types from the instigator.
==============================================================================*/
class LCA_RestrictedInventoryVolume extends LCA_Volumes
	hidecategories(Message)
	hidecategories(PhysicsVolume);

var() array< class<Inventory> > RestrictedInventory;

event Touch( Actor Other )
{
	local int i;
	local class<Inventory> INVClass;
	local Inventory INV;

	super.Touch( Other );
	if( bEnabled && Pawn(Other) != none )
	{
		if( bTriggerOnceOnly )
		{
			bEnabled = false;
		}

		for( i = 0; i < RestrictedInventory.Length; ++ i )
		{
			if( RestrictedInventory[i] == none )
			{
				continue;
			}

			// i.e. if a mut replaces the ShieldGun with something that doesn't extent sg, it is wise to make the inv class to remove to be effected as well.
			if( Level.Game.BaseMutator != none )
			{
				INVClass = Level.Game.BaseMutator.GetInventoryClass( string(RestrictedInventory[i]) );
			}

			if( INVClass == none )
			{
				INVClass = RestrictedInventory[i];
			}

			INV = Pawn(Other).FindInventoryType( INVClass );
			if( INV != None )
			{
				INV.DetachFromPawn( Pawn(Other) );
				Pawn(Other).DeleteInventory( INV );
				if( INV != none )
				{
					INV.Destroy();
				}

				if( Pawn(Other).Weapon == none )
				{
					Pawn(Other).NextWeapon();
				}
			}
		}
	}
}

defaultproperties
{
	RestrictedInventory(0)=class'Inventory'

	Info="Restricts inventory from the entering playing by destroying all matched inventories."
}
