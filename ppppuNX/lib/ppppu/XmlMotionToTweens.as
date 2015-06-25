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
			var orders:Vector.<TweenOrder> = new Vector.<TweenOrder>(120, true);
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
			var skewBased:Boolean = false; //If skew based, the rotation property is applied to both skew values
			
			for (var i:int = 0, l:int = nodes.length(); i < l; ++i)
			{
				storingSourceProperties = false;
				currentNode = nodes[i];
				if (currentNode.localName() == "source")
				{
					currentNode = currentNode.children()[0]; //"Source" element nested in "source" element
					//keyframeNumber = -1;
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
						//if (nodeAttributes[attCounter].toXMLString() == "0")
						//{
							//keyframeNumber = -1;
							//break;
						//}
						//else
						//{
							keyframeNumber = int(nodeAttributes[attCounter].toXMLString())+1;
						//}
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
									//transformMatrixData[attributeName] = attributeValue * sourceProperties[attributeName];
							}
						}
						else //storing source properties
						{
							sourceProperties[attributeName] = attributeValue;
							//transformMatrixData[attributeName] = attributeValue;
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
				/*transformMatrixData = { a:Math.cos(skewBased ? latestSkewY : latestRotation) * latestScaleY, 
					b:Math.sin(skewBased ? latestSkewY : latestRotation) * latestScaleX, 
					c:( -(Math.sin(skewBased ? latestSkewX : latestRotation))) * latestScaleY, 
					d:Math.cos(skewBased ? latestSkewX : latestRotation) * latestScaleY, tx: latestX, ty: latestY };*/
				/*tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:Math.cos((skewBased ? latestSkewY : latestRotation) / 180.0 * Math.PI) * latestScaleY, 
					b:Math.sin((skewBased ? latestSkewY : latestRotation) / 180.0 * Math.PI) * latestScaleX, 
					c:-(Math.sin((skewBased ? latestSkewX : latestRotation)/180.0 * Math.PI)) * latestScaleY, 
					d:Math.cos((skewBased ? latestSkewX : latestRotation)/180.0 * Math.PI) * latestScaleY, tx: latestX, ty: latestY }), 
					keyframeNumber, 0);*/
					
					
				if (keyframeNumber > 0)
				{
					var tweenOrder:TweenOrder;
					var tweenMatrix:Matrix = new Matrix();
					
					
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
					tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:tweenMatrix.a, 
						b:tweenMatrix.b, 
						c:tweenMatrix.c, 
						d:tweenMatrix.d, tx: latestX, ty: latestY}), 
						keyframeNumber, tweenDuration);
					/*if (skewBased)
					{
						tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:Math.cos(latestSkewX * (Math.PI/ 180.0)) * latestScaleX, 
						b:Math.sin(latestSkewY * (Math.PI/ 180.0)) * latestScaleX, 
						c:(-(Math.sin(latestSkewX* (Math.PI/ 180.0)))) * latestScaleY, 
						d:Math.cos(latestSkewX * (Math.PI/ 180.0)) * latestScaleY, tx: latestX, ty: latestY}), 
						keyframeNumber, tweenDuration); 
						//var tweenMatrix:Matrix = new Matrix(Math.cos(latestSkewY * (Math.PI/ 180.0)), Math.sin(latestSkewY * (Math.PI/ 180.0)), -(Math.sin(latestSkewX * (Math.PI/ 180.0))), Math.cos(latestSkewX * (Math.PI/ 180.0)));
						//var scaleMatrix:Matrix = new Matrix(latestScaleX, 0, 0, latestScaleY);
						//tweenMatrix.concat(scaleMatrix);
						tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { a:tweenMatrix.a, 
						b:tweenMatrix.b, 
						c:tweenMatrix.c, 
						d:tweenMatrix.d, tx: latestX, ty: latestY}), 
						keyframeNumber, tweenDuration);
					}
					else
					{
						tweenOrder = new TweenOrder(targetObject, new TweenLiteVars().transformMatrix( { rotation: latestRotation, x: latestX, y: latestY, scaleX: latestScaleX, scaleY: latestScaleY }), 
					keyframeNumber, tweenDuration);
					}*/
					
					//var tweenOrder:TweenOrder = new TweenOrder(targetObject, frameVariables, keyframeNumber, 0);
					orders[keyframeNumber-1] = tweenOrder;
				}
			}
			return orders;
		}
		//Matrix modification code ported from MotionXML.jsfl
		public static function SetMatrixScaleX(m:Matrix, scaleX:Number)
		{
			var skewYRad:Number = GetMatrixSkewYRadians(m);
			m.a = Math.cos(skewYRad) * scaleX;
			m.b = Math.sin(skewYRad) * scaleX;
		}
		
		public static function SetMatrixScaleY(m:Matrix, scaleY:Number)
		{
			var skewXRad:Number = GetMatrixSkewXRadians(m);
			m.c = -Math.sin(skewXRad) * scaleY;
			m.d = Math.cos(skewXRad) * scaleY;
		}
		
		public static function SetMatrixSkewX(m:Matrix,skewXDegrees:Number)
		{
			var skewXRadians:Number = skewXDegrees * (Math.PI / 180.0);
			var scaleY:Number = GetMatrixScaleY(m);
			m.c = -scaleY * Math.sin(skewXRadians);
			m.d =  scaleY * Math.cos(skewXRadians);
		}
		public static function SetMatrixSkewY(m:Matrix,skewYDegrees:Number)
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
		/*private function ComposeMatrixObject(latestX:Number, latestY:Number, latestSkewX:Number, latestSkewY:Number, latestScaleX:Number,
		latestScaleY:Number,latestRotation:Number, skewBased:Boolean):Object
		{
			return new Object( { a:Math.cos(skewBased ? latestSkewY : latestRotation) * latestScaleY, 
			b:Math.sin(skewBased ? latestSkewY : latestRotation) * latestScaleX, c:( -(Math.sin(skewBased ? latestSkewX : latestRotation))) * latestScaleY, 
			d:Math.cos(skewBased ? latestSkewX : latestRotation)*latestScaleY, tx: latestX, ty: latestY});
		}*/
		/*public function XmlMotionToTweens() 
		{
			
		}*/
		
	}

}