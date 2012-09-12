//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_HudOverlay extends HudOverlay;

var() Material Tex;
var() color Color;
var() bool bNotInSpec;

simulated function Render( Canvas C )
{
	if( Tex == none || ((C.Viewport.Actor.Pawn == none || C.Viewport.Actor.bBehindView) && bNotInSpec) )
		return;

	C.SetPos( 0, 0 );
	C.DrawColor = Color;
	C.DrawTileStretched( Tex, C.ClipX, C.ClipY );
}

defaultproperties
{
	Color=(R=255,G=255,B=255,A=255)
	bNotInSpec=true
}
