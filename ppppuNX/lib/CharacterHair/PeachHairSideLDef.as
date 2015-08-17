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
			//mySprite = new PeachHairSide();
			SetSprite(new PeachHairSide());
			SetInitialMatrix(13.6, -166.4);
			
			pairedCharacter = "Peach";
			
			SetScaleFactors([.505, .61], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			//SetAttachPoints(new Point(-34.975 - 15, 19.25 - 3.5), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(-34.975 - 15, 19.25), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [.347, .588];
			attachPoints["Blowjob"] = new Point(38.5, 154.5);
			
		}
		
	}

}