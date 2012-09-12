//==============================================================================
//	LevelConfigManager (C) 2006 - 2010 Eliot Van Uytfanghe All Rights Reserved.
//==============================================================================
class LCA_Util extends Object
	hidedropdown;

var float LastColorTime;
var color LastUsedColorC;

// Util from MutNoAutoFire, coded by .:..:
static function color GetFlashColor( float TimeS )
{
	local Color C;

	if( Default.LastColorTime==TimeS )
		Return Default.LastUsedColorC;

	//C.A = 128+GetFacingCol(TimeS,2);
	C.R = GetFacingCol(TimeS,2.451);
	C.G = GetFacingCol(TimeS,1.252);
	C.B = GetFacingCol(TimeS,7.164);
	Default.LastColorTime = TimeS;
	Default.LastUsedColorC = C;
	Return C;
}

// Util from MutNoAutoFire, coded by .:..:
static function byte GetFacingCol( float TimeS, float Div )
{
	TimeS = (TimeS-int(TimeS/Div)*Div)/Div;
	if( TimeS<0.5 )
		Return byte(TimeS*510);
	else Return byte((1-TimeS)*510);
}

// Util from UnrealWiki, see http://wiki.beyondunreal.com/Legacy:RGB_To_HLS_Conversion.
static function vector colourmap ( vector rgb)
{
  local float min;
  local float max;
  local vector hls;
  local float r,g,b,h,l,s;
  // clamp em all to range 0...1;
  rgb.x= Fclamp(rgb.x,0,1);
  rgb.y= Fclamp(rgb.y,0,1);
  rgb.z= Fclamp(rgb.z,0,1);

  r=rgb.x; //sanity improving assignments!
  g=rgb.y;
  b=rgb.z;

  // find minimum and maximum
  max = Fmax(fmax(r,g),b) ;
  min = Fmin(Fmin(r,g),b);

  l = (max+min)/2; //lightness

  if (max==min)  //i.e it's pure grey
   {
     s = 0;
     h = 0;
   }
  else
   {
    if (l < 0.5)  s =(max-min)/(max+min);
    If (l >=0.5)  s =(max-min)/(2.0-max-min);
   }

  If (R == max)  h  = (G-B)/(max-min);
  If (G == max) h = 2.0 + (B-R)/(max-min);
  If (B == max)    h = 4.0 + (R-G)/(max-min);

  //this leaves h from 0...6 , l,s from 0..1 now scale to what unreal wants:
  // in this case 0..255   ,apart from saturation which seems to want 0..100 ish
  hls.x=(h/6)*255;
  hls.y=(l*255);
  hls.z=(s*127);

  return( hls);
}

static function RGBToHLS(color InRGB, out byte Hue, out float Luminance, out byte Saturation)
{
    local vector RGB, HLS;

    RGB.X = InRGB.R / 255.0;
    RGB.Y = InRGB.G / 255.0;
    RGB.Z = InRGB.B / 255.0;
    HLS = colourmap(RGB);
    Hue = HLS.X;
    Luminance = HLS.Y;
    Saturation = HLS.Z;
}
