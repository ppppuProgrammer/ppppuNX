package ppppu 
{
	import com.greensock.easing.ExpoOut;
	import com.greensock.easing.Linear;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	import com.greensock.data.TweenLiteVars;
	/**
	 * ...
	 * @author 
	 */
	public class TweenDataParser 
	{
		
		public function TweenDataParser()
		{
			
		}
		
		public function IntegrateTweenData(targetObject:DisplayObject, tweenDataObjects:Vector.<Object>, sourceFrameRate:int):Array
		{
			if (!targetObject) { return null;}
			var tweensArray:Array = new Array();
			var tween:TweenLite;
			var timePerFrame:Number = 1.0 / sourceFrameRate;
			//var debug_TotalDuration:int = 0;
			for (var i:int = 0, l:int = tweenDataObjects.length; i < l; ++i)
			{
				var duration:Number;
				
				
				if (i == 0)
				{
					var fromTweenData:Object = tweenDataObjects[i];
					//Get the to tween data. If i+1 is less than l then access the data at index i+1. Otherwise, access the data at index 0 so the last tween tweens into the first tween (creating a loop) 
					var toTweenData:Object = tweenDataObjects[i + 1];
					if ("duration" in fromTweenData)
					{
						duration = fromTweenData.duration * timePerFrame;
					}
					else //Fallback for when no duration is defined. Sets the tween to have a duration of 1 frame.
					{
						duration = 1 * timePerFrame;
					}
					tween = TweenLite.fromTo(targetObject, duration, fromTweenData.vars, toTweenData.vars);
					tween.startTime((fromTweenData.startTime) * timePerFrame);
					//Need to skip the 2nd tween as there is no reason to tween to it again.
					++i;
				}
				else
				{
					var tweenData:Object = tweenDataObjects[i];
					if ("duration" in tweenData)
					{
						duration = tweenData.duration * timePerFrame;
					}
					else //Fallback for when no duration is defined. Sets the tween to have a duration of 1 frame.
					{
						duration = 1 * timePerFrame;
					}
					tween = TweenLite.to(targetObject, duration, tweenData.vars);
					tween.startTime((tweenData.startTime) * timePerFrame);
				}
				
				//tweenData.vars.useFrames = false;
				//Need to use fromTo for the first tween so at time of 0 the positioning of the objects are in the right place(otherwise it shows the objects initial positions until the first tween ends)
				
				
				
				tweensArray[tweensArray.length] = tween;
			}
			//Final tween creation to have the animation loop right. Tween to the very first tween created.
			var lastTweenData:Object = tweenDataObjects[l - 1];
			tweenData = tweenDataObjects[0];
			tween = TweenLite.to(targetObject, lastTweenData.duration * timePerFrame, tweenData.vars);
			tween.startTime((tweenData.startTime) * timePerFrame);	
			
			tweensArray[tweensArray.length] = tween;
				
			return tweensArray;
		}
		
		
		public function CreateTimelineFromData(targetObject:DisplayObject, tweenDataObjects:Vector.<Object>, sourceFrameRate:int):TimelineMax
		{
			if (!targetObject) { return null; }
			
			var timeline:TimelineMax = new TimelineMax( {  repeat: -1, paused:true } );
			timeline.data = { targetElement: targetObject };
			
			var tween:TweenLite;
			var timePerFrame:Number = 1.0 / sourceFrameRate;
			for (var i:int = 0, l:int = tweenDataObjects.length; i < l; ++i)
			{
				var duration:Number;
				{
					var tweenData:Object = tweenDataObjects[i];
					tweenData.vars.useFrames = false;
					if ("duration" in tweenData)
					{
						duration = tweenData.duration * timePerFrame;
					}
					else //Fallback for when no duration is defined. Sets the tween to have a duration of 1 frame.
					{
						duration = 1 * timePerFrame;
					}
					if (i == 0)
					{
						timeline.set(targetObject, tweenData.vars);
					}
					else
					{
						timeline.to(targetObject, duration, tweenData.vars);
					}
				}
			}
			//Final tween creation to have the animation loop right. Tween to the very first tween created.
			var lastTweenData:Object = tweenDataObjects[l - 1];
			tweenData = tweenDataObjects[0];
			timeline.to(targetObject, lastTweenData.duration * timePerFrame, tweenData.vars);
			var debugArray:Array = timeline.getTweensOf(targetObject, false);
			//TraceOutDurations(debugArray);
			return timeline;
		}
		
		private function TraceOutDurations(tweenArray:Array):void
		{
			var output:String="";
			for (var i:int = 0, l:int = tweenArray.length; i < l;++i)
			{
				output += tweenArray[i].startTime() + ",";
			}
			trace(output);
		}
	}

}