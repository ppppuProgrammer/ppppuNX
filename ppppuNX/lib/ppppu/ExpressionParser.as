package ppppu 
{
	import com.greensock.TimelineMax;
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
			var timeline:TimelineMax = new TimelineMax();
			
			var spaceRegex:RegExp = "/[' ']+/gim";
			expressionDefinition = expressionDefinition.replace(spaceRegex, '');
			
			//Split by lines
			var definitionLines:Array = expressionDefinition.split("/r/n");
			
			if (definitionLines.length > 0)
			{
				var headerParts:Array = definitionLines[0].split(',');
				if (headerParts.length != 3) { return;}
				//Header
				var charName:String = headerParts[0];
				var animName:String = headerParts[1];
				var expName:String = headerParts[2];
			}
			
			return timeline;
		}
	}

}