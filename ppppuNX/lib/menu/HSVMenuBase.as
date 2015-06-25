package menu 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author 
	 */
	public class HSVMenuBase extends Sprite
	{
		public var HueSlider:MenuSliderBase;
		public var SaturationSlider:MenuSliderBase;
		public var ValueSlider:MenuSliderBase;
		public var ContrastSlider:MenuSliderBase;
		public function HSVMenuBase() 
		{
			HueSlider.SetMinValue(-180);
			HueSlider.SetMaxValue(180);
			SaturationSlider.SetMinValue(0.0);
			SaturationSlider.SetMaxValue(4.0);
			SaturationSlider.ChangeValueStep(0.1);
			SaturationSlider.Value = 1.0;
			ValueSlider.SetMinValue(0.0);
			ValueSlider.SetMaxValue(4.0);
			ValueSlider.ChangeValueStep(0.1);
			ValueSlider.Value = 1.0;
			ContrastSlider.SetMinValue(0.0);
			ContrastSlider.SetMaxValue(4.0);
			ContrastSlider.ChangeValueStep(0.1);
			ContrastSlider.Value = 1.0;
			
		}
		
	}

}