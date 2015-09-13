package ppppu 
{
	import com.greensock.easing.ExpoOut;
	import com.greensock.easing.Linear;
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
		
		public function IntegrateTweenData(targetObject:DisplayObject, tweenDataObjects:Vector.<Object>):Array
		{
			if (!targetObject) { return null;}
			var tweensArray:Array = new Array();
			var tween:TweenLite;
			var debug_TotalDuration:int = 0;
			for (var i:int = 0, l:int = tweenDataObjects.length; i < l; ++i)
			{
				var tweenData:Object = tweenDataObjects[i];
				tween = TweenLite.to(targetObject, 0.0, tweenData.vars);
				tween.startTime(tweenData.startTime);
				if ("duration" in tweenData)
				{
					tween.duration(tweenData.duration);
				}
				else //Fallback for when no duration is defined. Sets the tween to have a duration of 1 frame.
				{
					tween.duration(1);
				}
				tweensArray[tweensArray.length] = tween;
			}
			
			return tweensArray;
		}
		
	}

}