//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_HealthCondition extends LCA_Condition;

var() float HealthReqPct;

function bool GetCondition( Actor other )
{
	if( Pawn(Other) != None )
	{
		if( (float(Pawn(Other).Health) / Pawn(Other).HealthMax) < HealthReqPct )
		{
			return false;
		}
	}
	return true;
}

function string GetDeniedMessage()
{
	return "You do not meet health requirement!, you must atleast have" @ (HealthReqPct * 100) @ "% of your max health.";
}

defaultproperties
{
}
