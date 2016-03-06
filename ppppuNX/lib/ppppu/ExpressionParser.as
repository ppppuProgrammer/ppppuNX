package ppppu 
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ExpressionParser 
	{
		
		public function ExpressionParser() 
		{
			
		}
		
		
		public function Parse(masterDisplay:MasterTemplate, displayObj:DisplayObject, expressionDefinition:String):TimelineMax
		{
			var timeline:TimelineMax = new TimelineMax({paused:true, useFrames:true, repeat:-1/*, onStart:start, onComplete:complete, onRepeat:repeat, onUpdate:update*/});
			
			var spaceRegex:RegExp = /[' ']+/gim;
			expressionDefinition = expressionDefinition.replace(spaceRegex, '');
			
			var tweens:Array = new Array();
			
			//Split by lines
			var definitionLines:Array = expressionDefinition.split("\r\n");
			
			if (definitionLines.length > 0)
			{
				var headerParts:Array = definitionLines[0].split(',');
				if (headerParts.length != 3) { return null;}
				//Header
				var charName:String = headerParts[0];
				var animName:String = headerParts[1];
				var expName:String = headerParts[2];
				
				
				//Rest
				for (var i:int = 1, l:int = definitionLines.length; i < l; ++i)
				{
					if (definitionLines[i].indexOf("//") == -1 && definitionLines[i].indexOf("#") == -1)//Skip line conditions
					{
						//Split the current line
						var currLinesParts:Array = definitionLines[i].split(',');
						//currLinesParts: index(idx) 0 is start frame, idx 1 is duration, idx 2 is expression name, idx 3 or higher is custom settings using gsap acceptable properties.
						
						var tweenVariables:Object = {useFrames:true, onRepeat: masterDisplay.ChangeMouthExpression, onRepeatParams:[currLinesParts[2]], onStart: masterDisplay.ChangeMouthExpression, onStartParams:[currLinesParts[2]]};
						if (currLinesParts.length >= 3)
						{
							var tween:TweenLite;
							for (var x:int = 3, y:int = currLinesParts.length; x < y; ++x)
							{
								
									var propertyData:Array = currLinesParts[x].split(':');
									if (propertyData.length == 2)
									{
										var propertyName:String = propertyData[0];
										var propertyRawValue:String = propertyData[1];
										//Check if number
										var propertyValue:Number = parseFloat(propertyRawValue);
										if (isNaN(propertyValue))//Not a number
										{
											tweenVariables[propertyName] = propertyRawValue;
										}
										else
										{
											tweenVariables[propertyName] = propertyValue;
										}
									}
							}
							tween = TweenLite.to(displayObj, 0.0, tweenVariables);
							tween.startTime(parseInt(currLinesParts[0]));
							tween.duration(parseInt(currLinesParts[1]));
							//tween.duration();
							tween.data = currLinesParts[2];
							tweens.push(tween);
						}
					}
				}
			}
			timeline.add(tweens,"+=0", "sequence");
			//timeline.duration(120);
			return timeline;
		}
	}

}