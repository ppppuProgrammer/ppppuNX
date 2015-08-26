package ppppu 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.geom.*;
	/**
	 * ...
	 * @author 
	 */
	public class HairDefinition 
	{
		public var mySprite:Sprite;
		/*Dictionary that details how the element should be scale in relation to its attached to object.
		 * Key - String of the animation name
		 * Value - Array with 2 numbers, index 0 is for scale X and index 1 is for scale Y*/
		public var scaleFactors:Dictionary;// = new Dictionary();
		/*Dictionary that details how the element should be scale in relation to its attached to object.
		 * Key - String of the animation name
		 * Value - The Point relative of the attached to element to be positioned at*/
		public var attachPoints:Dictionary;// = new Dictionary();
		public var pairedCharacter:String; //The character this hair belongs to
		/*Dictionary that tells how far away from the anchored object the element containing this definition
		 * should be. The base depth layout (found in the "[animation name] layer info.json" files) should be used as a reference
		 * for what the depth offset should be.*/
		public var depthOffsets:Dictionary; 
		private const DegToRad:Number = (Math.PI / 180.0);
		public function HairDefinition() 
		{
			scaleFactors = new Dictionary();
			attachPoints = new Dictionary();
			depthOffsets = new Dictionary();
			//scaleFactors["Fallback"] = 1.0;
			//attachPoints["Fallback"] = Point(0,0);
		}
		
		protected function SetSprite(defSprite:Sprite):void
		{
			
			var mat:Matrix = defSprite.transform.matrix;
			var bounds:Rectangle = defSprite.getBounds(defSprite); // get the bounds relative to the movie clip
			mat.tx = -bounds.left; //left and top will be the registration point of the clip
			mat.ty = -bounds.top; 
			defSprite.transform.matrix = mat;
			mySprite = defSprite;
		}
		
		//scaleFactorArray - Array with 2 indexes, index 0 is for scale x, index 1 is for scale y
		//args - Accepts a variable amount of parameters. Inputted variables are used as keys of the scaleFactors dictionary
		public function SetScaleFactors(scaleFactorArray:Array, ... args):void
		{
			for (var argIndex:int = 0, argsLength:int = args.length; argIndex < argsLength; ++argIndex)
			{
				var animationName:String = args[argIndex] as String;
				if (animationName)
				{
					scaleFactors[animationName] = scaleFactorArray;
				}
			}
		}
		
		public function SetInitialMatrix(skewXDegrees:Number=0.0, skewYDegrees:Number=0.0):void
		{
			var skewYAmount:Number = skewYDegrees * DegToRad;
			var skewXAmount:Number = skewXDegrees * DegToRad;
			mySprite.transform.matrix = new Matrix(mySprite.scaleX * Math.cos(skewYAmount), mySprite.scaleX * Math.sin(skewYAmount), -mySprite.scaleY * Math.sin(skewXAmount), mySprite.scaleY * Math.cos(skewXAmount));
		}
		
		//Helper function to set the attach point for multiple animations
		 
		public function SetAttachPoints(attachPoint:Point, ... args):void
		{
			for (var argIndex:int = 0, argsLength:int = args.length; argIndex < argsLength; ++argIndex)
			{
				var animationName:String = args[argIndex] as String;
				if (animationName)
				{
					attachPoints[animationName] = attachPoint;
				}
			}
		}
		
		/*protected function SetRegistrationPointToCenter():void 
		{
			if (mySprite)
			{
				//var dpObj = mySprite.getChildAt(0); //the dipslay object or graphic you movie clip contains
				var mat:Matrix = mySprite.transform.matrix;
				var bounds:Rectangle = mySprite.getBounds(mySprite); // get the bounds relative to the movie clip
				mat.tx = -bounds.left; //left and top will be the registration point of the clip
				mat.ty = -bounds.top; 
				mySprite.transform.matrix = mat;
			}
		}*/
	}

}