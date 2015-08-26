package CharacterHair 
{
	import ppppu.HairDefinition;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class PeachHairSide3RDef extends HairDefinition 
	{
		
		public function PeachHairSide3RDef() 
		{
			super();
			//mySprite = new PeachHairSide3();
			SetSprite(new PeachHairSide3());
			SetInitialMatrix(-10.2, 169.8);
			pairedCharacter = "Peach";
			
			SetScaleFactors([1.035, .6165], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			//SetAttachPoints(new Point(-34.975 - 15, 19.25 - 3.5), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(43.45, -54.95-4), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [.347, .588];
			attachPoints["Blowjob"] = new Point(38.5, 154.5);
			
			depthOffsets["Cowgirl"] = -4;
		}
		
	}

}