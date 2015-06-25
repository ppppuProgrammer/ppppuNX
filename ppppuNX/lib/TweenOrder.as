package 
{
	import com.greensock.data.TweenLiteVars;
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
		private var startFrame:int;
		public function get StartFrame():int { return startFrame; }
		private var durationFrames:int;
		public function get DurationFrames():int { return durationFrames; }
		public function TweenOrder(target:Object, tweenVariables:Object, executeFrame:int, tweenFrameDuration:int) 
		{
			targetObject = target;
			tweenVars = tweenVariables;
			startFrame = executeFrame;
			durationFrames = tweenFrameDuration;
			if (tweenVars is TweenLiteVars) //Test if tweenVars is actually a TweenLiteVars 
			{
				if (tweenVars.vars["useFrames"] != true)
				{
					tweenVars.vars["useFrames"] = true;
				}
			}
			else
			{
				//tweenVars is just a regular Object
				if (tweenVars["useFrames"] != true)
				{
					tweenVars["useFrames"] = true;
				}
			}
		}
		
	}

}