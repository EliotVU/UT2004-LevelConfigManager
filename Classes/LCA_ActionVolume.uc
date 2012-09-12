/*==============================================================================
Copyright 2006-2010 Eliot Van Uytfanghe. All Rights Reserved.

;Activation Type : Enter

;On Activation : All set '''Actions''' will be activated linearly.
==============================================================================*/
class LCA_ActionVolume extends LCA_Volumes;

var() editinlinenotify export array<LCA_ActorAction> Actions;

simulated event PawnEnteredVolume( Pawn Other )
{
	local int i;

	if( bEnabled )
	{
		for( i = 0; i < Actions.Length; ++ i )
		{
			if( Actions[i] != none )
			{
				Actions[i].ActivateAction( self, Other );
			}
		}
	}
}
