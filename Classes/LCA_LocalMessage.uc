//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_LocalMessage Extends CriticalEventPlus;

Static Function string GetString( optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if( LCA_LocalMessageTrigger(OptionalObject) == None )return "";
	else return LCA_LocalMessageTrigger(optionalObject).Message;
}

Static Function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	local LCA_LocalMessageTrigger LM;

	LM = LCA_LocalMessageTrigger(OptionalObject);
	if( LM != None )
	{
		Default.bBeep = LM.bBeep;
		Default.bFadeMessage = LM.bFade;
		Default.bIsConsoleMessage = LM.bShowInConsole;
		Default.DrawColor = LM.MessageColor;
		Default.PosX = LM.Position.X;
		Default.PosY = LM.Position.Y;
		Default.LifeTime = LM.LifeTime;
	}
	Super.ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

DefaultProperties
{
	bIsConsoleMessage=False
}
