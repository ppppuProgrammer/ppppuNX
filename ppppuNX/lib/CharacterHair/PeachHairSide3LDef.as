package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSide3LDef extends HairDefinition 
	{
		
		public function PeachHairSide3LDef() 
		{
			super();
			//mySprite = new PeachHairSide3();
			SetSprite(new PeachHairSide3());
			SetInitialMatrix(9.5, 9.5);
			
			pairedCharacter = "Peach";
			
			SetScaleFactors([1.029, .6086], "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			//SetAttachPoints(new Point(-34.975 - 15, 19.25 - 3.5), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(-43.15, -73.35), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			scaleFactors["Paizuri"] = [0.9359, 0.4927];
			attachPoints["Paizuri"] = new Point( -38, -67.15);
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.5873, 0.5152];
			attachPoints["Blowjob"] = new Point(22.700000000000003, 5.9);
			
			layerPlacements["Cowgirl"] = HairDefinition.LAYER_BEHIND_FACE;
			depthPriorities["Cowgirl"] = 1;
			SetDepthPriorities( -4, "LeanBack", "Swivel", "LeanForward", "Paizuri");
			SetDepthPriorities(8, "Anal", "ReverseCowgirl");
			SetDepthPriorities(-0.2, "SideRide", "Grind");
			depthPriorities["Blowjob"] = 7.2;
		}
		
	}

}