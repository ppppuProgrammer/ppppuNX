package ppppu 
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	//import EyeContainer;
	//import MouthContainer;
	/**
	 * ...
	 * @author 
	 */
	public dynamic class TemplateBase extends MovieClip
	{
		/*Master timeline for the template animation. Contains all the timelines for parts of the animation that are 
		 * controlled  by series of tweens defined by a motion xml.*/
		private var masterTimeline:TimelineLite = new TimelineLite( { /*useFrames:true,*/ smoothChildTiming:true } );
		//Master template version this array contains arrays of timelines. To access the index of the appropriate animation, refer to the animationNameIndexes array in ppppuCore.
		private var defaultTimelines:Vector.<Vector.<TimelineMax>> = new Vector.<Vector.<TimelineMax>>();
		
		/*public var EyeL:EyeContainer;
		public var EyeR:EyeContainer;*/
		public var EarringL:EarringContainer;
		public var EarringR:EarringContainer;
		public var Headwear:BaseHeadwear;
		public var Mouth:MouthContainer;
		public var HairBack:HairBackContainer;
		public var HairSideL:BaseHairSide;
		public var HairSideR:BaseHairSide;
		public var HairSide2L:BaseHairSide2;
		public var HairSide2R:BaseHairSide2;
		public var HairSide3L:BaseHairSide3;
		public var HairSide3R:BaseHairSide3;
		public var HairFront:BaseHairFront;
		public var LowerLegL:LowerLegContainer;
		public var LowerLegR:LowerLegContainer;
		public var EarL:MovieClip;
		public var EarR:MovieClip;
		
		private var millisecPerFrame:Number;
		/*public var HairFront:BaseHairFront;*/
		
		public function TemplateBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, StageSetup);
			//SetupEyeContainer(EyeL);
			//SetupEyeContainer(EyeR);
			if (EarL) { EarL.Element.gotoAndStop(1); EarL.Element.Skin.gotoAndStop(1); EarL.Element.Lines.gotoAndStop(1); }
			if(EarR) {EarR.Element.gotoAndStop(1); EarR.Element.Skin.gotoAndStop(1); EarR.Element.Lines.gotoAndStop(1);}
			EarringL.Element.gotoAndStop(1);
			EarringR.Element.gotoAndStop(1);
			Mouth.MouthBase.gotoAndStop(1);
			Mouth.LipsColor.gotoAndStop(1);
			Mouth.LipsHighlight.gotoAndStop(1);
			Mouth.Tongue.Element.gotoAndStop(1);
			Headwear.gotoAndStop(1);
			SetupHair();
			if(LowerLegL) LowerLegL.Element.Color.gotoAndStop(1);
			if(LowerLegR) LowerLegR.Element.Color.gotoAndStop(1);
		}
		private function StageSetup(e:Event)
		{
			millisecPerFrame = 1000.0 / stage.frameRate;
			removeEventListener(Event.ADDED_TO_STAGE, StageSetup);
		}
		private function SetupHair()
		{
			HairBack.Element.gotoAndStop(1);
			HairSideL.gotoAndStop(1);
			HairSideR.gotoAndStop(1);
			HairSide2L.gotoAndStop(1);
			HairSide2R.gotoAndStop(1);
			HairSide3L.gotoAndStop(1);
			HairSide3R.gotoAndStop(1);
			if (HairFront)
			{
				HairFront.gotoAndStop(1);
			}
		}
		
		/*private function SetupEyeContainer(EyeC:EyeContainer)
		{
			EyeC.eye.EyebrowSettings.gotoAndStop(1);
			EyeC.eye.EyebrowSettings.Eyebrow.gotoAndStop(1);
			EyeC.eye.EyelashSettings.gotoAndStop(1);
			EyeC.eye.EyelashSettings.Eyelash.gotoAndStop(1);
			EyeC.eye.EyeMaskSettings.EyeMask.gotoAndStop(1);
			EyeC.eye.EyelidSettings.gotoAndStop(1);
			EyeC.eye.EyelidSettings.Eyelid.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Highlight.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Pupil.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Iris.gotoAndStop(1);
		}*/
		
		//Master template version
		public function SetDefaultTimelines(defTimelines:Vector.<TimelineMax>, animationIndex:uint)
		{
			if (defTimelines.length > 0)
			{
				defaultTimelines[animationIndex] = defTimelines;
			}
		}
		
		/*public function SetDefaultTimelines(defTimelines:Array)
		{
			if (defaultTimelines == null)
			{
				defaultTimelines = defTimelines;
				ResetToDefaultTimelines();
			}
		}*/
		
		/*public function UpdateTimelines(jumpToFrame:uint)
		{
			//var currentFrame:int = this.currentFrame;
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).seek(jumpToFrame);
			}
		}*/
		
		public function PlayAnimation(startAtFrame:uint)
		{
			//startAtFrame -= 1;
			//masterTimeline.play(startAtFrame);
			masterTimeline.play((startAtFrame * millisecPerFrame)/1000.0);
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				//(childTimelines[i] as TimelineLite).play(startAtFrame);
				(childTimelines[i] as TimelineLite).play((startAtFrame * millisecPerFrame)/1000.0 );
				//trace((childTimelines[i] as TimelineLite).vars["useFrames"]);
			}
		}
		
		public function StopAnimation()
		{
			masterTimeline.stop();
			/*var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).stop();
			}*/
		}
		
		/*public function UpdateTimelines()
		{
			var currentFrame:int = this.currentFrame;
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).seek(currentFrame);
			}
		}*/
		
		/*public function AddTimelines(timelines:Array)
		{
			var currentFrame:int = this.currentFrame;
			for (var i:uint = 0, l:uint = timelines.length; i < l; ++i)
			{
				var timeline:Object = timelines[i];
				if (timeline is TimelineLite)
				{
					masterTimeline.add((timeline as TimelineLite).seek(currentFrame));
				}
			}
		}*/
		
		public function ChangeDefaultTimelinesUsed(animationIndex:uint)
		{
			if (animationIndex < defaultTimelines.length)
			{
				masterTimeline.clear();
				AddTimelines(defaultTimelines[animationIndex] as Vector.<TimelineMax>);
			}
		}
		
		/*public function ResetToDefaultTimelines()
		{
			masterTimeline.clear();
			masterTimeline.add(defaultTimelines);
			//UpdateTimelines();
		}*/
		
		public function ClearTimelines()
		{
			masterTimeline.clear();
		}
		
		public function AddTimelines(timelinesToAdd:Vector.<TimelineMax>)
		{
			for (var i:uint = 0, l:uint = timelinesToAdd.length; i < l; ++i)
			{
				AddTimeline(timelinesToAdd[i] as TimelineMax);
			}
		}
		
		public function AddTimeline(tlToAdd:TimelineMax)
		{
			//var timelineForPart:String = tlToAdd.data as String;
			var timelineForPart:String = tlToAdd.data.targetElement.name as String;
			//The display object that the timeline controls
			var timelineDisplayObject:DisplayObject = tlToAdd.data.targetElement as DisplayObject;
			//Make the display object visible
			timelineDisplayObject.visible = true;
			var currentFrame:int = this.currentFrame;
			if (timelineForPart)
			{
				//Check to see if the master timeline already has a nested timeline for the specified display object.
				//If it does, then 
				var childTimelines:Array = masterTimeline.getChildren(true, false);
				var childTlForPart:String;
				var childTimeline:TimelineMax;
				for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
				{
					childTimeline = childTimelines[i] as TimelineMax;
					if (childTimeline)
					{
						childTlForPart = childTimeline.data.targetElement.name as String;
						if (timelineForPart == childTlForPart)
						{
							//Match was found, so replace the match with tlToAdd.
							ReplaceTimeline(childTimeline, tlToAdd);
							return; //Finished, so end early. 
						}
						//TODO Have timelines that are completely new (ie Isabelle's body fur pattern) be added if there were no matches
					}
				}
				//Looked through all the timelines nested in the master timeline and there were no matches for tlToAdd to override.
				masterTimeline.add(tlToAdd);
				//tlToAdd.seek(this.currentFrame);
				tlToAdd.seek((this.currentFrame * millisecPerFrame) / 1000.0);
			}
		}
		
		
		public function ReplaceTimeline(tlToRemove:TimelineMax, tlToAdd:TimelineMax)
		{
			if (tlToRemove != tlToAdd)
			{
				masterTimeline.remove(tlToRemove);
				masterTimeline.add(tlToAdd);
				//tlToAdd.seek(this.currentFrame);
				tlToAdd.seek((this.currentFrame * millisecPerFrame) / 1000.0);
			}
		}
		
		public function GetName():String{return this.name}
		
		/*public function TemplateBase() 
		{
			//EyeL.gotoAndStop(1);
			//EyeR.gotoAndStop(1);
			Mouth.gotoAndStop(1);
		}*/
		
		/*public function OnAnimationRestart()
		{
			EyeL.ResetInitialTransforms();
			EyeR.ResetInitialTransforms();
		}*/
		
	}

}