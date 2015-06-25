package menu {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.events.FocusEvent;
	
	//Very basic slider with a text field for displaying and inputting values.
	//Supports modifiable min/max value and resizing of the slider. Does not support negative numbers
	public class MenuSliderBase extends Sprite
	{
		public var SliderText:TextField;
		public var SliderHandle:MovieClip;
		public var SliderLine:MovieClip;
		
		private var dragging:Boolean = false;
		private var handleWidth:Number;
		private var minimumValue:Number;
		private var maximumValue:Number;
		//private var integralValuesOnly:Boolean = true;
		private var valueStep:Number=1.0;
		private var distanceForValueChange:Number;
		
		
		
		public function MenuSliderBase() 
		{
			handleWidth = SliderHandle.width / this.scaleX;
			//Event listener setup
			addEventListener(MouseEvent.MOUSE_MOVE, MouseMove);
			SliderHandle.addEventListener(MouseEvent.MOUSE_DOWN, MouseDown);
			addEventListener(MouseEvent.MOUSE_UP, MouseUp);
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
				var sliderValue:Number = ((Math.abs(maximumValue) + Math.abs(minimumValue)) / (SliderLine.width - handleWidth)) * SliderHandle.x;
				sliderValue += minimumValue;
				sliderValue = RoundToNearest(sliderValue, valueStep);
				//var sliderValue:Number = (SliderHandle.x * ((SliderLine.width - handleWidth)) / (Math.abs(maximumValue) + Math.abs(minimumValue)));
				/*if (integralValuesOnly)
				{
					sliderValue = Math.round(sliderValue);
				}*/
				SliderText.text = sliderValue.toString();
			}
		}
		
		public function get Value() : Number
		{
			return Number(SliderText.text);
			//return 0.0;
		}
		
		//Lazy approach, needs to check the width of the SliderLine 
		public function set Value(val:Number)
		{
			if (val > maximumValue)
			{
				val = maximumValue;
			}
			else if (val < minimumValue)
			{
				val = minimumValue;
			}
			/*if (integralValuesOnly)
			{
				val = Math.round(val);
			}*/
			
			//SliderHandle.x = ((SliderLine.width - handleWidth) / (Math.abs(maximumValue) + Math.abs(minimumValue))) * val;
			SliderText.text = val.toString();
			MoveHandle();
		}
		public function SetMinValue(min:Number)
		{
			//minimum number can't be higher than the maximum value
			if (min > maximumValue) { return; }
			
			/*if (integralValuesOnly)
			{
				min = Math.round(min);
			}*/
			minimumValue = min;
			RecalculateStepperInterval();
			MoveHandle();
			//SliderHandle.x = ((SliderLine.width - handleWidth) / (Math.abs(maximumValue) + Math.abs(minimumValue))) * Number(SliderText.text);
		}
		
		public function SetMaxValue(max:Number)
		{
			//maximum number can't be lower than the minimum value
			if (max < minimumValue) { return; }
			
			/*if (integralValuesOnly)
			{
				max = Math.round(max);
			}*/
			maximumValue = max;
			RecalculateStepperInterval();
			MoveHandle();
			//SliderHandle.x = ((SliderLine.width - handleWidth) / (Math.abs(maximumValue) + Math.abs(minimumValue))) * Number(SliderText.text);
		}
		private function RecalculateStepperInterval()
		{
			distanceForValueChange =  (SliderLine.width - handleWidth)/ ((maximumValue - minimumValue) /*+ 1*/);
		}
		private function RecalculateHandleWidth()
		{
			handleWidth = SliderHandle.width / this.scaleX;
		}
		private function MoveHandle()
		{
			SliderHandle.x = ((SliderLine.width - handleWidth) / ((maximumValue - minimumValue) /*+ 1*/)) * (Number(SliderText.text) - minimumValue);
			
			
			/*SliderHandle.x = Math.max(0, 
			Math.min(SliderLine.width - handleWidth, globalToLocal(new Point(e.stageX, 0)).x));
			SliderHandle.x = RoundToNearest(SliderHandle.x, handleStepInterval);
			var sliderValue:Number = ((Math.abs(maximumValue) + Math.abs(minimumValue)) / (SliderLine.width - handleWidth)) * SliderHandle.x;
			sliderValue += minimumValue;
			if (integralValuesOnly)
			{
				sliderValue = Math.round(sliderValue);
			}
			SliderText.text = sliderValue.toString();*/
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
			/*else if(SliderText.text.charAt(0) != "-" && SliderText.text.charAt(0) != "")
			{
				//Clear it in case of a non-number
				Value = minimumValue;
			}
			else
			{
				
				
			}*/
		}
		
		private function CheckTextField(e:FocusEvent)
		{
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
		}
		
		public function ChangeValueStep(stepAmount:Number)
		{
			if (stepAmount > 0.0) valueStep = stepAmount;
		}
		
		public function RoundToNearest(value:Number, roundTo:Number) : Number
		{
			return Math.round(value / roundTo) * roundTo;
		}
		
		private function GetTotalSliderSteps():Number
		{
			return (Math.abs(maximumValue) + Math.abs(minimumValue)) / valueStep;
		}
		//below version has better support for negative numbers
		/*private function UpdateHandle(e:Event)
		{
			var valueText:String = SliderText.text;
			var negativeNumber:Boolean = false;
			if (valueText.charAt(0) == "-")
			{
				negativeNumber = true;
				//valueText[0] = '';
			}
			var SliderTextValue:Number = Number(SliderText.text);
			if (!isNaN(SliderTextValue))
			{
				Value = SliderTextValue * (negativeNumber? -1:1);
			}
			else if(!negativeNumber)
			{
				//Clear it in case of a non-number
				Value = minimumValue;
			}
		}*/
	}
}
