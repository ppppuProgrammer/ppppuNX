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
			//var targetName:String = ;
			//trace(targetObject.name);
			var tweensArray:Array = new Array();
			//var nodes:XMLList = motionXML.children();
			//var nodeAttributes:XMLList;
			var tween:TweenLite;
			for (var i:int = 0, l:int = tweenDataObjects.length; i < l; ++i)
			{
				var tweenData:Object = tweenDataObjects[i];
				//tweenData.vars["paused"] = true;
				//tweenData.vars["visible"] = false;
				tween = TweenLite.to(targetObject, 0.0, tweenData.vars);
				tween.startTime(tweenData.startTime);
				if ("duration" in tweenData)
				{
					tween.duration(tweenData.duration);
				}
				//tween.vars["paused"] = true;
				tweensArray[tweensArray.length] = tween;
			}
			
			return tweensArray;
		}
		
	}

}