package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairFrontDef extends HairDefinition
	{
		
		public function PeachHairFrontDef() 
		{
			SetScaleFactors([.80, .46], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(2.7, -59.175), "Cowgirl","Swivel","LeanBack","LeanForward","Paizuri");
			//scaleFactors["Cowgirl"] = scaleFactors["Swivel"] = scaleFactors["LeanBack"]= scaleFactors["LeanForward"] = scaleFactors["Paizuri"] = [.80, .46];
			//attachPoints["Cowgirl"] = attachPoints["Swivel"] = attachPoints["LeanBack"]= attachPoints["LeanForward"] = attachPoints["Paizuri"] = new Point(3.6, -57.3);
			mySprite = new PeachHairFront();
			pairedCharacter = "Peach";
			
			depthOffsets["Cowgirl"] = 5.4;
			SetDepthOffsets(3.4, "LeanBack", "Swivel", "LeanForward");
			depthOffsets["Paizuri"] = 2.4;
			//depthOffsets["Anal"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
		}
	}
}