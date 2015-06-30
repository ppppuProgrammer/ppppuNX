package ui 
{
	import com.bit101.components.InputText;
	import com.bit101.components.Slider;
	import flash.display.Sprite;
	import flash.events.Event;

	public class EditSlider extends Sprite
	{
		private var sliderWidth:uint;
		private var sliderHeight:uint;
		
		private var sliderMin:Number;
		private var sliderMax:Number;
		private var sliderValue:Number;
		
		private var textWidth:uint;
		
		private const sliderSpacing:uint = 4;
		private const textSpacing:uint = 4;
		
		private var slider:Slider;
		private var inputText:InputText;
		
		
		public function EditSlider(_sliderWidth:Number, _sliderHeight:Number, _textWidth:Number, _sliderMin:Number, _sliderMax:Number, _tickRate:Number, _sliderValue:Number) 
		{
			sliderMin = _sliderMin;
			sliderMax = _sliderMax;
			sliderValue = _sliderValue;
			
			sliderWidth = _sliderWidth;
			sliderHeight = _sliderHeight;
			
			textWidth = _textWidth;
			
			sliderWidth = sliderWidth - textWidth - sliderSpacing;
			
			slider = new Slider(Slider.HORIZONTAL, this, 0, 0, sliderHandler);
			slider.setSize(sliderWidth, sliderHeight);
			slider.setSliderParams(sliderMin, sliderMax, sliderValue);
			slider.tick = _tickRate;
			
			inputText = new InputText(this, sliderWidth + textSpacing, 0, value.toString(), textHandler);
			inputText.setSize(textWidth, sliderHeight);
		}
		
		private function sliderHandler(event:Event):void 
		{
			inputText.text = slider.value.toString();
			notifyChanged();
		}
		
		private function textHandler(event:Event):void 
		{
			event.stopImmediatePropagation();
			value = int(inputText.text);
			notifyChanged();
		}
		
		private function notifyChanged() : void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value() : Number
		{
			return slider.value;
		}
		
		public function set value(r:Number) : void
		{
			var v:Number = Math.min(sliderMax, Math.max(sliderMin, r));
			if (Number(inputText.text) != v) inputText.text = v.toString();
			slider.value = v;
		}
		
		public function get input() : InputText
		{
			return inputText;
		}
		
		public function set format(f:Function) : void
		{
			inputText.format = f;
		}
	}

}