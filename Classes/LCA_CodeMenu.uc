//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
Class LCA_CodeMenu Extends FloatingWindow;

var automated GUILabel l_ThaCodeBitch;
var automated GUIButton b_Numeric[10];
var automated GUIButton b_Enter, b_BackSpace, b_Clear, b_Close;
var automated moEditBox eb_MyCode;
var automated GUIScrollTextBox st_Desc;
var automated GUISectionBackground sbg_debr;
var string CurrentCode;
const MaxCLength = 10;
var LCA_AccessTrigger PT;
var LCA_AccessInfo AcInfo;

Function Opened( GUIComponent Sender )
{
	ForEach PlayerOwner().Pawn.TouchingActors( Class'LCA_AccessTrigger', PT )
		break;

	if( PT == None )
		Controller.CloseMenu();
	else st_Desc.SetContent( PT.MakeColor( PT.MessageColor )$PT.Description );

	i_FrameBG.Image = sbg_debr.Default.HeaderBase;
}

Function OnClose( optional bool bCancelled )
{
	if( AcInfo != None )
		AcInfo.ServerDestroy();
}

Function bool InternalOnClick( GUIComponent Sender )
{
	if( PT == None || PlayerOwner().Pawn == None || AcInfo == None )return False;
	if( Len( CurrentCode ) < MaxCLength )
	{
		if( Sender == b_Numeric[0] )
			CurrentCode $= "0";
		else if( Sender == b_Numeric[1] )
			CurrentCode $= "1";
		else if( Sender == b_Numeric[2] )
			CurrentCode $= "2";
		else if( Sender == b_Numeric[3] )
			CurrentCode $= "3";
		else if( Sender == b_Numeric[4] )
			CurrentCode $= "4";
		else if( Sender == b_Numeric[5] )
			CurrentCode $= "5";
		else if( Sender == b_Numeric[6] )
			CurrentCode $= "6";
		else if( Sender == b_Numeric[7] )
			CurrentCode $= "7";
		else if( Sender == b_Numeric[8] )
			CurrentCode $= "8";
		else if( Sender == b_Numeric[9] )
			CurrentCode $= "9";
	}
	if( Sender == b_Enter )
	{
		if( PT.ServerCheckCode( CurrentCode, PlayerOwner().Pawn ) )
		{
			PlayerOwner().PlayOwnedSound( PT.CorrectSnd,, 255, True );
			AcInfo.SendCode( int( CurrentCode ), PlayerOwner().Pawn );
			Controller.CloseMenu();
		}
		else PlayerOwner().PlayOwnedSound( PT.IncorrectSnd,, 255, True );
	}
	else if( Sender == b_Clear )
		CurrentCode = "";
	else if( Sender == b_BackSpace )
		CurrentCode = Left( CurrentCode, Len( CurrentCode ) - 1 );
	else if( Sender == b_Close )
		Controller.CloseMenu();
	eb_MyCode.SetText( CurrentCode );
	return False;
}

DefaultProperties
{
	WindowName="Access Menu"
	WinWidth=0.500000
	WinHeight=0.400000
	WinLeft=0.000000
	WinTop=0.131250
	bScaleToParent=True
	bBoundToParent=True
	//bPersistent=True
	bAllowedAsLast=True

	Begin Object class=GUISectionBackground name=border
		Caption="Description"
		WinWidth=0.550000
		WinHeight=0.700000
		WinLeft=0.400000
		WinTop=0.100000
		HeaderBase=Material'2K4Menus.NewControls.Display99'
	End Object
	sbg_debr=border

	Begin Object class=GUIScrollTextBox name=Desc
		WinWidth=0.550000
		WinHeight=0.700000
		WinLeft=0.425000
		WinTop=0.150000
		CharDelay=0.050000
		EOLDelay=0.250000
	End Object
	st_Desc=Desc

	Begin Object class=GUIButton name=0
		Caption="0"
		WinTop=0.850000
		WinLeft=0.050000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(0)=0

	Begin Object class=GUIButton name=1
		Caption="1"
		WinTop=0.750000
		WinLeft=0.050000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(1)=1

	Begin Object class=GUIButton name=2
		Caption="2"
		WinTop=0.750000
		WinLeft=0.150000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(2)=2

	Begin Object class=GUIButton name=3
		Caption="3"
		WinTop=0.750000
		WinLeft=0.250000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(3)=3

	Begin Object class=GUIButton name=4
		Caption="4"
		WinTop=0.650000
		WinLeft=0.050000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(4)=4

	Begin Object class=GUIButton name=5
		Caption="5"
		WinTop=0.650000
		WinLeft=0.150000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(5)=5

	Begin Object class=GUIButton name=6
		Caption="6"
		WinTop=0.650000
		WinLeft=0.250000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(6)=6

	Begin Object class=GUIButton name=7
		Caption="7"
		WinTop=0.550000
		WinLeft=0.050000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(7)=7

	Begin Object class=GUIButton name=8
		Caption="8"
		WinTop=0.550000
		WinLeft=0.150000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(8)=8

	Begin Object class=GUIButton name=9
		Caption="9"
		WinTop=0.550000
		WinLeft=0.250000
		WinWidth=0.090000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Numeric(9)=9

	Begin Object class=GUIButton name=BackSpace
		Caption="BackSpace"
		WinTop=0.850000
		WinLeft=0.150000
		WinWidth=0.190000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_BackSpace=BackSpace

	Begin Object class=GUIButton name=Clear
		Caption="Clear"
		Hint="Clean up the code box"
		WinTop=0.195000
		WinLeft=0.200000
		WinWidth=0.140000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Clear=Clear

	Begin Object class=GUIButton name=Enter
		Caption="Enter"
		Hint="Send code you've entered"
		WinTop=0.195000
		WinLeft=0.050000
		WinWidth=0.140000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Enter=Enter

	Begin Object class=GUIButton name=Close
		Caption="Close"
		Hint="Close this window"
		WinTop=0.850000
		WinLeft=0.400000
		WinWidth=0.550000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	b_Close=Close

	Begin Object class=GUILabel name=cTitle
		Caption="Entered Code"
		TextColor=(R=255,G=255,B=255,A=255)
		WinTop=0.050000
		WinLeft=0.050000
		WinWidth=0.300000
		WinHeight=0.080000
		OnClick=InternalOnClick
	End Object
	l_ThaCodeBitch=cTitle

	Begin Object class=moEditBox name=MyCode
		Hint="Entered Code"
		bReadOnly=True
		bFlipped=True
		WinTop=0.125000
		WinLeft=0.052500
		WinWidth=0.570000
		WinHeight=0.030000
	End Object
	eb_MyCode=MyCode
}
