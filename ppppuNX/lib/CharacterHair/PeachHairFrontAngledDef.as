package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairFrontAngledDef extends HairDefinition 
	{
		
		public function PeachHairFrontAngledDef() 
		{
			SetScaleFactors([0.6383, 0.5475], "SideRide", "Grind");
			SetAttachPoints(new Point(43.15, 18.05), "SideRide", "Grind");
			//depthOffsets["Grind"] = scaleFactors["SideRide"] = [.80, .46];
			//attachPoints["Grind"] = attachPoints["SideRide"] = new Point(3.6, -57.3);
			scaleFactors["Blowjob"] = [0.66, 0.599];
			attachPoints["Blowjob"] = new Point(47.4, 20.7);
			//depthOffsets["Blowjob"];
			mySprite = new PeachHairFrontAngled();
			pairedCharacter = "Peach";
			
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			SetDepthPriorities(8.2, "SideRide", "Grind", "Blowjob");
			depthPriorities["Blowjob"] = 8.2;
		}
		
	}

}