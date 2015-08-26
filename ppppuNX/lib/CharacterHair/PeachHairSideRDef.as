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
			
			SetScaleFactors([.505, .61], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(34.975 + 13, 19.25), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [.347, .588];
			attachPoints["Blowjob"] = new Point(38.5, 154.5);
			
			depthOffsets["Cowgirl"] = 5;
		}
		
	}

}