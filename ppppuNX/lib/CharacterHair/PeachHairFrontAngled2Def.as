package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairFrontAngled2Def extends HairDefinition 
	{
		
		public function PeachHairFrontAngled2Def() 
		{
			SetScaleFactors([0.8276, 0.5103], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(30.15, 18.2), "Anal", "ReverseCowgirl");
			//scaleFactors["Anal"] = scaleFactors["ReverseCowgirl"] = [.80, .46];
			//attachPoints["Anal"] = attachPoints["ReverseCowgirl"] = new Point(3.6, -57.3);
			mySprite = new PeachHairFrontAngled2();
			pairedCharacter = "Peach";
			
			//depthOffsets["Anal"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			SetDepthOffsets(8.2, "Anal", "ReverseCowgirl");
		}
		
	}

}