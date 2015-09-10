package ui 
{
	import com.bit101.components.Label;
	import com.bit101.components.Slider;
	import com.bit101.components.InputText;
	import com.bit101.components.ColorChooser;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.geom.ColorTransform;
	import ui.EditSlider;
	
	public class RGBAMenu extends Sprite
	{
		private var labels:Vector.<Label> = new Vector.<Label> ();
		private var labelStrings:Vector.<String> = new < String > ["R", "G", "B", "A"];
		private const labelWidth:uint = 15;
		
		private var sliders:Vector.<ui.EditSlider> = new Vector.<ui.EditSlider> ();
		
		private var sliderRangesMin:Vector.<Number> = new <Number>[0, 0, 0, 0];
		private var sliderRangesMax:Vector.<Number> = new <Number>[255, 255, 255, 255];
		private var sliderRangesValue:Vector.<Number> = new <Number>[0, 0, 0, 255];
		private var sliderRangesTick:Vector.<Number> = new <Number>[1, 1, 1, 1];
		
		private const sliderWidth:uint = 130;
		private const sliderHeight:uint = 20;
		private const sliderSpacing:uint = 4;
		
		private const textWidth:uint = 30;
		
		private const titleHeight:uint = 22;
		
		private var cc:ColorChooser;
		
		public function RGBAMenu(title:String = "") 
		{
			var _title:Label = new Label(this, 0, 0, title);
			
			for (var i:int = 0; i < 4; i++)
			{
				name = title;
				var yOffset:uint = titleHeight + i * (sliderHeight + sliderSpacing)
				var l:Label = new Label(this, 0, yOffset, labelStrings[i] + ":");
				var es:ui.EditSlider = new ui.EditSlider(sliderWidth, sliderHeight, textWidth, sliderRangesMin[i], sliderRangesMax[i], sliderRangesTick[i], sliderRangesValue[i]);
				sliders.push(es);
				addChild(es);
				es.x = labelWidth;
				es.y = yOffset;
				es.addEventListener(Event.CHANGE, handler);
			}
			cc = new ColorChooser(this, (labelWidth + sliderWidth - 65)/2, 0, 0xFFFFFF, handleColor);

			cc.usePopup = true;
			cc.value = ( ( R << 16 ) | ( G << 8 ) | B );
		}
		
		private function handleColor(e:Event):void 
		{
			sliders[0].value = ( cc.value >> 16 ) & 0xFF;
			sliders[1].value = ( cc.value >> 8 ) & 0xFF;
			sliders[2].value = cc.value & 0xFF;
			sliders[3].value = 255;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function handler(e:Event):void 
		{
			if (e.eventPhase != EventPhase.AT_TARGET) return;
			var es:ui.EditSlider = e.target as ui.EditSlider;
			
			cc.value = ( ( R << 16 ) | ( G << 8 ) | B );
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get R():uint
		{
			return sliders[labelStrings.indexOf("R")].value;
		}
		
		public function get G():uint
		{
			return sliders[labelStrings.indexOf("G")].value;
		}
		
		public function get B():uint
		{
			return sliders[labelStrings.indexOf("B")].value;
		}
		
		public function get A():uint
		{
			return sliders[labelStrings.indexOf("A")].value;
		}
		
		public function setValue(ct:ColorTransform) : void
		{
			sliders[0].value = ct.redOffset;
			sliders[1].value = ct.greenOffset;
			sliders[2].value = ct.blueOffset;
			sliders[3].value = ct.alphaOffset;
			cc.value = ct.color;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function setValueFromUint(color:uint) : void
		{
			sliders[0].value = ( color >> 16 ) & 0xFF;
			sliders[1].value = ( color >> 8 ) & 0xFF;
			sliders[2].value = color & 0xFF;
			sliders[3].value = 255;
			cc.value = color;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}