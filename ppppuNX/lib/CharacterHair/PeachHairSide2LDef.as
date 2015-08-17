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
			
			SetScaleFactors([.7518, .5753], "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			//SetAttachPoints(new Point(-34.975 - 15, 19.25 - 3.5), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			SetAttachPoints(new Point(-30.475*2, -61.15/2), "Cowgirl", "Swivel", "LeanBack", "LeanForward", "Paizuri");
			
			SetScaleFactors([.377, .538], "Anal", "ReverseCowgirl");
			SetAttachPoints(new Point(98.85, 102.8), "Anal", "ReverseCowgirl");
			
			SetScaleFactors([.3059, .552], "SideRide", "Grind");
			SetAttachPoints(new Point(-41.4, 135.25), "SideRide", "Grind");
			
			scaleFactors["Blowjob"] = [.347, .588];
			attachPoints["Blowjob"] = new Point(38.5, 154.5);
		}
		
	}

}