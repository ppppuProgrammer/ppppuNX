package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSide3RDef extends HairDefinition 
	{
		
		public function PeachHairSide3RDef() 
		{
			super();
			//mySprite = new PeachHairSide3();
			SetSprite(new PeachHairSide3());
			SetInitialMatrix(-10.2, 169.8);
			pairedCharacter = "Peach";
			
			SetScaleFactors([1.035, .6165], "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			//SetAttachPoints(new Point(-34.975 - 15, 19.25 - 3.5), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(42.70, -76.10), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			scaleFactors["Paizuri"] = [0.9359, 0.4927];
			attachPoints["Paizuri"] = new Point(37.75, -69.15);
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.7034, 0.4991];
			attachPoints["Blowjob"] = new Point(114.65, -3.4000000000000004);
			
			depthOffsets["Cowgirl"] = -3.1;
			SetDepthOffsets( -4.1, "LeanBack", "Swivel", "LeanForward", "Paizuri");
			SetDepthOffsets( -0.2, "Anal", "ReverseCowgirl");
			SetDepthOffsets(8, "SideRide", "Grind");
			//depthOffsets["Anal"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			depthOffsets["Blowjob"] = 7.1;
		}
		
	}

}