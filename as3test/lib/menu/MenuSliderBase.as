package menu {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	
	//Very basic slider with a text field for displaying and inputting values.
	//Supports modifiable min/max value and resizing of the slider.
	public class MenuSliderBase extends Sprite
	{
		public var SliderText:TextField;
		public var SliderHandle:MovieClip;
		public var SliderLine:MovieClip;
		
		private var dragging:Boolean = false;
		private var handleWidth:Number;
		private var minimumValue:Number;
		private var maximumValue:Number;
		private var valueStep:Number=1.0;
		private var distanceForValueChange:Number;
		
		public function MenuSliderBase() 
		{
			handleWidth = SliderHandle.width / this.scaleX;
			//Event listener setup
			addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			SliderHandle.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			addEventListener(MouseEvent.MOUSE_UP, MouseUp);
			addEventListener(MouseEvent.RELEASE_OUTSIDE, MouseUp);
			addEventListener(Event.RESIZE, RecalculateHandleWidth);
			SliderText.addEventListener(Event.CHANGE, UpdateHandle);
			SliderText.addEventListener(FocusEvent.FOCUS_OUT, CheckTextField);
			SetMaxValue(100);
			SetMinValue(0);
			Value = minimumValue;
			SliderText.restrict = "0-9.\\-";
		}
		
		
		
		public function MouseDown(e:MouseEvent)
		{
			dragging = true;
		}
		
		public function MouseUp(e:MouseEvent)
		{
			dragging = false;
		}
		
		public function MouseMove(e:MouseEvent)
		{
			if (dragging)
			{
				SliderHandle.x = Math.max(0, 
				Math.min(SliderLine.width - handleWidth, globalToLocal(new Point(e.stageX, 0)).x));
				SliderHandle.x = RoundToNearest(SliderHandle.x, distanceForValueChange);
				var sliderValue:Number = (GetTotalSliderSteps() / (SliderLine.width - handleWidth)) * SliderHandle.x;
				sliderValue += minimumValue;
				sliderValue *= valueStep;
				sliderValue = RoundToNearest(sliderValue, valueStep);
				Value = sliderValue;
				//SliderText.text = sliderValue.toString();
				//RemoveRepeatingZeroes();
			}
		}
		
		public function get Value() : Number
		{
			return Number(SliderText.text);
		}
		
		public function set Value(val:Number )
		{
			if (val > maximumValue)
			{
				val = maximumValue;
			}
			else if (val < minimumValue)
			{
				val = minimumValue;
			}

			if (SliderText.text.charAt(SliderText.text.length - 1) == ".")
			{
				SliderText.text = val.toString() + ".";
			}
			else
			{
				SliderText.text = val.toString();
			}
			RemoveRepeatingZeroes();
			MoveHandle();
			var changedValueEvent:Event = new Event(Event.CHANGE, true);
			dispatchEvent(changedValueEvent);
		}
		public function SetMinValue(min:Number)
		{
			//minimum number can't be higher than the maximum value
			if (min > maximumValue) { return; }
			
			minimumValue = min;
			RecalculateStepperInterval();
			MoveHandle();
		}
		
		public function SetMaxValue(max:Number)
		{
			//maximum number can't be lower than the minimum value
			if (max < minimumValue) { return; }
		
			maximumValue = max;
			RecalculateStepperInterval();
			MoveHandle();
		}
		private function RecalculateStepperInterval()
		{
			distanceForValueChange =  (SliderLine.width - handleWidth)/ GetTotalSliderSteps();
		}
		private function RecalculateHandleWidth()
		{
			handleWidth = SliderHandle.width / this.scaleX;
		}
		private function MoveHandle()
		{
			SliderHandle.x = ((SliderLine.width - handleWidth) / ((maximumValue - minimumValue) /*+ 1*/)) * (Number(SliderText.text) - minimumValue);
		}
	
		private function UpdateHandle(e:Event)
		{
			var valueText:String = SliderText.text;
			var SliderTextValue:Number = Number(SliderText.text);
			if (SliderText.text == "" || SliderText.text == "-" || SliderText.text == ".")
			{
				return;
			}
			if (!isNaN(SliderTextValue))
			{
				Value = SliderTextValue;
			}
		}
		
		private function CheckTextField(e:FocusEvent)
		{
			var firstMinusPosition:int = -1;
			var firstDecimalPosition:int = -1;
			for (var i:uint = 0, l:uint = SliderText.text.length; i < l; ++i)
			{
				if (SliderText.text.charAt(i) == "-")
				{
					if (firstMinusPosition == -1) 
					{ 
						firstMinusPosition = i;
					}
					else
					{
						SliderText.text = SliderText.text.substring(0, i) +  SliderText.text.substring(i+1);
						--i;
						l = SliderText.text.length;
					}
				}
				else if (SliderText.text.charAt(i) == ".")
				{
					if (firstDecimalPosition == -1) 
					{ 
						firstDecimalPosition = i;
					}
					else
					{
						SliderText.text = SliderText.text.substring(0, i) +  SliderText.text.substring(i+1);
						--i;
						l = SliderText.text.length;
					}
				}
			}
			
			if (SliderText.text == "" || SliderText.text == "-" || SliderText.text == ".")
			{
				if (0.0 >= minimumValue)
				{
					Value = 0.0;
				}
				else
				{
					Value = minimumValue;
				}
			}
			if (SliderText.text.charAt(SliderText.text.length - 1) == ".")
			{
				SliderText.text = SliderText.text.substr(0, SliderText.text.length - 1);
			}
			var currentValue:Number = Number(SliderText.text);
			currentValue = RoundToNearest(currentValue, valueStep);
			Value = currentValue;
		}
		
		public function ChangeValueStep(stepAmount:Number)
		{
			if (stepAmount > 0.0) valueStep = stepAmount;
			RecalculateStepperInterval();
		}
		
		public function RoundToNearest(value:Number, roundTo:Number) : Number
		{
			return Math.round(value / roundTo) * roundTo;
		}
		
		private function GetTotalSliderSteps():Number
		{
			return (Math.abs(maximumValue) + Math.abs(minimumValue)) / valueStep;
		}
		
		private function RemoveRepeatingZeroes()
		{
			var decimalPosition:int = SliderText.text.indexOf(".");
			if (decimalPosition != -1)
			{
				var lastNonRedundantZeroPosition:int = SliderText.text.lastIndexOf("0");
				if (lastNonRedundantZeroPosition != -1 && lastNonRedundantZeroPosition > decimalPosition)
				{
					while (SliderText.text.charAt(lastNonRedundantZeroPosition) == "0" || SliderText.text.charAt(lastNonRedundantZeroPosition) == ".")
					{
						--lastNonRedundantZeroPosition;
					}
					SliderText.text = SliderText.text.substring(0, lastNonRedundantZeroPosition+1);
				}
			}
		}
	}
}
