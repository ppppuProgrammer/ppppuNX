package ppppu 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author 
	 */
	public class AnchoredElementBase extends MovieClip 
	{
		private var masterTemplate:MasterTemplate = null;
		private var definitions:Vector.<HairDefinition> = new Vector.<HairDefinition>();
		private var currentDefinitionUsed:HairDefinition;
		private var currentlyDisplayedSprite:Sprite = null;
		private var currentlyAnchoredObject:Sprite = null;
		public var anchoredDisplayObjectDict:Dictionary = new Dictionary();
		public var type:int;
		public static const SKINELEMENT:int = 1;
		public static const HAIRELEMENT:int = 2;
		public function AnchoredElementBase(elementName:String, elementType:int = 0) 
		{
			gotoAndStop(1);
			addEventListener(Event.ADDED_TO_STAGE, Initialize);
			name = elementName;
			type = elementType;
			/*To avoid having the element shown for a small amount of time is an visual off place (usually top left of the screen) until
			its position is correct.*/
			this.visible = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function Initialize(e:Event):void
		{
			if (this.parent is MasterTemplate)
			{
				masterTemplate = this.parent as MasterTemplate;
				removeEventListener(Event.ADDED_TO_STAGE, Initialize);
			}
		}
		
		public function AddNewDefinition(definition:HairDefinition):void
		{
			if (definition)
			{
				definitions[definitions.length] = definition;
				if (definitions.length == 1)
				{
					ChangeDisplayedSprite();
				}
			}
		}
		public function GetSpriteListLength():int
		{
			return definitions.length;
		}
		public function ChangeDisplayedSprite(defIndex:int=0):void
		{
			if (defIndex < definitions.length)
			{
				if (this.numChildren > 0) { this.removeChildren();}
				currentlyDisplayedSprite = definitions[defIndex].mySprite;
				addChild(currentlyDisplayedSprite);
				currentDefinitionUsed = definitions[defIndex];
			}
		}
		
		public function SetAnchorObjectForAnimation(anchorObject:Sprite, ... args):void
		{
			for (var argIndex:int = 0, argsLength:int = args.length; argIndex < argsLength; ++argIndex)
			{
				var animationName:String = args[argIndex] as String;
				if (animationName)
				{
					anchoredDisplayObjectDict[animationName] = anchorObject;
				}
			}
		}
		
		//Controls the scale of the anchored element in relation to a specified part.
		// Deemed unnecessary due to the new definition class, where scale factors are to be assigned.
		/*public function ChangeScalingFactorForAnimationTypes()
		{
			
		}*/
		
		public function Update():void
		{
			if (masterTemplate)
			{
				var currentAnimationName:String = masterTemplate.currentAnimationName;
				//Check if the object this is anchored to is invisible. If so, time to find the object this should be anchored to now.
				if (currentlyAnchoredObject == null || currentlyAnchoredObject.visible == false)
				{
					currentlyAnchoredObject = null;
					if (masterTemplate.currentAnimationName in anchoredDisplayObjectDict)
					{
						currentlyAnchoredObject = anchoredDisplayObjectDict[currentAnimationName];
					}
				}
				
				if (currentlyAnchoredObject && currentDefinitionUsed && currentAnimationName in currentDefinitionUsed.attachPoints)
				{
					var basePlacementPoint:Point;
					
					//Insert movement code involving anchor points, the anchored object, localtoglobal, skew, and scale here.
					if ("Element" in currentlyAnchoredObject)
					{
						basePlacementPoint = currentlyAnchoredObject["Element"].localToGlobal(currentDefinitionUsed.attachPoints[currentAnimationName]);
						
					}
					else
					{
						basePlacementPoint = currentlyAnchoredObject.localToGlobal(currentDefinitionUsed.attachPoints[currentAnimationName]);
					}
					//var basePlacementPoint:Point = currentlyAnchoredObject.localToGlobal(new Point(0, 0));
					this.x = basePlacementPoint.x; this.y = basePlacementPoint.y;
					/*if (currentAnimationName == "Paizuri" && this.name == "HairBack")
					{
						trace("Current Frame: " + ((masterTemplate.parent.currentFrame - 2) % 120 + 1));
						trace(currentlyAnchoredObject.name + "'s position: { x:" + currentlyAnchoredObject.x + ", y:" + currentlyAnchoredObject.y + " }");
						trace(this.name + "'s position: { x:" + this.x + ", y:" + this.y + " }");
						//trace(currentlyAnchoredObject.name + "'s dimensions: " + currentlyAnchoredObject.width + ", " + currentlyAnchoredObject.height);
						trace("Distance: { x:" + (this.x - currentlyAnchoredObject.x) + ", y:" + (this.y - currentlyAnchoredObject.y) + " }")
						trace("Test: x: " + (currentlyAnchoredObject.x + currentDefinitionUsed.attachPoints[currentAnimationName].x) + " y: " + (currentlyAnchoredObject.y + currentDefinitionUsed.attachPoints[currentAnimationName].y));
					}*/
					//currentlyDisplayedSprite.x = basePlacementPoint.x; currentlyDisplayedSprite.y = basePlacementPoint.y;
					/*this.width = currentlyAnchoredObject.width * currentDefinitionUsed.scaleFactors[currentAnimationName][0];
					this.height = currentlyAnchoredObject.height * currentDefinitionUsed.scaleFactors[currentAnimationName][1];*/
					var anchoredObjBaseShapeWidth:Number = currentlyAnchoredObject.getChildAt(0).width;
					var anchoredObjBaseShapeHeight:Number = currentlyAnchoredObject.getChildAt(0).height;
					this.width = (anchoredObjBaseShapeWidth * currentlyAnchoredObject.scaleX) * currentDefinitionUsed.scaleFactors[currentAnimationName][0];
					this.height = (anchoredObjBaseShapeHeight * currentlyAnchoredObject.scaleY) * currentDefinitionUsed.scaleFactors[currentAnimationName][1];
					
					//need way to track rotation of face. try observing the difference in nose positioning for up/down head tilts.
					
					/*The switch template animation function in ppppuCore sets all elements in the master template to be invisible. While
					 * most elements needed will be set to be visible later, this is done in the add timeline function of template base.
					 * Getting to the point, anchored elements miss being set to visible because they aren't tied to a timeline. So make 
					 * the element visible here.*/
					this.visible = true; 
					//this.rotation = currentlyAnchoredObject.rotation;
				}
				else
				{
					//Element wasn't set properly, don't let it be visible.
					this.visible = false;
				}
			}
		}
		
		//Ensures that the anchored element is using the anchor display object for the current animation.
		public function RefreshCurrentAnchor():void
		{
			if (masterTemplate)
			{
				var currentAnimationName:String = masterTemplate.currentAnimationName;
				//Check if the object this is anchored to is invisible. If so, time to find the object this should be anchored to now.
				if (currentlyAnchoredObject == null || currentlyAnchoredObject.visible == false)
				{
					currentlyAnchoredObject = null;
					if (masterTemplate.currentAnimationName in anchoredDisplayObjectDict)
					{
						currentlyAnchoredObject = anchoredDisplayObjectDict[currentAnimationName];
					}
				}
			}
		}
		
		public function GetCurrentDepthOffset():Number
		{
			var depthOffsetValue:Number = 0.0;
			if (masterTemplate && masterTemplate.currentAnimationName in currentDefinitionUsed.depthOffsets)
			{
				depthOffsetValue = currentDefinitionUsed.depthOffsets[masterTemplate.currentAnimationName];
			}
			return depthOffsetValue;
		}
		
		public function ChangeLayerDepth(layoutInfo:Object):void
		{
			if (masterTemplate && currentlyAnchoredObject)
			{
				var anchoredObjIndex:int = layoutInfo[currentlyAnchoredObject.name];
				var anchoredObjIndex2:int = masterTemplate.getChildIndex(currentlyAnchoredObject);
				var depthOffset:int = 0;
				if (masterTemplate.currentAnimationName in currentDefinitionUsed.depthOffsets)
				{
					depthOffset = currentDefinitionUsed.depthOffsets[masterTemplate.currentAnimationName];
				}
				masterTemplate.setChildIndex(this, anchoredObjIndex + depthOffset);
			}
		}
		
		public function GetAnchoredObjectDepth():int
		{
			var anchorDepth:int = -1;
			if (currentlyAnchoredObject && masterTemplate)
			{
				anchorDepth = masterTemplate.getChildIndex(currentlyAnchoredObject);
			}
			
			
			return anchorDepth;
		}
		
		public function GetAnchoredObjectName():String
		{
			if (currentlyAnchoredObject)
			{
				return currentlyAnchoredObject.name;
			}
			
			return null;
		}
	}

}