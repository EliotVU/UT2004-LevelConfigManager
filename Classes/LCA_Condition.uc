//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_Condition extends Object
	editinlinenew
	hidedropdown
	collapsecategories
	hidecategories(Object)
	abstract;

// Cached deniedmessage, which is most likely set by GetCondition.
var private string DeniedMessage;

function bool GetCondition( Actor Other )
{
	return true;
}

function SetDeniedMessage( string message )
{
	DeniedMessage = message;
}

function string GetDeniedMessage()
{
	return DeniedMessage;
}
