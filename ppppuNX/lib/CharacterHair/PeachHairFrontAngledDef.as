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
			SetScaleFactors([.80, .46], "SideRide", "Grind");
			SetAttachPoints(new Point(3.6, -57.3), "SideRide", "Grind");
			//depthOffsets["Grind"] = scaleFactors["SideRide"] = [.80, .46];
			//attachPoints["Grind"] = attachPoints["SideRide"] = new Point(3.6, -57.3);
			scaleFactors["Blowjob"] = [.80, .46];
			attachPoints["Blowjob"] = new Point(3.6, -57.3);
			//depthOffsets["Blowjob"];
			mySprite = new PeachHairFrontAngled();
			pairedCharacter = "Peach";
			
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			depthOffsets["Blowjob"] = 8.2;
		}
		
	}

}