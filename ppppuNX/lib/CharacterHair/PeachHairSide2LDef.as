package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSide2LDef extends HairDefinition 
	{
		
		public function PeachHairSide2LDef() 
		{
			super();
			//mySprite = new PeachHairSide2();
			SetSprite(new PeachHairSide2());
			SetInitialMatrix(8.3, 8.3);
			
			pairedCharacter = "Peach";
			
			SetScaleFactors([.7518, .5753], "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			SetAttachPoints(new Point(-67.5, -45.85), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			scaleFactors["Paizuri"] = [0.664, 0.5033];
			attachPoints["Paizuri"] = new Point(-61, -42.150000000000006);
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.4306, 0.5352];
			attachPoints["Blowjob"] = new Point(10.05, 34.1);
			
			depthOffsets["Cowgirl"] = 5.3;
			SetDepthOffsets(3.3, "LeanBack", "Swivel", "LeanForward");
			depthOffsets["Paizuri"] = 2.3;
			SetDepthOffsets(8.1, "Anal", "ReverseCowgirl");
			SetDepthOffsets(-0.1, "SideRide", "Grind");
			//depthOffsets["Anal"] = ;
			//depthOffsets["Paizuri"] = ;
			//depthOffsets["ReverseCowgirl"] = ;
			//depthOffsets["SideRide"] = ;
			//depthOffsets["Grind"] = ;
			depthOffsets["Blowjob"] = 8;
		}
		
	}

}