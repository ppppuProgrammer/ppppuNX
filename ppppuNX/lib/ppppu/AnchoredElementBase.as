package ppppu 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
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
		private var currentHairLayerUsed:int = 0;
		public var anchoredDisplayObjectDict:Dictionary = new Dictionary();
		public var type:int;
		public var physicsType:uint;
		public static const SKINELEMENT:int = 1;
		public static const HAIRELEMENT:int = 2;
		private var latestAnimInfo:AnimationInfo = null;
		private var dirtyHairMovement:Boolean = false;
		
		private var xSpeed:Number = 0.0;
		private var ySpeed:Number = 0.0;
		//private static const MouthPercentOfFaceAtNeutral:Number = 20.8;
		public function AnchoredElementBase(elementName:String, elementType:int = 0, physics:uint = AnchorPhysicsEnum.FULLPHYSICS) 
		{
			gotoAndStop(1);
			addEventListener(Event.ADDED_TO_STAGE, Initialize);
			name = elementName;
			type = elementType;
			physicsType = physics;
			/*To avoid having the element shown for a small amount of time is an visual off place (usually top left of the screen) until
			its position is correct.*/
			this.visible = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function Initialize(e:Event):void
		{
			var displayObjBeingChecked:DisplayObjectContainer = this;
			while (displayObjBeingChecked != stage && !(displayObjBeingChecked is MasterTemplate))
			{
				displayObjBeingChecked = displayObjBeingChecked.parent;
				if (displayObjBeingChecked is MasterTemplate)
				{
					masterTemplate = displayObjBeingChecked as MasterTemplate;
					removeEventListener(Event.ADDED_TO_STAGE, Initialize);
				}
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
			if (masterTemplate && this.parent != null)
			{
				if (latestAnimInfo != masterTemplate.currentAnimationInfo)
				{
					dirtyHairMovement = true;
					latestAnimInfo = masterTemplate.currentAnimationInfo
				}
				var currentAnimationName:String = masterTemplate.currentAnimationName;
				var parentDisplayObj:DisplayObjectContainer = this.parent;
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
						basePlacementPoint = parentDisplayObj.globalToLocal(currentlyAnchoredObject["Element"].localToGlobal(currentDefinitionUsed.attachPoints[currentAnimationName]));
					}
					else
					{
						basePlacementPoint = parentDisplayObj.globalToLocal(currentlyAnchoredObject.localToGlobal(currentDefinitionUsed.attachPoints[currentAnimationName]));
					}
					//var basePlacementPoint:Point = currentlyAnchoredObject.localToGlobal(new Point(0, 0));
					this.x = basePlacementPoint.x; this.y = basePlacementPoint.y;

					//currentlyDisplayedSprite.x = basePlacementPoint.x; currentlyDisplayedSprite.y = basePlacementPoint.y;
					/*this.width = currentlyAnchoredObject.width * currentDefinitionUsed.scaleFactors[currentAnimationName][0];
					this.height = currentlyAnchoredObject.height * currentDefinitionUsed.scaleFactors[currentAnimationName][1];*/
					var anchoredObjBaseShapeWidth:Number = currentlyAnchoredObject.getChildAt(0).width;
					var anchoredObjBaseShapeHeight:Number = currentlyAnchoredObject.getChildAt(0).height;
					this.width = (anchoredObjBaseShapeWidth * currentlyAnchoredObject.scaleX) * currentDefinitionUsed.scaleFactors[currentAnimationName][0];
					this.height = (anchoredObjBaseShapeHeight * currentlyAnchoredObject.scaleY) * currentDefinitionUsed.scaleFactors[currentAnimationName][1];
					
					//need way to track rotation of face. try observing the difference in nose positioning for up/down head tilts.
					var animationMouth:Sprite = masterTemplate.Mouth;
					var animationHead:Sprite = masterTemplate.currentlyUsedHeadSprite;
					var headBounds:Rectangle = animationHead.getBounds(masterTemplate);
					var headHeight:Number = animationHead.height;
					var hMat:Matrix = animationHead.transform.matrix;
					var headSkewX:Number = Math.atan2( -hMat.c, hMat.d);
					var headSkewY:Number = Math.atan2( hMat.b, hMat.a);
					var headX:Number = animationHead.x;
					var headY:Number = animationHead.y;
					//var headWidth:Number = animationMouth.width;
					
					var mouthHeight:Number = animationMouth.height;
					var mMat:Matrix = animationMouth.transform.matrix;
					var mouthX:Number = animationMouth.x;
					var mouthY:Number = animationMouth.y;
					var mouthSkewX:Number = Math.atan2( -mMat.c, mMat.d);
					var mouthSkewY:Number = Math.atan2( mMat.b, mMat.a);
					var mouthDistanceFromFace:Number = Math.abs(mouthY - headBounds.bottom);
					var mouthPercentFromFace:Number = 100.0 / headHeight * mouthDistanceFromFace;
					
					
					//var mouthPercentDifferenceFromNeutral:Number = mouthPercentFromFace - MouthPercentOfFaceAtNeutral;
					//For Back
					//Face is upward: face Y:160.45 Hair Y:249.55 diff: 89.1
					//Face is neutral: face Y:193.3 Hair Y:263.35 diff: 70.05
					//Percent diff from upward and neutral: ~5%, meaning each % moves is about 4 pixels.
					//For Front
					//Face is upward: face Y:160.45 Hair Y:96.65 diff: 63.8
					//Face is neutral: face Y:193.3 Hair Y:129.95 diff: 63.35
					//Percent diff from upward and neutral: ~5%, meaning each % moves is about .11 pixels.
					var distanceToMoveHair:Number = 0.0;// mouthPercentDifferenceFromNeutral * 3.77;
					if (currentHairLayerUsed == HairDefinition.LAYER_BACK)
					{this.y += distanceToMoveHair; }
					//else if(currentHairLayerUsed == HairDefinition.LAYER_FRONT){distanceToMoveHair = mouthPercentDifferenceFromNeutral * .11; this.y -= distanceToMoveHair; }
					
				
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
			dirtyHairMovement = false;
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
		
		public function GetCurrentDepthPriority():Number
		{
			var depthOffsetValue:Number = 0.0;
			if (masterTemplate && masterTemplate.currentAnimationName in currentDefinitionUsed.depthPriorities)
			{
				depthOffsetValue = currentDefinitionUsed.depthPriorities[masterTemplate.currentAnimationName];
			}
			return depthOffsetValue;
		}
		
		public function GetHairLayerForAnimation(animationName:String):int
		{
			var layerId:int = -1;
			if (animationName in currentDefinitionUsed.layerPlacements)
			{
				layerId = currentDefinitionUsed.layerPlacements[animationName];
			}
			return layerId;
		}
		
		public function ChangeLayerDepth(layoutInfo:Object):void
		{
			if (masterTemplate && currentlyAnchoredObject)
			{
				var anchoredObjIndex:int = layoutInfo[currentlyAnchoredObject.name];
				var anchoredObjIndex2:int = masterTemplate.getChildIndex(currentlyAnchoredObject);
				var depthOffset:int = 0;
				if (masterTemplate.currentAnimationName in currentDefinitionUsed.depthPriorities)
				{
					depthOffset = currentDefinitionUsed.depthPriorities[masterTemplate.currentAnimationName];
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
		
		public function SetLayerId(layerNumber:int):void
		{
			currentHairLayerUsed = layerNumber;
		}
		
		public function GetCurrentLayerId():int
		{
			return currentHairLayerUsed;
		}
	}

}