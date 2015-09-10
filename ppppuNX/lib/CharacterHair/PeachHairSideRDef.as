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
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point( -41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [0.4508, 0.6018];
			attachPoints["Blowjob"] = new Point(118.4, 91.10000000000001);
			
			depthOffsets["Cowgirl"] = 5;
			SetDepthOffsets(3, "LeanBack", "Swivel", "LeanForward");
			depthOffsets["Paizuri"] = 2;
			SetDepthOffsets(0, "Anal", "ReverseCowgirl");
			SetDepthOffsets(7, "SideRide", "Grind", "Blowjob");
			//depthOffsets["Blowjob"] = 7;
		}
		
	}

}