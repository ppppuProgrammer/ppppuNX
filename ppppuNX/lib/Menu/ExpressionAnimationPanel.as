package Menu
{
	import com.bit101.components.*;
	import com.greensock.TimelineMax;
	import flash.display.Sprite;
	import flash.events.Event;

	//[SWF(backgroundColor=0xeeeeee, width=300, height=400)]
	public class ExpressionAnimationPanel extends Sprite
	{
		private var frameLabel:Label;
		private var editingFrame:Text;
		private var totalFrames:Text;
		private var myLabel:Label;
		private var durationLabel:Label;
		private var mouthSlider:HUISlider;
		private var propLabel:Label;
		private var XLabel:Label;
		private var XInput:InputText;
		private var YLabel:Label;
		private var scaleXLabel:Label;
		private var scaleYLabel:Label;
		private var skewXLabel:Label;
		private var skewYLabel:Label;
		private var durationInputText:InputText;
		private var YInput:InputText;
		private var scaleXInput:InputText;
		private var scaleYInput:InputText;
		private var skewXInput:InputText;
		private var skewYInput:InputText;
		private var advPropLabel:Label;
		private var advancePropertyInput:Text;
		private var addTweenButton:PushButton;
		private var removeTweenButton:PushButton;
		private var frameSlider:HUISlider;
		private var SaveAnimBtn:PushButton;
		private var CancelBtn:PushButton;
		private var tweenListLabel:Label;
		private var tweenList:List;
		private var templateInUse:MasterTemplate;

		private var timelineWorkingOn:TimelineMax;
		public function ExpressionAnimationPanel(template:MasterTemplate)
		{
			templateInUse = template;
			
			frameLabel = new Label(this, 30, 0, "Frame");

			editingFrame = new Text(this, 70, 0, "1");
editingFrame.width = 32;
editingFrame.height = 18;
editingFrame.editable = false;

			totalFrames = new Text(this, 130, 0, "120");
totalFrames.width = 32;
totalFrames.height = 18;
totalFrames.editable = false;

			myLabel = new Label(this, 110, 0, "/");

			durationLabel = new Label(this, 190, 0, "Duration:");

			durationInputText = new InputText(this, 240, 0, "1");
durationInputText.width = 32;
durationInputText.maxChars = 4;

frameSlider = new HUISlider(this, 10, 20, "Frame Select", FrameChangeHandler);
frameSlider.width = 400;
frameSlider.maximum = 120;
frameSlider.minimum = 1;
frameSlider.value = 1;
frameSlider.tick = 1.0;

			mouthSlider = new HUISlider(this, 30, 40, "Mouth Select", MouthSelectHandler);
mouthSlider.width = 375;
mouthSlider.tick = 1.0;
mouthSlider.maximum = templateInUse.Mouth.GetExpressionCount() -1;
mouthSlider.minimum = -1;
mouthSlider.value = -1;

			propLabel = new Label(this, 110, 60, "Basic Properties");

			XLabel = new Label(this, 10, 80, "X:");

			XInput = new InputText(this, 30, 80, "0");
XInput.width = 32;
XInput.height = 18;
XInput.maxChars = 5;

			YLabel = new Label(this, 70, 80, "Y:");

			YInput = new InputText(this, 90, 80, "0");
YInput.width = 32;
YInput.height = 18;
YInput.maxChars = 5;

			scaleXLabel = new Label(this, 130, 80, "ScaleX:");

			scaleXInput = new InputText(this, 170, 80, "100");
scaleXInput.width = 40;
scaleXInput.height = 18;
scaleXInput.maxChars = 5;

			scaleYLabel = new Label(this, 220, 80, "ScaleY:");

			scaleYInput = new InputText(this, 260, 80, "100");
scaleYInput.width = 40;
scaleYInput.height = 18;
scaleYInput.maxChars = 5;

			skewXLabel = new Label(this, 310, 80, "SkewX:");

			skewXInput = new InputText(this, 350, 80, "0");
skewXInput.width = 32;
skewXInput.height = 18;
skewXInput.maxChars = 4;

			skewYLabel = new Label(this, 390, 80, "SkewY:");

			skewYInput = new InputText(this, 430, 80, "0");
skewYInput.width = 32;
skewYInput.height = 18;
skewYInput.maxChars = 4;

			advPropLabel = new Label(this, 100, 110, "Advanced Properties");

			advancePropertyInput = new Text(this, 20, 130, "");
advancePropertyInput.width = 400; advancePropertyInput.height = 60;

			tweenListLabel = new Label(this, 10, 200, "Tween List");

			tweenList = new List(this, 10, 220);
			tweenList.width = 300;
			tweenList.height = 80;
			tweenList.listItemHeight = 10;

			addTweenButton = new PushButton(this, 350, 230, "Add/Edit Tween", addTweenHandler);
			
			removeTweenButton = new PushButton(this, 350, 270, "Remove Tween", removeTweenHandler);

			

			SaveAnimBtn = new PushButton(this, 50, 320, "Save Expression Animation", SaveAnimHandler);
SaveAnimBtn.width = 140;

			CancelBtn = new PushButton(this, 300, 320, "Cancel", CancelHandler);

		}

		public function SetupPanel(timeline:TimelineMax=null):void
		{
			if (!timeline)
			{
				timelineWorkingOn = new TimelineMax( { useFrames:true} );
			}
			else
			{timelineWorkingOn = timeline; }
		}
		protected function MouthSelectHandler(event:Event):void
		{
			//(event.target as HUISlider).
			templateInUse.Mouth.ChangeExpressionByIndex((event.target as HUISlider).value);
			trace("MouthSelectHandler");
		}

		protected function addTweenHandler(event:Event):void
		{
			var frameStart:int = frameSlider.value;
			var durationLength:int = parseInt(durationInputText.text);
			timelineWorkingOn.to(templateInUse.Mouth.ExpressionContainer, durationLength, { useFrames:true }, frameStart);
			var listObjName:String = "Frames:" + frameStart + (durationLength == 1 ? "" : "-" +  (frameStart + durationLength - 1).toString());
			//Try to modify frame slider to indicate that a tween is present.
			var listObj:Object = { label:listObjName};
			tweenList.addItem(listObj);
			trace("addTweenHandler");
		}

		protected function removeTweenHandler(event:Event):void
		{
			trace("removeTweenHandler");
		}

		protected function FrameChangeHandler(event:Event):void
		{
			templateInUse.JumpToFrameAnimation(event.target.value);
			editingFrame.text = event.target.value.toString();
			//trace("FrameChangeHandler");
		}

		protected function SaveAnimHandler(event:Event):void
		{
			trace("SaveAnimHandler");
		}

		protected function CancelHandler(event:Event):void
		{
			trace("CancelHandler");
		}
		
		private function Helper_CreateTweenIndicatorForSlider():Sprite
		{
			var circle:Sprite = new Sprite();
			//circle.graphics.lineStyle(null, 0x0000FF);
			circle.graphics.beginFill(0x0000FF);
			circle.graphics.drawCircle(0, 0, frameSlider.height * .8);
			return circle;
		}
	}
}
