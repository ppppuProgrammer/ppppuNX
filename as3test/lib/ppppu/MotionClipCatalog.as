package ppppu 
{
	/**
	 * Holds references to all motion clips (movie clips for a part of an animation, like a character's right arm) 
	 * @author 
	 */
	public class MotionClipCatalog 
	{
		private var motionPartNames:Vector.<String> = new Vector.<String>();
		public function MotionClipCatalog() 
		{
			motionPartNames.push("EarringR", "EarringL", "Headwear", "HeadwearAlt", "HairSideL", "HairSide2L", "HairSide3L", "HairSideR", "HairSide2R", 
		"HairSide3R", "HairFront", "HairBack", "EyeL", "EyeR", "EyebrowL", "EyebrowR", "Mouth", "ArmR", "ForearmR", "HandR", "EyelidR");
		}
		
	}

}