package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSideLDef extends HairDefinition 
	{
		
		public function PeachHairSideLDef() 
		{
			super();
			SetSprite(new PeachHairSide());
			SetInitialMatrix(18, -156.944);
			
			pairedCharacter = "Peach";
			
			SetScaleFactors([.505, .61], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(-51.20, 14.4375), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.3471, 0.5889];
			attachPoints["Blowjob"] = new Point(12.8/*22.8*/, 96.15);
			
			depthOffsets["Cowgirl"] = 5.1;
			SetDepthOffsets(3.1, "LeanBack", "Swivel", "LeanForward");
			depthOffsets["Paizuri"] = 2.1;
			SetDepthOffsets(7, "Anal", "ReverseCowgirl");
			SetDepthOffsets(0, "SideRide", "Grind");
			depthOffsets["Blowjob"] = 0;
		}
		
	}

}