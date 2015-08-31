package CharacterHair 
{
	import flash.geom.Point;
	import ppppu.HairDefinition;
	/**
	 * ...
	 * @author 
	 */
	public class RosalinaHairFrontDef extends HairDefinition
	{
		
		public function RosalinaHairFrontDef() 
		{
			//scaleFactors["Cowgirl"] = [.90, 1.01];
			//attachPoints["Cowgirl"] = new Point(3.6, -65.75);
			SetScaleFactors([.90, 1.01], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(3.6, -65.75), "Cowgirl","Swivel","LeanBack","LeanForward","Paizuri");
			mySprite = new RosalinaHairFront();
			pairedCharacter = "Rosalina";
			
			depthOffsets["Cowgirl"] = 9;
			SetDepthOffsets(7, "LeanBack", "Swivel");
			//depthOffsets["Cowgirl"] = ;
			//depthOffsets["Swivel"] = ;
			//depthOffsets["LeanBack"] = ;
			//depthOffsets["LeanForward"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["Anal"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			//depthOffsets["Blowjob"] = ;
		}
		
	}

}