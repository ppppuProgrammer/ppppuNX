package ppppu 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.IGraphicsData;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.Dictionary;
	import flash.utils.*;
	//import ppppu.HueColorMatrixFilter;
	/**
	 * Rewrite of the TemplateGraphicsManager. Holds graphic sets for animations (different color skin, costumes).
	 * Traverses through the children of a template animation and changes the graphics these children to the appropriate graphic from a graphic set.
	 * @author 
	 */
	
	public class GraphicsManager 
	{
		private var bodyGraphicNames:Vector.<String> = new Vector.<String>;
		private var hairGraphicNames:Vector.<String> = new Vector.<String>;
		private var characterGraphicNames:Vector.<String> = new Vector.<String>;
		private var accessoryGraphicNames:Vector.<String> = new Vector.<String>;
		//private static var costumeGraphicNames:Vector.<String> = new Vector.<String>;
		//Refers which graphic set to use for a specific character.
		//Key = Character Name, Value = prefix for the character's graphic set.
		//example: Peach = "Base" & Shantae = "Shantae", meaning the neck graphic is to use "Base_Neck" for Peach and "Shantae_Neck" for Shantae
		private var characterGraphicSet:Dictionary = new Dictionary();
		//Dictionary that holds a graphic set (Vector)
		private var graphicSets_Body:Dictionary = new Dictionary();
		//private var graphicSets_CustomBody:Dictionary = new Dictionary();
		private var graphicSets_Hair:Dictionary = new Dictionary();
		private var graphicSets_Character:Dictionary = new Dictionary(); //For character specific graphics, like eye color, eyebrows and leggings.
		private var graphicSets_Accessory:Dictionary = new Dictionary();
		private var graphicSets_Costumes:Dictionary = new Dictionary();
		public static const BODYSETTYPE:String = "BODYSET";
		public static const HAIRSETTYPE:String = "HAIRSET";
		public static const EYESETTYPE:String = "CHARACTERSET";
		public static const ACCESSORYSETTYPE:String = "ACCESSORYSET";
		public static const COSTUMESETTYPE:String = "COSTUMESET";
		private static const DEFAULTSTRING:String = "Def_";
		public static const CUSTOMSETSTRING:String = "Custom_";
		public function GraphicsManager() 
		{
			//Body part names with an "_LR" appended to them indicate that there are a left and right version of them used in the animation and to look for 
			bodyGraphicNames.push("ButtCheek", "ButtCheekL", "ButtCheekR", "MidBack", "LowerBack", "UpperBack", "SideBoob", "SideBoobL", "SideBoobR","Nipple", "NippleL", "NippleR",/*"Face",*/ "Arm", "ArmL", "ArmR",
			"Forearm", "ForearmL", "ForearmR", "Ear", "EarL", "EarR","UpperLeg", "UpperLegL", "UpperLegR", "Neck", "Shoulder", "ShoulderL", "ShoulderR","Vulva", "Anus", 
			"Hand", "HandL", "HandR", "Nose", "Sclera", "ScleraL", "ScleraR", "FaceSkin", "Eyelid", "EyelidL", "EyelidR", "TurnedNose", "FrontButt", "Groin", "Labia", "BlankFace", "Clavicle", "Chest",
			"Boob", "Navel", "Areola", "Hips");
			hairGraphicNames.push("HairSide", "HairSide2", "HairSide3", "HairSideL", "HairSide2L", "HairSide3L", "HairSideR", "HairSide2R", "HairSide3R", "HairFront", "HairFrontAngled", "HairBack", "HeadHair");
			characterGraphicNames.push("LowerLeg", "LowerLegL", "LowerLegR", "Eyebrow", "EyebrowL", "EyebrowR", "Eyelash", "EyelashL", "EyelashR", "Eye", "EyeL", "EyeR", "Eyeball", "EyeballL", "EyeballR");
			accessoryGraphicNames.push("Headwear", "HeadwearAlt", "Earring", "EarringR", "EarringL");
			
			//CreateGraphicSet("NoAccessories", ACCESSORYSETTYPE, true);
		}
		
		//TODO Make A Thorough Set Change Function
		
		public function ChangeBodySetForAnimation(animation:AnimationOldVer, bodySetName:String, customSet:Boolean = false)
		{
			//if (animation.currentBodySet == bodySetName)
			//{
				//return; //No need to run this function.
			//}
			//Get character's set
			var origSetName:String = bodySetName;
			var characterBodySet:Dictionary;
			if (customSet)
			{
				bodySetName = GraphicsManager.CUSTOMSETSTRING + bodySetName;
			}
			characterBodySet = graphicSets_Body[bodySetName];
			if (characterBodySet )
			{
				RecursivelyApplyGraphicSet(animation.templateAnimation, characterBodySet);
				animation.currentBodySet = origSetName;
			}
		}
		public function ChangeHairSetForAnimation(animation:AnimationOldVer, hairSetName:String, customSet:Boolean = false)
		{
			//Get character's set
			var characterHairSet:Dictionary;
			if (customSet)
			{
				hairSetName = GraphicsManager.CUSTOMSETSTRING + hairSetName;
			}
			characterHairSet = graphicSets_Hair[hairSetName];
			if (characterHairSet)
			{
				RecursivelyApplyGraphicSet(animation.templateAnimation,characterHairSet);
				animation.currentHairSet = hairSetName;
			}
		}
		public function ChangeEyeSetForAnimation(animation:AnimationOldVer, eyeSetName:String, customSet:Boolean = false)
		{
			//Get character's set
			var characterEyeSet:Dictionary;
			if (customSet)
			{
				eyeSetName = GraphicsManager.CUSTOMSETSTRING + eyeSetName;
			}
			characterEyeSet = graphicSets_Character[eyeSetName];
			if (characterEyeSet)
			{
				RecursivelyApplyGraphicSet(animation.templateAnimation,characterEyeSet);
				animation.currentEyeSet = eyeSetName;
			}
		}
		
		public function ChangeAccessorySetForAnimation(animation:AnimationOldVer, accessorySetName:String, customSet:Boolean = false)
		{
			//Get character's set
			var characterAccessorySet:Dictionary;
			if (customSet)
			{
				accessorySetName = GraphicsManager.CUSTOMSETSTRING + accessorySetName;
			}
			characterAccessorySet = graphicSets_Accessory[accessorySetName];
			if (characterAccessorySet)
			{
				RecursivelyApplyGraphicSet(animation.templateAnimation, characterAccessorySet);
				animation.currentEyeSet = accessorySetName;
			}
		}
		
		public function CreateGraphicSet(setName:String, setType:String, createCustomSet:Boolean=false)
		{
			var createdGfxSet:Dictionary = null;
			if (createCustomSet == true)
			{
				setName = CUSTOMSETSTRING + setName;
			}
			if (setType == BODYSETTYPE)
			{
				if (graphicSets_Body[setName] == null)
				{
					createdGfxSet = new Dictionary();
					graphicSets_Body[setName] = createdGfxSet;
				}
			}
			else if (setType == HAIRSETTYPE)
			{
				if (graphicSets_Hair[setName] == null)
				{
					createdGfxSet = new Dictionary();
					graphicSets_Hair[setName] = createdGfxSet;
				}
			}
			else if (setType == EYESETTYPE)
			{
				if (graphicSets_Character[setName] == null)
				{
					createdGfxSet = new Dictionary();
					graphicSets_Character[setName] = createdGfxSet;
				}
			}
			else if (setType == ACCESSORYSETTYPE)
			{
				if (graphicSets_Accessory[setName] == null)
				{
					createdGfxSet = new Dictionary();
					graphicSets_Accessory[setName] = createdGfxSet;
				}
			}
			else if (setType == COSTUMESETTYPE)
			{
				if (graphicSets_Costumes[setName] == null)
				{
					createdGfxSet = new Dictionary();
					graphicSets_Costumes[setName] = createdGfxSet;
				}
			}
			if (createdGfxSet != null /*&& createCustomSet == false*/)
			{
				if (createCustomSet) //Remove the "Custom_" from setname so it can search the flash for graphics
				{
					setName = setName.replace(CUSTOMSETSTRING, "");
				}
				FindGraphicsForSet(setName, createdGfxSet, setType);
			}
		}
		
		public function CopyGraphicSetToCustomSet(setName:String, customSetName:String, setType:String, overwriteExistingGfx:Boolean = false)
		{
			var baseGraphicSet:Dictionary = null;
			var customGraphicSet:Dictionary = null;
			customSetName = GraphicsManager.CUSTOMSETSTRING + customSetName;
			if (setType == BODYSETTYPE)
			{
				baseGraphicSet = graphicSets_Body[setName];
				customGraphicSet = graphicSets_Body[customSetName];
			}
			else if (setType == HAIRSETTYPE)
			{
				baseGraphicSet = graphicSets_Hair[setName];
				customGraphicSet = graphicSets_Hair[customSetName];
			}
			else if (setType == EYESETTYPE)
			{
				baseGraphicSet = graphicSets_Character[setName];
				customGraphicSet = graphicSets_Character[customSetName];
			}
			else if (setType == ACCESSORYSETTYPE)
			{
				baseGraphicSet = graphicSets_Accessory[setName];
				customGraphicSet = graphicSets_Accessory[customSetName];
			}
			/*else if (setType == COSTUMESETTYPE)
			{
				baseGraphicSet = graphicSets_Costume[setName];
				customGraphicSet = graphicSets_Costume[customSetName];
			}*/
			if (customGraphicSet != null && baseGraphicSet != null)
			{
				for (var graphicName:Object in baseGraphicSet)
				{
					var sprite:Sprite = baseGraphicSet[graphicName];
					if (overwriteExistingGfx == true || customGraphicSet[graphicName] == null)
					{
						customGraphicSet[graphicName] = sprite;
					}
				}
			}
		}
		
		public function CopySpecificGraphicToCustomSet(setName:String, customSetName:String, setType:String, graphicName:String)
		{
			var baseGraphicSet:Dictionary = null;
			var customGraphicSet:Dictionary = null;
			customSetName = GraphicsManager.CUSTOMSETSTRING + customSetName;
			if (setType == BODYSETTYPE)
			{
				baseGraphicSet = graphicSets_Body[setName];
				customGraphicSet = graphicSets_Body[customSetName];
			}
			else if (setType == HAIRSETTYPE)
			{
				baseGraphicSet = graphicSets_Hair[setName];
				customGraphicSet = graphicSets_Hair[customSetName];
			}
			else if (setType == EYESETTYPE)
			{
				baseGraphicSet = graphicSets_Character[setName];
				customGraphicSet = graphicSets_Character[customSetName];
			}
			else if (setType == ACCESSORYSETTYPE)
			{
				baseGraphicSet = graphicSets_Accessory[setName];
				customGraphicSet = graphicSets_Accessory[customSetName];
			}
			/*else if (setType == COSTUMESETTYPE)
			{
				baseGraphicSet = graphicSets_Costume[setName];
				customGraphicSet = graphicSets_Costume[customSetName];
			}*/
			
			var graphic:Sprite = baseGraphicSet[graphicName];
			if (graphic)
			{
				customGraphicSet[graphicName] = graphic;
			}
		}
		
		public function RemoveSpecificGraphicFromCustomSet(customSetName:String, setType:String, graphicName:String)
		{
			var customGraphicSet:Dictionary = null;
			customSetName = GraphicsManager.CUSTOMSETSTRING + customSetName;
			if (setType == BODYSETTYPE)
			{
				customGraphicSet = graphicSets_Body[customSetName];
			}
			else if (setType == HAIRSETTYPE)
			{
				customGraphicSet = graphicSets_Hair[customSetName];
			}
			else if (setType == EYESETTYPE)
			{
				customGraphicSet = graphicSets_Character[customSetName];
			}
			else if (setType == ACCESSORYSETTYPE)
			{
				customGraphicSet = graphicSets_Accessory[customSetName];
			}
			/*else if (setType == COSTUMESETTYPE)
			{
				baseGraphicSet = graphicSets_Costume[setName];
				customGraphicSet = graphicSets_Costume[customSetName];
			}*/
			customGraphicSet[graphicName] = null;
		}
		
		public function AddColorParameterForSet(setName:String, setType:String, parameterName:String, parameterValue:* )
		{
			var gfxSet:Dictionary;
			if (setType == BODYSETTYPE /*|| setType == COSTUMESETTYPE*/)
			{gfxSet = graphicSets_Body[setName];}
			else if (setType == HAIRSETTYPE)
			{gfxSet = graphicSets_Hair[setName];}
			else if (setType == EYESETTYPE)
			{gfxSet = graphicSets_Character[setName];}
			else if (setType == ACCESSORYSETTYPE)
			{gfxSet = graphicSets_Accessory[setName]; }
			
			if (gfxSet)
			{
				gfxSet[parameterName] = parameterValue;
			}
		}
		
		public function FindGraphicsForSet(setName:String, graphicSet:Dictionary, setType:String )
		{
			if (graphicSet == null) //Wasn't supplied, don't try to find it
			{
				return;
			}
			var graphicClass:Class = null;
			var graphicNames:Vector.<String> 
			
			if (setType == BODYSETTYPE || setType == COSTUMESETTYPE)
			{graphicNames = bodyGraphicNames;}
			else if (setType == HAIRSETTYPE)
			{graphicNames = hairGraphicNames;}
			else if (setType == EYESETTYPE)
			{graphicNames = characterGraphicNames;}
			else if (setType == ACCESSORYSETTYPE)
			{graphicNames = accessoryGraphicNames;}
		
			for (var i:int = 0, l:int = graphicNames.length; i < l; ++i)
			{
				try
				{
					var className:String = setName+graphicNames[i];
					graphicClass = getDefinitionByName(className) as Class;
					if (graphicClass) //Found the class
					{
						var createdSprite:Object = new graphicClass();
						if (createdSprite)
						{
							graphicSet[graphicNames[i]] = createdSprite as Sprite;
						}
					}
				}
				catch (e:ReferenceError)
				{
					graphicClass = null;
				}
				
			}
		}
		
		public function RecursivelyApplyGraphicSet(dispObj:Sprite, graphicSetToUse:Dictionary)
		{
			for (var counter:int = 0, length:int = dispObj.numChildren; counter < length; ++counter)
			{
				var spriteTest:Sprite = dispObj.getChildAt(counter) as Sprite;
				if (spriteTest)
				{
					RecursivelyApplyGraphicSet(spriteTest, graphicSetToUse);
				}
			}
			
			//Make sure the display object is not a clip container. They are meant to be invisible when it doesn't contain a movie clip 
			//and the ReplaceGraphics call will mess with this.
			var clipContainerTest:ClipContainer = dispObj as ClipContainer;
			//var child:DisplayObject = animation.templateAnimation.getChildAt(i);
			if (dispObj && !clipContainerTest)
			{
				var name:String = dispObj.name;
				if (name != null)
				{
					if (name.indexOf("SkinDef") >= 0)
					{
						var gfxSetParameter = graphicSetToUse["SkinColor"];
						var HCMFParameter:HueColorMatrixFilter = gfxSetParameter as HueColorMatrixFilter;
						var CMFParameter:ColorMatrixFilter = gfxSetParameter as ColorMatrixFilter;
						if (HCMFParameter)
						{
							dispObj.filters = [HCMFParameter.Filter]
							
						}
						else if (CMFParameter)
						{
							dispObj.filters = [CMFParameter];
						}
						else
						{
							dispObj.filters = [];
						}
					}
					else
					{
						var spriteNeeded:Sprite = graphicSetToUse[SanitizePartDefineName(name)];
						if (spriteNeeded == null) //Backup
						{
							var directionCheck:String = name.charAt(name.length-1);
							if (directionCheck == "R" || directionCheck == "L")
							{
								spriteNeeded = graphicSetToUse[SanitizePartDefineName(name.substring(0,name.length - 1))];
							}
						}
						if (spriteNeeded != null)
						{
							ReplaceGraphics(spriteNeeded, dispObj);
						}
					}
				}
			}
		}
		
		//SourceObj - object that contains the shape to copy from
		//targetObj - Object that contains the shape to replace
		function ReplaceGraphics(sourceObj:DisplayObject, targetObj:DisplayObject)
		{
			//var sourceObj:DisplayObject = FindShapeOfDisplayObject(sourceDispObj);
			//var targetObj:DisplayObject = FindShapeOfDisplayObject(targetDispObj);
			if (sourceObj && targetObj)
			{
				var spriteTest:Sprite = sourceObj as Sprite;
				if (spriteTest) //Is a sprite or movieclip with multiple shape instances.
				{
					var targetAsSprite:Sprite = targetObj as Sprite;
					var shapeData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
					shapeData = spriteTest.graphics.readGraphicsData(true);
					var newShape:Shape = new Shape();
					newShape.graphics.clear();
					newShape.graphics.drawGraphicsData(shapeData);
					targetAsSprite.removeChildren();
					targetAsSprite.addChild(newShape);
				}
				else //Is likely a shape
				{
					var targetAsShape:Shape = targetObj as Shape;
					if (targetAsShape)
					{
						var data:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
						data = (sourceObj as Shape).graphics.readGraphicsData();
						targetAsShape.graphics.clear();
						targetAsShape.graphics.drawGraphicsData(data);
					}
				}
			}
		}
		//Converts a template definition name ("Def_HandR") into a graphic set friendly name ("HandR") 
		private function SanitizePartDefineName(dirtyName:String):String
		{
			var retString:String="";
			var firstUnderscoreIndex = dirtyName.indexOf("_");
			var lastUnderscoreIndex = dirtyName.lastIndexOf("_");
			if (firstUnderscoreIndex == lastUnderscoreIndex) //Only 1 underscore
			{
				var instanceType:String = dirtyName.substring(0, firstUnderscoreIndex);
				if (instanceType == "ColorDef" || instanceType == "LinesDef" || instanceType == "SkinDef" || instanceType == "ShineDef")
				{
					retString = null;
				}
				else
				{
					retString = dirtyName.substring(firstUnderscoreIndex + 1);
				}
				
			}
			else
			{
				retString = dirtyName.substring(firstUnderscoreIndex+1, lastUnderscoreIndex);
			}
			
			return retString; 
		}
	}
}