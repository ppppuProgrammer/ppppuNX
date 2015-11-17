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
			SetInitialMatrix(10, -166.944);
			
			pairedCharacter = "Peach";
			
			SetScaleFactors([.505, .61], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(-49.20, 16.4375), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			attachPoints["Paizuri"] = new Point( -47.05, 19.7);
			//scaleFactors["Paizuri"] = [0.4672, 0.6136];
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.3471, 0.5889];
			attachPoints["Blowjob"] = new Point(12.8/*22.8*/, 96.15);
			
			layerPlacements["Cowgirl"] = HairDefinition.LAYER_FRONT;
			depthPriorities["Cowgirl"] = 1;
			SetDepthPriorities(3.1, "LeanBack", "Swivel", "LeanForward");
			depthPriorities["Paizuri"] = 2.1;
			SetDepthPriorities(7, "Anal", "ReverseCowgirl");
			SetDepthPriorities(0, "SideRide", "Grind");
			depthPriorities["Blowjob"] = 0;
		}
		
	}

}