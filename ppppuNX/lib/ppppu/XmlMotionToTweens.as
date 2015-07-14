package ppppu 
{
	import flash.geom.Matrix;
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
		public static function ConvertXmlToTweens(targetObject:DisplayObject, motionXML:XML):Vector.<TweenOrder>
		{
			//var orders:Vector.<TweenOrder> = new Vector.<TweenOrder>(120, true);
			var orders:Vector.<TweenOrder> = new Vector.<TweenOrder>();
			var nodes:XMLList = motionXML.children();
			var frameVariables:Object;
			var transformMatrixData:Object;
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
			var tweenDuration:int = 0;
			var lastKeyframeNumber:uint = 1;
			var skewBased:Boolean = false; //If skew based, the rotation property is applied to both skew values
			var tweenOrder:TweenOrder;
			var tweenMatrix:Matrix;
			for (var i:int = 0, l:int = nodes.length(); i < l; ++i)
			{
				if (keyframeNumber > 0)
				{
					
					
					
					tweenMatrix = new Matrix();
					//Start with scale
					SetMatrixScaleX(tweenMatrix, latestScaleX);
					SetMatrixScaleY(tweenMatrix, latestScaleY);
					//Rotation and skews
					if (skewBased)
					{
						SetMatrixSkewX(tweenMatrix, latestSkewX);
						SetMatrixSkewY(tweenMatrix, latestSkewY);
					}
					else
					{
						SetMatrixSkewX(tweenMatrix, latestRotation);
						SetMatrixSkewY(tweenMatrix, latestRotation);
					}
					
					//If the difference between frames is 
					if (i+1 == l) //Last go at the for loop
					{
						tweenDuration = 120 - lastKeyframeNumber;
					}
					if (tweenDuration == 1) 
					{ tweenDuration = 0; } 
					else 
					{tweenDuration = keyframeNumber - lastKeyframeNumber;}
					
					
					tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:tweenMatrix.a, 
						b:tweenMatrix.b, 
						c:tweenMatrix.c, 
						d:tweenMatrix.d, tx: latestX, ty: latestY}), 
						keyframeNumber, tweenDuration);
					orders[orders.length] = tweenOrder;
				}
				
				storingSourceProperties = false;
				currentNode = nodes[i];
				if (currentNode.localName() == "source")
				{
					currentNode = currentNode.children()[0]; //"Source" element nested in "source" element
				}
				if (currentNode.localName() == "Source")
				{
					storingSourceProperties = true;
				}
				nodeAttributes = currentNode.attributes();
				frameVariables = new Object();
				transformMatrixData = new Object();
				frameVariables["transformMatrix"] = transformMatrixData;
				for (var attCounter:int = 0, attLen:int = nodeAttributes.length(); attCounter < attLen; ++attCounter)
				{
					attributeName = nodeAttributes[attCounter].localName();
					if (attributeName == "index")
					{
						keyframeNumber = int(nodeAttributes[attCounter].toXMLString()) + 1;
					}
					else if (attributeName != "frameRate" && attributeName != "elementType" && attributeName != "symbolName")
					{
						var attributeValue:Number = Number(nodeAttributes[attCounter].toXMLString());		
						if (!storingSourceProperties)
						{
							switch(attributeName)
							{
								case "rotation":
									if (skewBased == true)
									{
										latestSkewX = attributeValue + sourceProperties["skewX"];
										latestSkewY = attributeValue + sourceProperties["skewY"];
									}
									else 
									{
										latestRotation = attributeValue + sourceProperties[attributeName];
									}
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
						else //storing source properties
						{
							sourceProperties[attributeName] = attributeValue;
							switch(attributeName)
							{
								case "rotation":
									latestRotation = attributeValue;
									break;
								case "skewX":
								case "skewY":
									skewBased = true;
									if (attributeName == "skewX")
									{
										latestSkewX = attributeValue;
									}
									else
									{
										latestSkewY = attributeValue;
									}
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
					}
				}			
					
				lastKeyframeNumber = keyframeNumber;
			}
			if (keyframeNumber > 0)
			{
				tweenMatrix = new Matrix();
				
				
				//Start with scale
				SetMatrixScaleX(tweenMatrix, latestScaleX);
				SetMatrixScaleY(tweenMatrix, latestScaleY);
				//Rotation and skews
				if (skewBased)
				{
					SetMatrixSkewX(tweenMatrix, latestSkewX);
					SetMatrixSkewY(tweenMatrix, latestSkewY);
				}
				else
				{
					SetMatrixSkewX(tweenMatrix, latestRotation);
					SetMatrixSkewY(tweenMatrix, latestRotation);
				}
				
				
				if (i == l) //Last go at the for loop
				{
					tweenDuration = 120 - lastKeyframeNumber;
				}
				//If the difference between frames is 1, then set it to 0 so the change happens instantly
				if (tweenDuration == 1) { tweenDuration = 0; } else {tweenDuration = keyframeNumber - lastKeyframeNumber;}
				
				
				tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:tweenMatrix.a, 
					b:tweenMatrix.b, 
					c:tweenMatrix.c, 
					d:tweenMatrix.d, tx: latestX, ty: latestY}), 
					keyframeNumber, tweenDuration);
				orders[orders.length] = tweenOrder;
			}
			return orders;
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