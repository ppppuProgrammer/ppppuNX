package ppppu 
{
	import com.greensock.TimelineMax;
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
		private var masterTimeline:TimelineMax = new TimelineMax( { useFrames:true } );
		private var defaultTimelines:Array = null;
		
		public var EyeL:EyeContainer;
		public var EyeR:EyeContainer;
		public var Mouth:MouthContainerBase;
		/*public var HairFront:BaseHairFront;*/
		
		public function TemplateBase()
		{
			EyeL.gotoAndStop(1);
			EyeR.gotoAndStop(1);
			Mouth.MouthBase.gotoAndStop(1);
		}
		public function SetDefaultTimelines(defTimelines:Array)
		{
			if (defaultTimelines == null)
			{
				defaultTimelines = defTimelines;
				ResetToDefaultTimelines();
			}
		}
		public function UpdateTimelines()
		{
			var currentFrame:int = this.currentFrame;
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineMax).seek(currentFrame);
			}
		}
		
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
			UpdateTimelines();
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