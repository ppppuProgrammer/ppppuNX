package ppppu 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import ppppu.ClipContainer;
	import flash.display.Sprite;
	import flash.utils.*;
	/**
	 * Hold various information needed to set an animation for a character.
	 * @author 
	 */
	public class AnimationOldVer 
	{
		//private var parentMC:MovieClip=null; 
		public var templateAnimation:MovieClip; //The base animation to work off of
		/*Changes what motion movie clips to search. For cases where a template animation is used more than once per character. 
		 **/
		private static var m_motionClipContainer:MotionClipCatalog;
		var animationVariantName:String; 
		private static var motionPartNames:Vector.<String> = new Vector.<String>();
		motionPartNames.push("EarringR", "EarringL", "Headwear", "HeadwearAlt", "HairSideL", "HairSide2L", "HairSide3L", "HairSideR", "HairSide2R", 
		"HairSide3R", "HairFront", "HairBack", "EyeL", "EyeR", "EyebrowL", "EyebrowR", "Mouth", "ArmR", "ForearmR", "HandR", "EyelidR");
		//For elements of an animation that changes position or its look (like eyes, hair) 
		var motionClips:Vector.<MovieClip> = new Vector.<MovieClip>(motionPartNames.length, true);
		private var clipContainers:Vector.<ClipContainer> = new Vector.<ClipContainer>(motionPartNames.length, true);
		public var currentBodySet:String;
		public var currentEyeSet:String; //Never changes
		public var currentHairSet:String;
		public var currentAccessorySet:String;
		private var currentCostumeSet:String;
		public var flippedAnimation:Boolean = false;
		public var characterName:String;
		public function AnimationOldVer(baseAnimation:MovieClip, charName:String, variantName:String=null) 
		{
			templateAnimation = baseAnimation;
			RecursivelyDisableMouseInteractivity(templateAnimation);
			animationVariantName = variantName;
			characterName = charName;
			var motionClipPrefix:String;
			if (animationVariantName == null) //Not a variation from
			{
				//Search for this character's motion clips
				motionClipPrefix = characterName + "_" + baseAnimation.name + "_";
			}
			else
			{
				motionClipPrefix = characterName + "_" + variantName + "_";
			}
			//Speed up motion clip removal and adding by storing a reference to the clip container, avoiding (relatively) costly getChildByName calls later on
			var clipClass:Class = null;
			for (var index:int = 0, length = motionPartNames.length; index < length; ++index ) 
			{
				var partName = motionPartNames[index];
				var container:ClipContainer = baseAnimation.getChildByName("MotionDef_" + partName) as ClipContainer;
				if (container != null)
				{
					clipContainers[index] = container;
					//Has a container, can try to find the motion clip that'll go in the container.
					try
					{
						var className:String = motionClipPrefix+partName;
						clipClass = getDefinitionByName(className) as Class;
					}
					catch (e:ReferenceError)
					{
						clipClass = null;
					}
					if (clipClass) //Found the class
					{
						var createdClip:Object = new clipClass();
						if (createdClip)
						{
							motionClips[index] = createdClip as MovieClip;
						}
					}
				}
			}
		}
		
		/*TODO Consider avoiding the creation (and later garbage collection) of extra motion clips by having a motion clip registry
		that holds a reference to the motion clips of all animations for all characters. This would ensure they are synced with the templates
		and avoid unnecessary memory operations.*/
		//If null, change back to the motion clip for this animation
		public function ChangeMotionClip(partName:String, sourceCharacter:String=null)
		{
			var container:ClipContainer = templateAnimation.getChildByName("MotionDef_" + partName) as ClipContainer;
			var motionClip:MovieClip;
			if (container != null)
			{
				//container.RemoveClipFromDisplay();
				if (sourceCharacter != null)
				{
					var clipClass:Class;
					try
					{
						var className:String = sourceCharacter+"_"+templateAnimation.name+"_"+partName;
						clipClass = getDefinitionByName(className) as Class;
					}
					catch (e:ReferenceError)
					{
						clipClass = null;
					}
					if (clipClass) //Found the class
					{
						var createdClip:Object = new clipClass();
						if (createdClip)
						{
							motionClip = createdClip as MovieClip;
						}
					}
					
				}
				else
				{
					var indexOfPart:int = motionPartNames.indexOf(partName);
					if (indexOfPart > -1 && indexOfPart < motionPartNames.length)
					{
						motionClip = motionClips[indexOfPart];
					}
				}
				if (motionClip)
				{
					if (sourceCharacter != null)
					{
						/*Clips created during runtime aren't properly synced to the template animation, they lag by a frame despite tell gotoandplay to 
						 * be the same current frame number that the template is on.
						i.e. template is on frame 120, the created clip will be on frame 119. This happens even when setting gotoandplay to the
						frame number of the template.*/
						var frameToGoto:int = templateAnimation.currentFrame+1;
						if (frameToGoto > templateAnimation.totalFrames)
						{
							frameToGoto %= templateAnimation.totalFrames;
						}
						motionClip.gotoAndPlay(frameToGoto);
					}
					
					container.SetClipForDisplaying(motionClip);
				}
			}
		}
		public function AddAnimationToDisplay(parentClip:Sprite)
		{
			//Check if already on parent
			if (templateAnimation.parent) 
			{ 
				RemoveMotionClipsFromTemplateAnimation();
				
				//this.RemoveAnimationFromDisplay(); 
			}
			AddMotionClipsToTemplateAnimation();
			parentClip.addChild(this.templateAnimation);
			if (flippedAnimation)
			{
				templateAnimation.scaleX = -1;
				templateAnimation.x = 480;
			}
			else
			{
				templateAnimation.scaleX = 1;
				templateAnimation.x = 0;
			}
		}
		public function RemoveAnimationFromDisplay()
		{
			if (templateAnimation.parent)
			{
				templateAnimation.parent.removeChild(templateAnimation);
				RemoveMotionClipsFromTemplateAnimation();
			}
		}
		public function AddMotionClipsToTemplateAnimation()
		{
			for (var i:int = 0, l:int = motionClips.length; i < l; ++i)
			{
				if (clipContainers[i] != null && motionClips[i] != null)
				{
					clipContainers[i].SetClipForDisplaying(motionClips[i]);
				}
			}
		}
		public function RemoveMotionClipsFromTemplateAnimation()
		{
			for (var i:int = 0, l:int = motionClips.length; i < l; ++i)
			{
				if (clipContainers[i] != null)
				{
					clipContainers[i].RemoveClipFromDisplay();
				}
			}
		}
		
		private function RecursivelyDisableMouseInteractivity(dispObj:DisplayObjectContainer)
		{
			for (var counter:int = 0, length:int = dispObj.numChildren; counter < length; ++counter)
			{
				var dispObjContainer:DisplayObjectContainer = dispObj.getChildAt(counter) as DisplayObjectContainer;
				if (dispObjContainer)
				{
					dispObjContainer.mouseEnabled = false;
					dispObjContainer.mouseChildren = false;
					if (dispObjContainer.numChildren > 0)
					{
						RecursivelyDisableMouseInteractivity(dispObjContainer);
					}
				}
			}
			//DisplayObjectContainer;
			
		}
	}
}