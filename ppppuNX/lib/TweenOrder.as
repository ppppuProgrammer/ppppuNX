package 
{
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Linear;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * 
	 * @author 
	 */
	public class TweenOrder
	{
		private var targetObject:Object;
		public function get TargetObject():Object { return targetObject; }
		private var tweenVars:Object;
		public function get TweenVars():Object { return tweenVars; }
		private var startFrame:Number;
		public function get StartFrame():Number { return startFrame; }
		private var durationFrames:Number;
		public function get DurationFrames():Number { return durationFrames; }
		public function TweenOrder(target:Object, tweenVariables:Object, executeFrame:int, tweenFrameDuration:int) 
		{
			var timeMillisecPerFrame:Number = 1000.0 / 30.0;
			targetObject = target;
			tweenVars = tweenVariables;
			//startFrame = executeFrame;
			//durationFrames = tweenFrameDuration;
			startFrame = ((executeFrame-1)  * timeMillisecPerFrame) / 1000.0;
			durationFrames = (tweenFrameDuration  * timeMillisecPerFrame) / 1000.0;
			if (tweenVars is TweenLiteVars) //Test if tweenVars is actually a TweenLiteVars 
			{
				if (tweenVars.vars["useFrames"] == true)
				{
					tweenVars.vars["useFrames"] = !true;
				}
				if (tweenFrameDuration > 1)
				{
					var whattheheckishappening:int = 5;
				}
				if (tweenFrameDuration > 1 && ("ease" in tweenVars.vars) == false)
				{
					tweenVars.vars["ease"] = Linear.easeNone;
				}
			}
			else
			{
				//tweenVars is just a regular Object
				if (tweenVars["useFrames"] == true)
				{
					tweenVars["useFrames"] = !true;
				}
				if (tweenFrameDuration > 1 && ("ease" in tweenVars) == false)
				{
					tweenVars["ease"] = Linear.easeNone;
				}
			}
		}
		
	}

}