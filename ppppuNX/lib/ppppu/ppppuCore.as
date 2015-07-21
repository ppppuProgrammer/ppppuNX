package ppppu 
{
	import avmplus.DescribeTypeJSON;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.registerClassAlias;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import ppppu.XmlMotionToTweens;
	import com.greensock.plugins.*;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.*;
	import flash.geom.Rectangle;
	import ppppu.TemplateBase;
	import flash.ui.Keyboard;
	import avmplus.describeTypeJSON;
	//import TemplateLayer.TemplateLayerInfo;
	/**
	 * Responsible for all the various aspects of ppppuNX. 
	 * @author ppppuProgrammer
	 */
	public class ppppuCore extends MovieClip
	{
		//Keeps track of which template is currently being displayed.
		//private var templateInUse:TemplateBase;
		private var masterTemplate:TemplateBase = new MasterTemplate();
		//Responsible for holding the various timelines that will be added to a template. This dictionary is 3 levels deep, which is expressed by: timelineDict[Character][Animation][Part]
		private var timelinesDict:Dictionary = new Dictionary();
		private var layerInfoDict:Dictionary = new Dictionary();
		//private var templateDict:Dictionary = new Dictionary();
		public var mainStage:MainStage;
		//Keeps track of what keys were pressed and/or held down
		var keyDownStatus:Array = [];
		var animationNameIndexes:Vector.<String> = new <String>["Cowgirl", "LeanBack", "LeanForward", "Grind", "ReverseCowgirl", "Paizuri", "Blowjob", "SideRide", "Swivel", "Anal"];
		var templateLayerInfo:Vector.<Object> = new Vector.<Object>(animationNameIndexes.length);
		//Constructor
		public function ppppuCore() 
		{
			
			//Create the "main stage" that holds the character template and various other movieclips such as the transition and backlight 
			mainStage = new MainStage();
			mainStage.stop();
			addChild(mainStage);
			//Add an event listener that'll allow for frame checking.
			//mainStage.addEventListener(Event.ENTER_FRAME, RunLoop);
			this.cacheAsBitmap = true;
			this.scrollRect = new Rectangle(0, 0, 480, 720);
			for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{

			}
			//Initialize();
			
		}
		
		public function Initialize():void
		{
			//Add the key listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleaseCheck);
			//Start by initializing plugins for the GSAP library
			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, TransformMatrixPlugin, VisiblePlugin]);
			//Creates the template animation movie clips and adds them to the templateDict dictionary.
			//SetupTemplates();
			//Initializing the various default motion xmls for the animation templates.
			CreateAnimationTimelinesForCharacter("Default");
			//CreateAnimationTimelinesForCharacter("Rosalina");
			mainStage.addChild(masterTemplate);
			mainStage.play();
		}
		
		private function RunLoop(e:Event):void
		{
			var mainStageMC:MovieClip = (e.target as MovieClip);
			if (mainStageMC.currentFrame == 2)
			{
				SwitchTemplateAnimation("Cowgirl");
				//templateInUse.UpdateTimelines();
				masterTemplate.PlayAnimation(mainStageMC.currentFrame);
				//templateInUse.PlayAnimation(mainStageMC.currentFrame);
			}
			//templateInUse.UpdateTimelines();
		}
		
		/*Responsible for processing all the motion xmls detailed in an animationMotions file, creating tweenLite tweens from them,
		 * and finally creating a timeline from those tweens and storing it in a dictionary*/
		private function ProcessMotionStaticClass(motionClass:Class, template:DisplayObject):Vector.<TimelineMax>
		{
			var timelineVector:Vector.<TimelineMax>;// = new Vector.<TimelineMax>();
			var templateAnimation:TemplateBase = template as TemplateBase;
			if (templateAnimation == null)
			{
				trace("Template animation is null for processing Motion Class: " + motionClass); 
				return null;
			}
			
			var charName:String = motionClass.CharacterName;
			var animName:String = motionClass.AnimationName;
			var layerInfo:String = motionClass.LayerInfo;
			if (layerInfo != null)
			{
				var layerInfoObject:Object = JSON.parse(layerInfo);
				if (layerInfoDict[charName] == null) { layerInfoDict[charName] = new Dictionary(); }
				layerInfoDict[charName][animName] = layerInfoObject;
			}
			//if(layerInfoDict[charName][animName] == null){layerInfoDict[charName][animName] = new Dictionary();}
			var xmlData:XMLList = describeType(motionClass).constant;
			//Navigate through xmlData to get the exact number of elements the timelines vector needs to accomodate for.
			var numberOfClassesInMotion:uint = 0;
			for (var index:int = 0, length:int = xmlData.length(); index < length; ++index)
			{
				if (xmlData[index].toXMLString().indexOf("type=\"Class\"") != -1)
				{
					++numberOfClassesInMotion;
				}
			}
			timelineVector = new Vector.<TimelineMax>(numberOfClassesInMotion);
			var tlVectorIndex:uint = 0;
			//Navigate through the xml data again, this time to create the timelines
			for (var i:int = 0, l:int = xmlData.length(); i < l; ++i)
			{
				var dataString:String = xmlData[i].toXMLString();
				var isClassObj:Boolean = (dataString.indexOf("type=\"Class\"") != -1);
				if (isClassObj)
				{
					var firstIndexOfQuote:int = dataString.indexOf("\"")+1;
					var xmlClassName:String = dataString.substring(firstIndexOfQuote, dataString.indexOf("\"", firstIndexOfQuote));
					var xmlClass:Class = motionClass[xmlClassName];
					var tweens:Vector.<TweenOrder> = XmlMotionToTweens.ConvertXmlToTweens(templateAnimation[xmlClassName], new XML(new xmlClass));
					var timelineForMotion:TimelineMax = new TimelineMax( { /*useFrames:true, */repeat: -1 } );
					//timelineForMotion.data = {xmlClassName};
					var tween:TweenOrder;
					for (var ti:int = 0, tl:int = tweens.length; ti < tl; ++ti)
					{
						tween = tweens[ti];
						if (tween.TargetObject != null)
						{
							timelineForMotion.data = { targetElement: tween.TargetObject };
							timelineForMotion.to(tween.TargetObject, tween.DurationFrames, tween.TweenVars, tween.StartFrame);
						}
						else
						{
							trace("Critical Warning! Animation " + animName + " is unable to target Element \"" + xmlClassName + "\"");
						}
					}
	
					if (timelinesDict[charName] == null)
					{
						timelinesDict[charName] = new Dictionary();
					}
					if (timelinesDict[charName][animName] == null)
					{
						timelinesDict[charName][animName] = new Dictionary();
					}
					
					timelinesDict[charName][animName][xmlClassName] = timelineForMotion;
					timelineVector[tlVectorIndex] = timelineForMotion;
					++tlVectorIndex;
					//timelineVector.push(timelineForMotion);
					timelineForMotion.pause();
				}
				//else
				//{
					//trace("Null!");
				//}
			}
			return timelineVector;
		}
		
		function KeyReleaseCheck(keyEvent:KeyboardEvent)
		{
			keyDownStatus[keyEvent.keyCode] = false;
		}
		function KeyPressCheck(keyEvent:KeyboardEvent)
		{
			var keyPressed:int = keyEvent.keyCode;
			if(keyDownStatus[keyPressed] == undefined || keyDownStatus[keyPressed] == false || (keyPressed == 48 || keyPressed == 96))
			{
				if((keyPressed == 48 || keyPressed == 96))
				{
					var randomAnimIndex:int = Math.floor(Math.random() * animationNameIndexes.length + 1);
					SwitchTemplateAnimation(animationNameIndexes[randomAnimIndex]);
				}
				else if((!(49 > keyPressed) && !(keyPressed > 57)) ||  (!(97 > keyPressed) && !(keyPressed > 105)))
				{
					//keypress of 1 has a keycode of 49
					if(keyPressed > 96)
					{
						keyPressed = keyPressed - 48;
					}
					SwitchTemplateAnimation(animationNameIndexes[keyPressed - 49]);
				}
			}
			keyDownStatus[keyEvent.keyCode] = true;
		}
		
		//master template version
		private function SwitchTemplateAnimation(animationName:String):void
		{
			//var animationDictKey:Object;
			//var animationDictionary:Dictionary = timelinesDict["Default"][animationName];
			//var t
			var defaultLayerInfo:Object = layerInfoDict["Default"][animationName];
			var templateChildrenCount:uint = masterTemplate.numChildren;
			var templateElements:Vector.<DisplayObject> = new Vector.<DisplayObject>(templateChildrenCount);
			var ShaftMask:DisplayObject = null;
			var Shaft:DisplayObject = null;
			var HeadMask:DisplayObject = null;
			var Head:DisplayObject = null;
			for (var i:uint = 0; i < templateChildrenCount; ++i)
			{
				templateElements[i] = masterTemplate.getChildAt(i);
			}
			/*TODO: Depth swapping doesn't work as well as it should the first go. Current needs to be done twice for the same animation
			 to look right.*/ 
			for (var childIndex:uint = 0; childIndex < templateChildrenCount; ++childIndex)
			{
				//var element:DisplayObject = masterTemplate.getChildAt(childIndex);
				var element:DisplayObject = templateElements[childIndex];
				element.visible = false;
				var elementName:String = element.name;
				/*var intTest:int = defaultLayerInfo["F0"][elementName];
				var intTest2:int = defaultLayerInfo.F0.elementName;
				var intTest3:int = defaultLayerInfo.F0[elementName];*/
				if (elementName in defaultLayerInfo.F0)
				{
					masterTemplate.setChildIndex(element, templateChildrenCount - 1 -defaultLayerInfo.F0[elementName]);
					//Mask checking
					
					//Shaft
					if (elementName.indexOf("PenisShaft") != -1 && elementName.indexOf("Mask") != -1)
					{
						ShaftMask = element;
					}
					else if (elementName.indexOf("PenisShaft") != -1)
					{
						Shaft = element;
					}
					
					//Head
					if (elementName.indexOf("PenisHead") != -1 && elementName.indexOf("Mask") != -1)
					{
						HeadMask = element;
					}
					else if (elementName.indexOf("PenisHead") != -1)
					{
						Head = element;
					}
				}
				else
				{
					masterTemplate.setChildIndex(element, 0);
				}
				/*if (element.name == "Male_PenisHead")
				{
					if (animationName == "Blowjob" || animationName == "Paizuri")
					{
						element.mask = masterTemplate.getChildByName("Male_PenisHeadMask2");
					}
					else
					{
						element.mask = masterTemplate.getChildByName("Male_PenisHeadMask");
					}
				}
				else if (element.name == "Male_PenisShaft")
				{
					if (element.mask == null && animationName != "Paizuri")
					{
						element.mask = masterTemplate.getChildByName("Male_PenisShaftMask");
					}
					else if(animationName == "Paizuri")
					{
						element.mask = null;
					}
				}*/
			}
			/*trace("Top elements");
			for (var childIndex2:int = templateChildrenCount -1; childIndex2 >= 0; --childIndex2)
			{
				trace(masterTemplate.getChildAt(childIndex2).name);
				//if(
			}
			trace("Bottom elements");*/
			if (Shaft && ShaftMask)
			{
				Shaft.mask = ShaftMask;
			}
			else if (Shaft && !ShaftMask)
			{
				Shaft.mask = null;
			}
			
			if (Head && HeadMask)
			{
				Head.mask = HeadMask;
			}
			else if (Head && !HeadMask)
			{
				Head.mask = null;
			}
			for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{
				if (animationName == animationNameIndexes[i])
				{
					masterTemplate.ChangeDefaultTimelinesUsed(i);
				}
			}
			//Sync the animation to the main stage's timeline (main stage's current frame - animation start frame % 120 + 1 to avoid setting it to frame 0)
			//templateInUse.gotoAndPlay((mainStage.currentFrame -2) % 120 + 1);
			masterTemplate.PlayAnimation((mainStage.currentFrame -2) % 120 + 1);
			//addChild(templateInUse);
		}
		
		/*private function SwitchTemplateAnimation(animationName:String):void
		{
			if (templateInUse != null)
			{
				if (this.contains(templateInUse))
				{
					templateInUse.StopAnimation();
					templateInUse.stop();
					removeChild(templateInUse);
				}
			}
			//Go to the desired animation
			var templateAnimation:TemplateBase = templateDict[animationName] as TemplateBase;
			if (templateAnimation)
			{
				templateInUse = templateAnimation;
			}
			else
			{
				trace("Unable to find template for animation: " + animationName);
				return;
			}
			//Sync the animation to the main stage's timeline (main stage's current frame - animation start frame % 120 + 1 to avoid setting it to frame 0)
			templateInUse.gotoAndPlay((mainStage.currentFrame -2) % 120 + 1);
			templateInUse.PlayAnimation(templateInUse.currentFrame);
			addChild(templateInUse);
		}*/
		
		//master template version
		private function CreateAnimationTimelinesForCharacter(characterName:String):void
		{
			//Reference to the class that has the embed motion xmls
			var animationMotion:Class;
			var packagePath:String = "MotionXML." + characterName + ".";
			var fullClassPath:String;
			var animationName:String;
			for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{
				animationName = animationNameIndexes[i];
				fullClassPath = packagePath + characterName + animationName + "Motions";
				try
				{
					animationMotion = getDefinitionByName(fullClassPath) as Class;
				}
				catch (e:ReferenceError)
				{
					animationMotion = null;
					trace("Character " + characterName + " has no animation motion definition for animation: " + animationName);
				}
				if (animationMotion != null)
				{
					//Checks if the character name is Default. If so, also set these timelines to be the default timelines for the template
					if (characterName == "Default")
					{
						masterTemplate.SetDefaultTimelines(ProcessMotionStaticClass(animationMotion, masterTemplate), i);
					}
					else //Otherwise just add the timelines to the timelines dictionary
					{
						ProcessMotionStaticClass(animationMotion, masterTemplate);
					}
				}
			}
		}
		
		//Attempts to create animation timelines of a template for the specified character. Original version
		/*private function CreateAnimationTimelinesForCharacter(characterName:String):void
		{
			//Reference to the class that has the embed motion xmls
			var animationMotion:Class;
			var packagePath:String = "MotionXML." + characterName + ".";
			//Looks through the frames of the template controller. Starts at 1 to ignore the first frame, which has no template.
			var animationKey:Object;
			var templateAnimation:TemplateBase;
			for (animationKey in templateDict)
			{
				templateAnimation = templateDict[animationKey] as TemplateBase;
				var fullClassPath:String = packagePath + characterName + (animationKey as String) + "Motions";
				
				try
				{
					animationMotion = getDefinitionByName(fullClassPath) as Class;
				}
				catch (e:ReferenceError)
				{
					animationMotion = null;
					trace("Character " + characterName + " has no animation motion definition for animation: " + (animationKey as String));
				}
				if (animationMotion != null)
				{
					//Checks if the character name is Default. If so, also set these timelines to be the default timelines for the template
					if (characterName == "Default")
					{
						
						templateAnimation.SetDefaultTimelines(ProcessMotionStaticClass(animationMotion, templateAnimation));
					}
					else //Otherwise just add the timelines to the timelines dictionary
					{
						ProcessMotionStaticClass(animationMotion, templateAnimation);
					}
				}
			}
		}*/
		
		/*private function SetupTemplates()
		{
			masterTemplate = new MasterTemplate();
			var jsonMotion:Class;
			var packagePath:String = "TemplateLayer.";
			var fullClassPath:String;
			var animationName:String;
			//var test:TemplateLayerInfo = new TemplateLayerInfo();
			//test.
			for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{
				animationName = animationNameIndexes[i];
				fullClassPath = packagePath + animationName + "LayerInfo";
				try
				{
					jsonMotion = getDefinitionByName(fullClassPath) as Class;
				}
				catch (e:ReferenceError)
				{
					jsonMotion = null;
					//trace("Character " + characterName + " has no animation motion definition for animation: " + animationName);
				}
				if (jsonMotion != null)
				{
					templateLayerInfo[i] = JSON.parse(new jsonMotion());
				}
			}
		}*/
		
		function printObject(obj:Object, numTabs:int=0): void
		{
			var tabs:String = "";
			for (var i:int = 0; i < numTabs; ++i)
			{
				tabs += "\t";
			}
			for (var k:* in obj)
			{
				var v:* = obj[k];
				trace(tabs + k + " = " + v);
				if (v)
				{
					printObject(v, numTabs+1);
				}
			}
		}
	}

}