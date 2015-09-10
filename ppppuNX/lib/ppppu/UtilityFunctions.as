package ppppu 
{
	/**
	 * Holds various static functions that can be useful for various parts of the program. Due to their static nature, the use of
	 * these functions in performance critical code and used within functions called multiple times within a short period is discouraged.
	 * @author 
	 */
	public class UtilityFunctions 
	{
		
		public function UtilityFunctions() 
		{
			
		}
		
		public static function GetColorUintFromRGB(red:uint, green:uint, blue:uint):uint
		{
			var colorValue:uint = 0;
			colorValue += (red << 16) + (green << 8) + blue;
			return colorValue;
		}
		
	}

}