//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_Action_Inventory Extends ScriptedAction;

var(Action) enum EAction
{
	A_Remove,
	A_Add,
} Action;
var(Action) class<Inventory> Inventory;

Function bool InitActionFor( ScriptedController C )
{
	local Inventory INV;
	local class<Inventory> INVClass;
	local pawn Target;

    Target = C.GetInstigator();
	if( Inventory != None && Target != None && C.Level.NetMode != NM_Client /* Clients should never try add or remove a weapon, doing so would result in having fake weapons */ )
	{
		if( Action == A_Remove )
		{
			// i.e. if a mut replaces the ShieldGun with something that doesn't extent sg, it is wise to make the inv class to remove to be effected as well.
			if( C.Level.Game.BaseMutator != none )
			{
				INVClass = C.Level.Game.BaseMutator.GetInventoryClass( string(Inventory) );
			}

			if( INVClass == none )
			{
				INVClass = Inventory;
			}

			INV = Target.FindInventoryType( INVClass );
			if( INV != None )
			{
				INV.DetachFromPawn( Target );
				Target.DeleteInventory( INV );
				if( INV != none )
				{
					INV.Destroy();
				}

				if( Target.Weapon == none )
				{
					Target.NextWeapon();
				}
			}
		}
		else if( Action == A_Add )
		{
			if( C.Level.Game.BaseMutator != none )
			{
				INVClass = C.Level.Game.BaseMutator.GetInventoryClass( string(Inventory) );
			}

			if( INVClass == none )
			{
				INVClass = Inventory;
			}

			if( Class<Weapon>(Inventory) != none )
				Target.GiveWeapon( string(Class<Weapon>(INVClass)) );
			else Target.CreateInventory( string(INVClass) );
		}
	}
	return False;
}
