package Menu
{
	import com.bit101.components.*;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;

	//[SWF(backgroundColor=0xeeeeee, width=300, height=400)]
	public class ExpressionAnimationPanel extends Sprite
	{
		private var frameLabel:Label;
		private var editingFrame:Text;
		private var totalFrames:Text;
		private var myLabel:Label;
		private var testAnimationButton:PushButton;
		private var durationLabel:Label;
		private var mouthSliderLabel:Label;
		private var mouthSlider:Slider;
		private var mouthSliderValueLabel:Label;
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
		private var editTweenButton:PushButton;
		private var removeTweenButton:PushButton;
		private var frameSlider:HUISlider;
		private var SaveAnimBtn:PushButton;
		private var CancelBtn:PushButton;
		private var tweenListLabel:Label;
		private var tweenList:List;
		private var templateInUse:MasterTemplate;

		private var timelineWorkingOn:TimelineMax;
		
		//The string used to identify the initial tween, which is a 0 duration tween that starts at time 0 and has specific properties that are not to be modified
		private const InitialTweenName:String = "Start Frame";
		
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

			testAnimationButton = new PushButton(this, 280, 0, "Play"/*, TestPlayAnimation*/);
			
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

			mouthSliderLabel = new Label(this, 10, 40, "Mouth Select");
			
			mouthSlider = new Slider(Slider.HORIZONTAL, this, 75, 45, MouthSelectHandler);
mouthSlider.width = 230;
mouthSlider.tick = 1.0;
mouthSlider.maximum = templateInUse.Mouth.GetExpressionCount() -1;
mouthSlider.minimum = -1;
mouthSlider.value = -1;


			mouthSliderValueLabel = new Label(this, 310, 40, "None");

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

			scaleXLabel = new Label(this, 130, 80, "ScaleX %:");

			scaleXInput = new InputText(this, 170, 80, "100", CalculateMatrix);
scaleXInput.width = 40;
scaleXInput.height = 18;
scaleXInput.maxChars = 5;

			scaleYLabel = new Label(this, 220, 80, "ScaleY %:");

			scaleYInput = new InputText(this, 260, 80, "100", CalculateMatrix);
scaleYInput.width = 40;
scaleYInput.height = 18;
scaleYInput.maxChars = 5;

			skewXLabel = new Label(this, 310, 80, "SkewX:");

			skewXInput = new InputText(this, 350, 80, "0", CalculateMatrix);
skewXInput.width = 32;
skewXInput.height = 18;
skewXInput.maxChars = 4;

			skewYLabel = new Label(this, 390, 80, "SkewY:");

			skewYInput = new InputText(this, 430, 80, "0", CalculateMatrix);
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
			tweenList.addEventListener(Event.SELECT, ShowSelectedTweenData);
			//tweenList.listItemHeight = 10;

			addTweenButton = new PushButton(this, 350, 220, "Add New Tween", AddTweenHandler);
			editTweenButton = new PushButton(this, 350, 250, "Edit Selected Tween", EditSelectedTweenHandler);
			removeTweenButton = new PushButton(this, 350, 280, "Remove Tween", RemoveTweenHandler);

			

			SaveAnimBtn = new PushButton(this, 50, 320, "Save Expression Animation", SaveAnimHandler);
SaveAnimBtn.width = 140;

			CancelBtn = new PushButton(this, 300, 320, "Cancel", CancelHandler);

		}

		public function SetupPanel(timeline:TimelineMax=null):void
		{
			templateInUse.StopAnimation();
			templateInUse.JumpToFrameAnimation(1);
			
			frameSlider.value = 1;
			mouthSlider.value = 0;
			mouthSlider.dispatchEvent(new Event(Event.CHANGE));
			if (!timeline)
			{
				timelineWorkingOn = new TimelineMax( { useFrames:true, paused:true,repeat: -1  } );
				tweenList.removeAll();
				
				var firstTween:TweenMax = TweenMax.set(templateInUse.Mouth.ExpressionContainer, SetupTweenVariableObject());
				timelineWorkingOn.add(firstTween);
				tweenList.addItem(CreateTweenListItem(firstTween));
				//mouthSlider.value = 0;
			}
			else
			{
				timelineWorkingOn = timeline;
				if (timelineWorkingOn.getTweensOf(templateInUse.Mouth.ExpressionContainer).length == 0)
				{
					var firstTween:TweenMax = TweenMax.set(templateInUse.Mouth.ExpressionContainer, SetupTweenVariableObject());
					timelineWorkingOn.add(firstTween);
				}
				CreateTweenListFromTimeline(timeline);
			}
		}
		protected function MouthSelectHandler(event:Event):void
		{
			//(event.target as HUISlider).
			var sliderValue:int = (event.target as Slider).value;
			var mouthName:String =  sliderValue >= 0 ?  templateInUse.Mouth.ExpressionSpriteContainer[sliderValue].name : "None";
			mouthSliderValueLabel.text = mouthName;
			templateInUse.Mouth.ChangeExpressionByIndex(sliderValue);
			//trace("MouthSelectHandler");
		}

		protected function AddTweenHandler(event:Event):void
		{
			var frameStart:Number = frameSlider.value;
			var durationLength:int = parseInt(durationInputText.text);
			var mouthName:String = mouthSliderValueLabel.text;
			//var tweenForFrame:TweenMax = 
			var tweenForFrame:TweenMax = TweenMax.to(templateInUse.Mouth.ExpressionContainer, durationLength, { useFrames:true/*,  
			startAt:{onComplete: templateInUse.ChangeMouthExpression, onCompleteParams:[mouthName],
			onUpdate: templateInUse.ChangeMouthExpression, onUpdateParams:[mouthName],
			onStart: templateInUse.ChangeMouthExpression, onStartParams:[mouthName]}*/
			});
			
			tweenForFrame.vars = SetupTweenVariableObject(tweenForFrame.vars);
			timelineWorkingOn.add(tweenForFrame, frameStart);
			tweenList.addItem(CreateTweenListItem(tweenForFrame));
			
//			timelineWorkingOn.to(templateInUse.Mouth.ExpressionContainer, durationLength, tweenForFrame.vars, frameStart);
			
			//trace("addTweenHandler");
		}
		
		protected function EditSelectedTweenHandler(event:Event):void
		{
			if (tweenList.selectedItem == null) { return;}

			var frameStart:int = frameSlider.value;
			var durationLength:int = parseInt(durationInputText.text);
			
			var selectedItem:Object = tweenList.selectedItem;
			var tween:TweenMax = (selectedItem.tween as TweenMax);
			
			selectedItem.tween.vars = SetupTweenVariableObject(selectedItem.tween.vars);
			//The Start Frame's duration and start time are not to be changed, so check that it's not the edit target.
			if (selectedItem.label != InitialTweenName)
			{
				tween.startTime(frameStart);
				tween.duration(durationLength);
				selectedItem.tween.vars = SetupTweenVariableObject(selectedItem.tween.vars);
				var selectedIndex:int = tweenList.selectedIndex;
				tweenList.removeItemAt(selectedIndex);
				tweenList.addItemAt(CreateTweenListItem(selectedItem.tween), selectedIndex);
			}
		}
		
		private function SetupTweenVariableObject(vars:Object=null):Object
		{
			
			var mouthName:String = mouthSliderValueLabel.text;
			var tweenVariables:Object = vars ? vars : new Object;//test if vars exist, if it doesn't, create a new object and assign it to tween variables
			//tweenVariables.onUpdateParams = [mouthName];
			tweenVariables.onStart =  templateInUse.ChangeMouthExpression;
			tweenVariables.onStartParams = [mouthName];
			/*tweenVariables.startAt = {onComplete: templateInUse.ChangeMouthExpression, onCompleteParams:[mouthName],
			onUpdate: templateInUse.ChangeMouthExpression, onUpdateParams:[mouthName],
			onStart: templateInUse.ChangeMouthExpression, onStartParams:[mouthName]};*/
			//Test the condition of text containing an equal character. If an equal is found, then the user
			//wants to do relative positioning, so use the original string typed variable. Otherwise, convert it to a Number.
			//tweenVariables.x = (XInput.text.indexOf("=") == -1) ? parseFloat(XInput.text) : XInput.text;
			//tweenVariables.y = (YInput.text.indexOf("=") == -1) ? parseFloat(YInput.text) : YInput.text;
			//tweenForFrame.vars.scaleX = parseFloat(scaleXInput.text)/100.0;
			//tweenForFrame.vars.scaleY = parseFloat(scaleYInput.text)/100.0;
			//CalculateMatrix(null);
			//var mouthMatrix:Matrix = templateInUse.Mouth.ExpressionContainer.transform.matrix;
			
			tweenVariables.transformMatrix = 
			{x: (XInput.text.indexOf("=") == -1) ? parseFloat(XInput.text) : XInput.text,
			y: (YInput.text.indexOf("=") == -1) ? parseFloat(YInput.text) : YInput.text,
			scaleX: parseFloat(scaleXInput.text)/100.0,
			scaleY: parseFloat(scaleYInput.text)/100.0,
			skewX: parseFloat(skewXInput.text),
			skewY: parseFloat(skewXInput.text)
				
			};
			//tweenVariables.transformMatrix = { a: mouthMatrix.a, b:mouthMatrix.b, c:mouthMatrix.c, d:mouthMatrix.d/*, tx:mouthMatrix.tx, ty: mouthMatrix.ty*/};
			return tweenVariables;
		}
		
		protected function RemoveTweenHandler(event:Event):void
		{
			//Removes the selected tween from the timeline
			var selectedItem:Object = tweenList.selectedItem;
			timelineWorkingOn.remove((selectedItem.tween as TweenMax));
			tweenList.removeItem(selectedItem);
			//trace("removeTweenHandler");
		}

		protected function FrameChangeHandler(event:Event):void
		{
			var frame:Number = event.target.value;
			templateInUse.JumpToFrameAnimation(frame-1);
			editingFrame.text = frame.toString();
			timelineWorkingOn.seek(frame, false);
			//trace("FrameChangeHandler");
		}

		protected function SaveAnimHandler(event:Event):void
		{
			//Quickly allow the timeline to play to calculate duration then stop it;
			//timelineWorkingOn.play();
			//timelineWorkingOn.pause();
			if (timelineWorkingOn.duration() != 120)
			{
				trace("Woah, the sum duration of all tweens needs to be 120");
			}
			trace("SaveAnimHandler");
		}

		protected function CancelHandler(event:Event):void
		{
			trace("CancelHandler");
		}
		
		protected function ScaleHandler(event:Event):void
		{
			templateInUse.Mouth.ExpressionContainer.scaleX = parseFloat(scaleXInput.text) / 100.0;
			templateInUse.Mouth.ExpressionContainer.scaleY = parseFloat(scaleYInput.text) / 100.0;
		}
		
		protected function CalculateMatrix(event:Event):void
		{
			var DegToRad:Number = (Math.PI / 180.0);
			//To handle skew, the use of a matrix is necessary.
			var matrix:Matrix = new Matrix();
			//var mouthX:Number = parseFloat(XInput.text);
			//var mouthY:Number = parseFloat(YInput.text);
			var mouthScaleX:Number = parseFloat(scaleXInput.text) / 100.0;
			var mouthScaleY:Number = parseFloat(scaleYInput.text) / 100.0;
			var mouthSkewX:Number = parseFloat(skewXInput.text);
			var mouthSkewY:Number = parseFloat(skewYInput.text);
			if (isNaN(mouthSkewX)) { mouthSkewX = 0; skewXInput.text = "0"; }
			if (isNaN(mouthSkewY)) { mouthSkewY = 0; skewYInput.text = "0"; }
			
			//Calculate scale x
			var skewYRad:Number = Math.atan2(matrix.b, matrix.a);
			matrix.a = Math.cos(skewYRad) * mouthScaleX;
			matrix.b = Math.sin(skewYRad) * mouthScaleX;
			
			//calculate scale y
			var skewXRad:Number = Math.atan2( -matrix.c, matrix.d);
			matrix.c = -Math.sin(skewXRad) * mouthScaleY;
			matrix.d = Math.cos(skewXRad) * mouthScaleY;
			
			//calculate skew x / rotation
			var skewXRadians:Number = mouthSkewX * DegToRad;
			mouthScaleY = Math.sqrt(matrix.c*matrix.c + matrix.d*matrix.d);
			matrix.c = -mouthScaleY * Math.sin(skewXRadians);
			matrix.d =  mouthScaleY * Math.cos(skewXRadians);
			
			//calculate skew y / rotation
			var skewYRadians:Number = mouthSkewY * DegToRad;
			mouthScaleX = Math.sqrt(matrix.a*matrix.a + matrix.b*matrix.b);
			matrix.a = mouthScaleX * Math.cos(skewYRadians);
			matrix.b = mouthScaleX * Math.sin(skewYRadians);
			
			//matrix.tx = mouthX; matrix.ty = mouthY;
			
			templateInUse.Mouth.ExpressionContainer.transform.matrix = matrix;
		}
		
		private function CreateTweenListItem(inTween:TweenMax):Object
		{
			var frameStart:int = inTween.startTime();
			var durationLength:int = inTween.duration();
			var listObjName:String;
			if (frameStart == 0)
			{
				listObjName = InitialTweenName;
			}
			else
			{
				listObjName = "Frames:" + frameStart + (durationLength == 1 ? "" : "-" +  (frameStart + durationLength - 1).toString());
			}
			//Create a list object to add to the list of tweens.
			var listObj:Object = { label:listObjName, tween:inTween };
			return listObj;
			//tweenList.addItem(listObj);
		}
		
		private function CreateTweenListFromTimeline(timeline:TimelineMax):void
		{
			var allTweens:Array = timeline.getChildren(false, true, false);
			for (var i:int = 0, l:int = allTweens.length; i < l; ++i)
			{
				tweenList.addItem(CreateTweenListItem(allTweens[i]));
			}
			
		}
		
		protected function ShowSelectedTweenData(e:Event):void
		{
			var selectedItem:Object = List(e.target).selectedItem;
			if (selectedItem)
			{
				var tween:TweenMax = selectedItem.tween;
				frameSlider.value = tween.startTime();
				frameSlider.dispatchEvent(new Event(Event.CHANGE));
				durationInputText.text = (tween.duration()).toString();
				
				//Variables
				var tweenVars:Object = tween.vars;
				mouthSlider.value = templateInUse.Mouth.ExpressionIndexLookupDict[tweenVars.onStartParams[0]]; 
				mouthSlider.dispatchEvent(new Event(Event.CHANGE));
				if (tweenVars["x"]) { XInput.text = String(tweenVars.x); }else { XInput.text = "0";}
				if (tweenVars["y"]) { YInput.text = String(tweenVars.y); }else { YInput.text = "0";}
				if (tweenVars["scaleX"]) 
				{ scaleXInput.text = String(tweenVars.scaleX * 100.0); } 
				else { scaleXInput.text = "100"; scaleXInput.dispatchEvent(new Event(Event.CHANGE)); }
				
				if (tweenVars["scaleY"]) 
				{ scaleYInput.text = String(tweenVars.scaleY * 100.0); } 
				else { scaleYInput.text = "100"; scaleYInput.dispatchEvent(new Event(Event.CHANGE)); }	
				
				
			}
		}
		
		protected function TestPlayAnimation(e:Event):void
		{
			//templateInUse.seek(0);
			//timelineWorkingOn.seek(0);
			templateInUse.PlayAnimation(0);
			timelineWorkingOn.play(0, false);
		}
		
		/*private function Helper_CreateTweenIndicatorForSlider():Sprite
		{
			var circle:Sprite = new Sprite();
			//circle.graphics.lineStyle(null, 0x0000FF);
			circle.graphics.beginFill(0x0000FF);
			circle.graphics.drawCircle(0, 0, frameSlider.height * .8);
			return circle;
		}*/
	}
}
