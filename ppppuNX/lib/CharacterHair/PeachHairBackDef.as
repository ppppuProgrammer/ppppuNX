package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairBackDef extends HairDefinition 
	{
		
		public function PeachHairBackDef() 
		{
			mySprite = new PeachHairBack();
			pairedCharacter = "Peach";
			
			SetScaleFactors([2.49, 2.5404], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(31.15, 63.3), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			attachPoints["Paizuri"] = new Point(29.65, 81.05);
			//294.25-243.25
			SetScaleFactors([2.3849, 2.5397], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(131.3, 133.25), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([1.8617, 2.2826], "SideRide", "Grind");
			// 137, 117
			SetAttachPoints(new Point(139.15, 115.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [1.9171, 1.9601];
			attachPoints["Blowjob"] = new Point(134.4, 122.95);
			
			depthOffsets["Cowgirl"] = -36;
			SetDepthOffsets(-38, "Swivel", "LeanBack");
			//depthOffsets["Swivel"] = -38;
			//depthOffsets["LeanBack"] = -38;
			depthOffsets["LeanForward"] = -37;
			SetDepthOffsets(-12, "ReverseCowgirl", "Anal");
			//depthOffsets["Anal"] = -12;
			depthOffsets["Paizuri"] = -14;
			//depthOffsets["ReverseCowgirl"] = ;
			SetDepthOffsets(-13, "SideRide", "Grind");
			//depthOffsets["SideRide"] = -13;
			//depthOffsets["Grind"] = -13;
			depthOffsets["Blowjob"] = -19;
		}
		
	}

}