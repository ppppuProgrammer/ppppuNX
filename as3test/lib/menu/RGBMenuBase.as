package menu 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class RGBMenuBase extends Sprite
	{
		public var RedSlider:MenuSliderBase;
		public var GreenSlider:MenuSliderBase;
		public var BlueSlider:MenuSliderBase;
		public var AlphaSlider:MenuSliderBase;
		public function RGBMenuBase() 
		{
			RedSlider.SetMaxValue(255);
			GreenSlider.SetMaxValue(255);
			BlueSlider.SetMaxValue(255);
			AlphaSlider.SetMaxValue(255);
			AlphaSlider.Value = 255;
		}
		
	}

}