//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_InventoryCondition extends LCA_Condition;

var() array< class<Inventory> > InventoryReq;

function bool GetCondition( Actor Other )
{
	local Inventory Inv;
	local int i, num;
	local Pawn P;

	P = Pawn(Other);
	if( P == none )
	{
		return false;
	}

	for( i = 0; i < InventoryReq.Length; ++ i )
	{
		for( Inv = P.Inventory; Inv != none; Inv = Inv.Inventory )
		{
	  		if( Inv.Class == InventoryReq[i] )
	  		{
	  			++ num;
	  			break;
	  		}
		}
	}

	if( num != InventoryReq.Length )
	{
		SetDeniedMessage( "You need all required items, you have" @ num @ "of" @ InventoryReq.Length @ "required items." );
		return false;
	}
	return true;
}
