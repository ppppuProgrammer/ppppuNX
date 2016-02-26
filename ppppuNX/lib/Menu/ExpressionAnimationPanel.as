package Menu
{
	import com.bit101.components.*;
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
		
		private var templateInUse:MasterTemplate;

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

			mouthSlider = new HUISlider(this, 30, 70, "Mouth select", MouthSelectHandler);
mouthSlider.width = 250;
mouthSlider.tick = 1.0;
mouthSlider.maximum = templateInUse.Mouth.GetExpressionCount();

			propLabel = new Label(this, 110, 100, "Basic Properties");

			XLabel = new Label(this, 20, 120, "X:");

			XInput = new InputText(this, 40, 120, "0");
XInput.width = 32;
XInput.height = 18;
XInput.maxChars = 5;

			YLabel = new Label(this, 110, 120, "Y:");

			scaleXLabel = new Label(this, 190, 120, "ScaleX:");

			scaleYLabel = new Label(this, 0, 150, "ScaleY:");

			skewXLabel = new Label(this, 90, 150, "SkewX:");

			skewYLabel = new Label(this, 190, 150, "SkewY:");

			durationInputText = new InputText(this, 240, 0, "1");
durationInputText.width = 32;
durationInputText.maxChars = 4;

			YInput = new InputText(this, 140, 120, "0");
YInput.width = 32;
YInput.height = 18;
YInput.maxChars = 5;

			scaleXInput = new InputText(this, 240, 120, "100");
scaleXInput.width = 40;
scaleXInput.height = 18;
scaleXInput.maxChars = 5;

			scaleYInput = new InputText(this, 40, 150, "100");
scaleYInput.width = 40;
scaleYInput.height = 18;
scaleYInput.maxChars = 5;

			skewXInput = new InputText(this, 140, 150, "0");
skewXInput.width = 32;
skewXInput.height = 18;
skewXInput.maxChars = 4;

			skewYInput = new InputText(this, 240, 150, "0");
skewYInput.width = 32;
skewYInput.height = 18;
skewYInput.maxChars = 4;

			advPropLabel = new Label(this, 100, 180, "Advanced Properties");

			advancePropertyInput = new Text(this, 20, 200, "");
advancePropertyInput.width = 260;

			addTweenButton = new PushButton(this, 30, 310, "Add/Edit Tween", addTweenHandler);

			removeTweenButton = new PushButton(this, 170, 310, "Remove Tween", removeTweenHandler);

			frameSlider = new HUISlider(this, 10, 340, "Frame", FrameChangeHandler);
frameSlider.width = 280;
frameSlider.maximum = 120;
frameSlider.minimum = 1;
frameSlider.value = 1;
frameSlider.tick = 1.0;

			SaveAnimBtn = new PushButton(this, 20, 370, "Save Expression Animation", SaveAnimHandler);
SaveAnimBtn.width = 140;

			CancelBtn = new PushButton(this, 180, 370, "Cancel", CancelHandler);

		}

		protected function MouthSelectHandler(event:Event):void
		{
			//(event.target as HUISlider).
			templateInUse.Mouth.ChangeExpressionByIndex((event.target as HUISlider).value);
			trace("MouthSelectHandler");
		}

		protected function addTweenHandler(event:Event):void
		{
			trace("addTweenHandler");
		}

		protected function removeTweenHandler(event:Event):void
		{
			trace("removeTweenHandler");
		}

		protected function FrameChangeHandler(event:Event):void
		{
			templateInUse.JumpToFrameAnimation(event.target.value);
			trace("FrameChangeHandler");
		}

		protected function SaveAnimHandler(event:Event):void
		{
			trace("SaveAnimHandler");
		}

		protected function CancelHandler(event:Event):void
		{
			trace("CancelHandler");
		}
	}
}
