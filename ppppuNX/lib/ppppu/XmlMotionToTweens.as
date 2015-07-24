package ppppu 
{
	import com.greensock.TweenLite;
	import flash.geom.Matrix;
	import flash.sampler.getMasterString;
	import flash.utils.Dictionary;
	import flash.xml.*;
	import flash.display.DisplayObject;
	import mx.utils.XMLUtil;
	import com.greensock.data.TweenLiteVars;
	/**
	 * ...
	 * @author 
	 */
	public class XmlMotionToTweens 
	{
		public function XmlMotionToTweens()
		{
			
		}
		public static function ConvertXmlToTweens(targetObject:DisplayObject, motionXML:XML):Array
		{
			//var targetName:String = ;
			trace(targetObject.name);
			//var orders:Vector.<TweenOrder> = new Vector.<TweenOrder>(120, true);
			var Tweens:Array = new Array();
			var nodes:XMLList = motionXML.children();
			//var frameVariables:Object;
			//var transformMatrixData:Object;
			var nodeAttributes:XMLList;
			var currentNode:XML;
			var attributeName:String;
			var keyframeNumber:int = -1;
			var sourceProperties:Dictionary = new Dictionary();
			var storingSourceProperties:Boolean;
			
			var latestX:Number;
			var latestY:Number;
			var latestSkewX:Number;
			var latestSkewY:Number;
			var latestScaleX:Number;
			var latestScaleY:Number;
			var latestRotation:Number;
			//var tweenDuration:int = 0;
			//var lastKeyframeNumber:uint = 1;
			//var skewBased:Boolean = false; //If skew based, the rotation property is applied to both skew values
			//var tweenOrder:TweenOrder;
			var tweenMatrix:Matrix;
			var previousTween:TweenLite = null, currentTween:TweenLite = null;
			for (var i:int = 0, l:int = nodes.length(); i < l; ++i)
			{
				storingSourceProperties = false;
				currentNode = nodes[i];
				if (currentNode.localName() == "source")
				{
					currentNode = currentNode.children()[0]; //"Source" element nested in "source" element
					storingSourceProperties = true;
				}
				nodeAttributes = currentNode.attributes();
				
				if (currentTween != null)
				{
					previousTween = currentTween;
					currentTween = null;
				}
				
				for (var attCounter:int = 0, attLen:int = nodeAttributes.length(); attCounter < attLen; ++attCounter)
				{
					//Get attribute's name
					attributeName = nodeAttributes[attCounter].localName();
					
					var attributeValue:Number = Number(nodeAttributes[attCounter].toXMLString());	
					if (storingSourceProperties)
					{
						sourceProperties[attributeName] = attributeValue;
						switch(attributeName)
						{
							case "rotation":
								latestSkewX = sourceProperties["skewX"] = attributeValue;
								latestSkewY = sourceProperties["skewY"] = attributeValue;
								break;
							case "skewX":
								latestSkewX = attributeValue;
								break;
							case "skewY":
								latestSkewY = attributeValue;
								break;
							case "x":
								latestX = attributeValue;
								break;
							case "y":
								latestY = attributeValue;
								break;
							case "scaleX":
								latestScaleX = attributeValue;
								break;
							case "scaleY":
								latestScaleY = attributeValue;
								break;
						}
					}
					else
					{
						if (attributeName == "index")
						{
							keyframeNumber = int(nodeAttributes[attCounter].toXMLString()) + 1;
						}
						else if (attributeName != "frameRate" && attributeName != "elementType" && attributeName != "symbolName")
						{
							
							if (!storingSourceProperties)
							{
								switch(attributeName)
								{
									case "rotation":
										latestSkewX = attributeValue + sourceProperties["skewX"];
										latestSkewY = attributeValue + sourceProperties["skewY"];
										break;
									case "skewX":
										latestSkewX = attributeValue + sourceProperties[attributeName];
										break;
									case "skewY":
										latestSkewY = attributeValue + sourceProperties[attributeName];
										break;
									case "x":
										latestX = attributeValue + sourceProperties[attributeName];
										break;
									case "y":
										latestY = attributeValue + sourceProperties[attributeName];
										break;
									case "scaleX":
										latestScaleX = attributeValue * sourceProperties[attributeName];
										break;
									case "scaleY":
										latestScaleY = attributeValue * sourceProperties[attributeName];
										break;
								}
							}
						}
					}
				}			
				
				if (keyframeNumber > 0)
				{
					tweenMatrix = new Matrix();
					
					//Start with scale
					SetMatrixScaleX(tweenMatrix, latestScaleX);
					SetMatrixScaleY(tweenMatrix, latestScaleY);
					//Rotation and skews
					SetMatrixSkewX(tweenMatrix, latestSkewX);
					SetMatrixSkewY(tweenMatrix, latestSkewY);

					if (currentTween == null)
					{
						//Creates a new tween with the calculated matrix information
						currentTween = TweenLite.to(targetObject, 0.0, new TweenLiteVars().transformMatrix( { a:tweenMatrix.a, 
							b:tweenMatrix.b, c:tweenMatrix.c, d:tweenMatrix.d, tx: latestX, ty: latestY } ));
						//Set current tweens start time, based on it's keyframe. 30 is the fps the flash is intended to run at
						currentTween.startTime(((keyframeNumber-1)  * (1000.0 / 30.0)) / 1000.0);
					}
					//If both current frame and previous frame tweens are found, duration for the current tween can be calculated
					if (currentTween && previousTween)
					{
						//Set the current tween's duration equal to the difference of start times of the current tween and the previous one
						currentTween.duration(currentTween.startTime() - previousTween.startTime());
					}
					if (currentTween && i + 1 >= l)
					{
						//Current Tween is the last tween that will be added for the timeline.
						//4.0 is the amount of seconds an animation lasts.
						currentTween.duration( 4.0 - currentTween.startTime());
					}
					//Add the current tween to the tweens array
					Tweens[Tweens.length] = currentTween;
				}
				
			}
			
			return Tweens;
		}
		//Matrix modification code ported from MotionXML.jsfl
		public static function SetMatrixScaleX(m:Matrix, scaleX:Number):void
		{
			var skewYRad:Number = GetMatrixSkewYRadians(m);
			m.a = Math.cos(skewYRad) * scaleX;
			m.b = Math.sin(skewYRad) * scaleX;
		}
		
		public static function SetMatrixScaleY(m:Matrix, scaleY:Number):void
		{
			var skewXRad:Number = GetMatrixSkewXRadians(m);
			m.c = -Math.sin(skewXRad) * scaleY;
			m.d = Math.cos(skewXRad) * scaleY;
		}
		
		public static function SetMatrixSkewX(m:Matrix,skewXDegrees:Number):void
		{
			var skewXRadians:Number = skewXDegrees * (Math.PI / 180.0);
			var scaleY:Number = GetMatrixScaleY(m);
			m.c = -scaleY * Math.sin(skewXRadians);
			m.d =  scaleY * Math.cos(skewXRadians);
		}
		public static function SetMatrixSkewY(m:Matrix,skewYDegrees:Number):void
		{
			var skewYRadians:Number = skewYDegrees * (Math.PI / 180.0);
			var scaleX:Number = GetMatrixScaleX(m);
			m.a = scaleX * Math.cos(skewYRadians);
			m.b = scaleX * Math.sin(skewYRadians);
		}
		
		public static function GetMatrixSkewXRadians(m:Matrix):Number
		{
			return Math.atan2( -m.c, m.d);
		}
		
		public static function GetMatrixSkewYRadians(m:Matrix):Number
		{
			return Math.atan2(m.b, m.a);
		}
		
		public static function GetMatrixScaleX(m:Matrix):Number
		{
			return Math.sqrt(m.a*m.a + m.b*m.b);
		}
		
		public static function GetMatrixScaleY(m:Matrix):Number
		{
			return Math.sqrt(m.c*m.c + m.d*m.d);
		}
	}

}