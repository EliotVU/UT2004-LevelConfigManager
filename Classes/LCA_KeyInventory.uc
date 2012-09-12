//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_KeyInventory extends Inventory;

var string KeyName;
var bool bOptional;
var LCA_KeyPickup PickupSource;

replication
{
	reliable if( bNetDirty && (Role == ROLE_Authority) && bNetOwner )
		KeyName, bOptional;

	reliable if( (Role == ROLE_Authority) )
		ClientLocalHide, ClientLocalShow;
}

function DropFrom( vector StartLocation )
{
	if( Instigator != none )
	{
		DetachFromPawn( Instigator );
		Instigator.DeleteInventory( self );
	}
	Destroy();
}

// Hides the pickup that gave this key, the pickup will be hidden local only, the pickup will be unhided localy when Destroyed is called client sidely using the PickupSource reference.
simulated function ClientLocalHide( LCA_KeyPickup Other )
{
	if( Other != none )
	{
		PickupSource = Other;
		Other.Hide();
	}
}

simulated function ClientLocalShow( LCA_KeyPickup Other )
{
	if( Other != none )
	{
		PickupSource = Other;
		LocalShow();
	}
}

function GiveTo( Pawn Other, optional Pickup Pickup )
{
	super.GiveTo( Other, Pickup );
	PickupSource = LCA_KeyPickup(Pickup);
	ClientLocalHide( PickupSource );
}

function AttachToPawn( Pawn P )
{
	super.AttachToPawn( P );
	ClientLocalHide( PickupSource );
}

simulated function LocalShow()
{
	if( PickupSource != none )
	{
		PickupSource.Show();
	}
}

function DetachFromPawn( Pawn P )
{
	super.DetachFromPawn( P );
	ClientLocalShow( PickupSource );
}

simulated event Destroyed()
{
	super.Destroyed();
	if( PickupSource != none && Level.NetMode != NM_DedicatedServer )
	{
		LocalShow();
	}
}

defaultproperties
{
	ItemName="Key"
}
