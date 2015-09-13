package Characters 
{
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import ppppu.ppppuCharacter;
	import ppppu.UtilityFunctions;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author 
	 */
	public class PeachCharacter extends ppppuCharacter 
	{
		
		public function PeachCharacter() 
		{
			m_name = "Peach";
			var standardGradientEndPoint:uint = UtilityFunctions.GetColorUintFromRGB(243,182,154);
			m_innerDiamondColor1 = UtilityFunctions.GetColorUintFromRGB(255, 225, 227);
			m_innerDiamondColor2 = UtilityFunctions.GetColorUintFromRGB(254,194,199);
			m_innerDiamondColor3 = UtilityFunctions.GetColorUintFromRGB(253,159,167);
			m_outerDiamondColor = UtilityFunctions.GetColorUintFromRGB(252,120,131);
			m_defaultSkinColor = 0xFFDCC6; //255, 220, 198
			m_defaultSkinGradient_Face = [m_defaultSkinColor, standardGradientEndPoint];//2
			m_defaultSkinGradient_Breasts = [m_defaultSkinColor,m_defaultSkinColor, standardGradientEndPoint];//3
			m_defaultSkinGradient_Vulva = [standardGradientEndPoint,m_defaultSkinColor];//2
			m_defaultSkinGradient_Anus = [UtilityFunctions.GetColorUintFromRGB(255, 166, 159), m_defaultSkinColor];//2
			var irisColor:uint = UtilityFunctions.GetColorUintFromRGB(54,113,193);
			m_defaultIrisLColor = irisColor;
			m_defaultIrisRColor = irisColor;
			m_defaultScleraColor = 0xFFFFFF; //255,255,255
			m_defaultNippleColor = UtilityFunctions.GetColorUintFromRGB(255, 175, 255);
			m_defaultLipColor = UtilityFunctions.GetColorUintFromRGB(255, 153, 204);
			m_voiceCooldown = 30;
			m_voicePlayChance = 60;
			//TEST: Using Rosalina sounds
			m_voiceSet = new <Sound>[new sfxRosalina_1, /*new sfxRosalina_2,*/ new sfxRosalina_3, new sfxRosalina_4, new sfxRosalina_5, 
			new sfxRosalina_6, new sfxRosalina_7, new sfxRosalina_8, new sfxRosalina_9, new sfxRosalina_10, new sfxRosalina_11, 
			new sfxRosalina_12, new sfxRosalina_13];
		}
		
	}

}