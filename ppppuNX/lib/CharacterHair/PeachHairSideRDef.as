package CharacterHair 
{
	
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSideRDef extends HairDefinition 
	{
		
		public function PeachHairSideRDef() 
		{
			super();
			//mySprite = new PeachHairSide();
			SetSprite(new PeachHairSide());
			pairedCharacter = "Peach";
			
			SetInitialMatrix(-9.5, -9.8);
			
			SetScaleFactors([.505, .61], "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			SetAttachPoints(new Point(50.95, 14.025), "Cowgirl", "Swivel", "LeanBack", "LeanForward");
			
			attachPoints["Paizuri"] = new Point(48.4, 19.05);
			scaleFactors["Paizuri"] = [0.424, 0.6024];
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			//SetScaleFactors([.3059, .552], "SideRide", "Grind");
			//SetAttachPoints(new Point( -41.4, 135.25), "SideRide", "Grind");
			
			attachPoints["SideRide"] = new Point(84.35, 64.3);
			scaleFactors["SideRide"] = [0.4155, 0.5776];
			
			attachPoints["Grind"] = new Point(-94.45, -64.95);
			scaleFactors["Grind"] = [1.7964, 1.7126];
			
			scaleFactors["Blowjob"] = [0.4508, 0.6018];
			attachPoints["Blowjob"] = new Point(118.4, 91.10);
			
			layerPlacements["Cowgirl"] = HairDefinition.LAYER_FRONT;
			depthPriorities["Cowgirl"] = 0;
			SetDepthPriorities(3, "LeanBack", "Swivel", "LeanForward");
			depthPriorities["Paizuri"] = 2;
			SetDepthPriorities(0, "Anal", "ReverseCowgirl");
			SetDepthPriorities(7, "SideRide", "Grind", "Blowjob");
			//depthOffsets["Blowjob"] = 7;
		}
		
	}

}