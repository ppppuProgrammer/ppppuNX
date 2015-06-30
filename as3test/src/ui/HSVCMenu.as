package ui 
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.bit101.components.InputText;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	
	public class HSVCMenu extends Sprite
	{
		private var labels:Vector.<Label> = new Vector.<Label> ();
		private var labelStrings:Vector.<String> = new < String > ["H", "S", "V", "C"];
		private const labelWidth:uint = 15;
		
		private var sliders:Vector.<ui.EditSlider> = new Vector.<ui.EditSlider> ();
		private var reset:PushButton = null;
		
		
		private var sliderRangesMin:Vector.<Number> = new <Number>[-180, 0, 0, 0];
		private var sliderRangesMax:Vector.<Number> = new <Number>[180, 4, 4, 4];
		private var sliderRangesValue:Vector.<Number> = new <Number>[0, 1, 1, 1];
		private var sliderRangesTick:Vector.<Number> = new <Number>[1, .1, .1, .1];
		
		private const sliderWidth:uint = 100;
		private const sliderHeight:uint = 20;
		private const sliderSpacing:uint = 4;
		
		private const textWidth:uint = 30;
		
		private const titleHeight:uint = 22;
		
		public function HSVCMenu(title:String = "") 
		{
			new Label(this, 0, 0, title);
			for (var i:int = 0; i < 4; i++)
			{
				var yOffset:uint = titleHeight + i * (sliderHeight + sliderSpacing)
				var l:Label = new Label(this, 0, yOffset, labelStrings[i] + ":");
				var es:ui.EditSlider = new ui.EditSlider(sliderWidth, sliderHeight, textWidth, sliderRangesMin[i], sliderRangesMax[i], sliderRangesTick[i], sliderRangesValue[i]);
				sliders.push(es);
				addChild(es);
				es.x = labelWidth;
				es.y = yOffset;
				es.addEventListener(Event.CHANGE, handler);
			}
			reset = new PushButton(this, sliderWidth + labelWidth - sliderHeight, 0, "X", handleReset);
			reset.setSize(sliderHeight, sliderHeight);
		}
		
		private function handleReset(e:Event):void 
		{
			for (var i:int = 0; i < sliders.length; i++)
				sliders[i].value = sliderRangesValue[i];
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function round(i:String) : String
		{
			return i.substring(0, 3);
		}
		
		private function handler(e:Event):void 
		{
			if (e.eventPhase != EventPhase.AT_TARGET) return;
			var es:ui.EditSlider = e.target as ui.EditSlider;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get H():uint
		{
			return sliders[labelStrings.indexOf("H")].value;
		}
		
		public function get S():Number
		{
			return sliders[labelStrings.indexOf("S")].value;
		}
		
		public function get V():Number
		{
			return sliders[labelStrings.indexOf("V")].value;
		}
		
		public function get C():Number
		{
			return sliders[labelStrings.indexOf("C")].value;
		}
	}
}