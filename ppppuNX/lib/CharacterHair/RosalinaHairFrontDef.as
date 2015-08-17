package CharacterHair 
{
	import flash.geom.Point;
	import ppppu.HairDefinition;
	/**
	 * ...
	 * @author 
	 */
	public class RosalinaHairFrontDef extends HairDefinition
	{
		
		public function RosalinaHairFrontDef() 
		{
			scaleFactors["Cowgirl"] = [.90, 1.01];
			attachPoints["Cowgirl"] = new Point(3.6, -65.75);
			mySprite = new RosalinaHairFront();
			pairedCharacter = "Rosalina";
		}
		
	}

}