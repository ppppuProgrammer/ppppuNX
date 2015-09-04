package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSide2RDef extends HairDefinition 
	{
		
		public function PeachHairSide2RDef() 
		{
			super();
			//mySprite = new PeachHairSide2();
			SetSprite(new PeachHairSide2());
			SetInitialMatrix(-5.2, 174.8);
			pairedCharacter = "Peach";
			
			SetScaleFactors([.7518, .5753], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(64.125, -47.25), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.6009, 0.4982];
			attachPoints["Blowjob"] = new Point(114.95, 27.6);
			
			depthOffsets["Cowgirl"] = 5.2;
			SetDepthOffsets(3.2, "LeanBack", "Swivel", "LeanForward");
			depthOffsets["Paizuri"] = 2.2;
			SetDepthOffsets( -0.1, "Anal", "ReverseCowgirl");
			SetDepthOffsets(8.1, "SideRide", "Grind", "Blowjob");
			//depthOffsets["Anal"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			//depthOffsets["Blowjob"] = 8.1;
		}
		
	}

}