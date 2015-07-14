package ppppu 
{
	//import com.greensock.TimelineLite;
	import com.greensock.TimelineLite;
	import flash.display.MovieClip;
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
		private var masterTimeline:TimelineLite = new TimelineLite( { useFrames:true, smoothChildTiming:true } );
		private var defaultTimelines:Array = null;
		
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
		public var EarL:MovieClip;
		public var EarR:MovieClip;
		/*public var HairFront:BaseHairFront;*/
		
		public function TemplateBase()
		{
			//SetupEyeContainer(EyeL);
			//SetupEyeContainer(EyeR);
			if (EarL) { EarL.Ear.gotoAndStop(1); EarL.Ear.Skin.gotoAndStop(1); EarL.Ear.Lines.gotoAndStop(1); }
			if(EarR) {EarR.Ear.gotoAndStop(1); EarR.Ear.Skin.gotoAndStop(1); EarR.Ear.Lines.gotoAndStop(1);}
			EarringL.Earring.gotoAndStop(1);
			EarringR.Earring.gotoAndStop(1);
			Mouth.MouthBase.gotoAndStop(1);
			Mouth.LipsColor.gotoAndStop(1);
			Mouth.LipsHighlight.gotoAndStop(1);
			Headwear.gotoAndStop(1);
			SetupHair();
			
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
		public function SetDefaultTimelines(defTimelines:Array)
		{
			if (defaultTimelines == null)
			{
				defaultTimelines = defTimelines;
				ResetToDefaultTimelines();
			}
		}
		
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
			masterTimeline.play(startAtFrame);
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).play(startAtFrame);
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
		
		public function ResetToDefaultTimelines()
		{
			masterTimeline.clear();
			masterTimeline.add(defaultTimelines);
			//UpdateTimelines();
		}
		
		public function ClearTimelines()
		{
			masterTimeline.clear();
		}
		
		public function AddTimelines(timelinesToAdd:Array)
		{
			for (var i:uint = 0, l:uint = timelinesToAdd.length; i < l; ++i)
			{
				AddTimeline(timelinesToAdd[i]);
			}
		}
		
		public function AddTimeline(tlToAdd:TimelineLite)
		{
			var timelineForPart:String = tlToAdd.data as String;
			var currentFrame:int = this.currentFrame;
			if (timelineForPart)
			{
				var childTimelines:Array = masterTimeline.getChildren(true, false);
				var childTlForPart:String;
				var childTimeline:TimelineLite;
				for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
				{
					
					childTimeline = childTimelines[i] as TimelineLite;
					if (childTimeline)
					{
						childTlForPart = childTimeline.data as String;
						if (timelineForPart == childTlForPart)
						{
							masterTimeline.remove(childTimeline);
							masterTimeline.add(tlToAdd);
							tlToAdd.seek(currentFrame);
							return; //Finished, so end early. 
						}
						//TODO Have timelines that are completely new (ie Isabelle's body fur pattern) be added if there were no matches
					}
				}
			}
		}
		
		
		public function ReplaceTimeline(tlToRemove:TimelineLite, tlToAdd:TimelineLite)
		{
			if (tlToRemove != tlToAdd)
			{
				masterTimeline.remove(tlToRemove);
				masterTimeline.add(tlToAdd);
				tlToAdd.seek(this.currentFrame);
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