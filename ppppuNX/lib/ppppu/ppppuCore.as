package ppppu 
{
	import com.greensock.easing.Linear;
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
	/**
	 * Responsible for all the various aspects of ppppuNX. 
	 * @author ppppuProgrammer
	 */
	public class ppppuCore extends MovieClip
	{
		//A movie clip that holds all the body elements used to create an animation. The elements in this class are controlled
		//TODO: Test the extendability of the master template. Can custom elements be easily added to it without big issues?
		private var masterTemplate:TemplateBase = new MasterTemplate();
		//Responsible for holding the various timelines that will be added to a template. This dictionary is 3 levels deep, which is expressed by: timelineDict[Character][Animation][Part]
		private var timelinesDict:Dictionary = new Dictionary();
		private var layerInfoDict:Dictionary = new Dictionary();
		public var mainStage:MainStage;
		//Keeps track of what keys were pressed and/or held down
		private var keyDownStatus:Array = [];
		//Contains the names of the various animations that the master template can switch between. The names are indexed by their position in the vector.
		private var animationNameIndexes:Vector.<String> = new <String>["Cowgirl"/*, "LeanBack", "LeanForward", "Grind", "ReverseCowgirl", "Paizuri", "Blowjob", "SideRide", "Swivel", "Anal"*/];
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
			/*for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{

			}*/
			//Initialize();
			
		}
		
		//Sets up the various aspects of the flash to get it ready for performing.
		public function Initialize():void
		{
			//Add the key listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleaseCheck);
			//Start by initializing plugins for the GSAP library
			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, TransformMatrixPlugin, VisiblePlugin]);
			TweenLite.defaultEase = Linear.easeNone;
			//Creates the template animation movie clips and adds them to the templateDict dictionary.
			//SetupTemplates();
			//Initializing the various default motion xmls for the animation templates.
			CreateAnimationTimelinesForCharacter("Default");
			
			//CreateAnimationTimelinesForCharacter("Rosalina");
			mainStage.addChild(masterTemplate);
			/*TODO: Cycle through all templates (default at the minimum) to "warm up", as there can be a rather noticable 
			delay (on my toaster of a computer) between switching to a templated animation for the first time*/
			mainStage.play();
		}
		
		//The "heart beat" of the flash. Ran every frame to monitor and react to certain, often frame sensitive, events
		private function RunLoop(e:Event):void
		{
			var mainStageMC:MovieClip = (e.target as MovieClip);
			//2nd frame is the start point of the animations and playing of Beep block skyway.
			if (mainStageMC.currentFrame == 2)
			{
				//Go to the 
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
			
			var charName:String = motionClass.CharacterName; //Character the animation motion is for
			var animName:String = motionClass.AnimationName; //The type of animation template that the animation motion is for
			var layerInfo:String = motionClass.LayerInfo; //Contains information that is used to rearrange the depth of elements displayed.
			
			//LayerInfo was found, so process it
			if (layerInfo != null)
			{
				//LayerInfo strings are in JSON format, which is parsed as an Object
				var layerInfoObject:Object = JSON.parse(layerInfo);
				//If the layer info dictionary for the character doesn't exist, create it.
				if (layerInfoDict[charName] == null) { layerInfoDict[charName] = new Dictionary(); }
				//Set the layer info for an animation of the character
				layerInfoDict[charName][animName] = layerInfoObject;
			}
			
			//Get constants defined in the animation motion as an XML list
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
					var tweens:Array = XmlMotionToTweens.ConvertXmlToTweens(templateAnimation[xmlClassName], new XML(new xmlClass));
					var timelineForMotion:TimelineMax = new TimelineMax( { /*useFrames:true, */repeat: -1 } );
					var tween:TweenLite = tweens[0] as TweenLite;

					if (tween.target != null)
					{
						timelineForMotion.data = { targetElement: tween.target };
						timelineForMotion.add(tweens,"+=0", "sequence");
					}
					else
					{
						trace("Critical Warning! Animation " + animName + " is unable to target Element \"" + xmlClassName + "\"");
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
					timelineForMotion.pause();
				}
			}
			return timelineVector;
		}
		
		//Activated if a key is detected to be released. Sets the keys "down" status to false
		private function KeyReleaseCheck(keyEvent:KeyboardEvent):void
		{
			keyDownStatus[keyEvent.keyCode] = false;
		}
		
		/*Activated if a key is detected to be pressed and after processing logic, sets the keys "down" status to true. If this is the first 
		frame a key is detected to be down, perform the action related to that key, unless the random animation key is held down. Though 
		it was an unintentional oversight at first, people were amused by this, so it has been kept as a feature.*/
		private function KeyPressCheck(keyEvent:KeyboardEvent):void
		{
			var keyPressed:int = keyEvent.keyCode;
			if (keyPressed == Keyboard.LEFT)
			{
				mainStage.prevFrame();
				masterTemplate.JumpToFrameAnimation(mainStage.currentFrame);
				trace("Frame: " + (((mainStage.currentFrame-1) % 120)+1));
			}
			else if (keyPressed == Keyboard.RIGHT)
			{
				mainStage.nextFrame();
				masterTemplate.JumpToFrameAnimation(mainStage.currentFrame);
				trace("Frame: " + (((mainStage.currentFrame-1) % 120)+1));
			}
			if(keyDownStatus[keyPressed] == undefined || keyDownStatus[keyPressed] == false || (keyPressed == 48 || keyPressed == 96))
			{
				if((keyPressed == 48 || keyPressed == 96))
				{
					var randomAnimIndex:int = Math.floor(Math.random() * animationNameIndexes.length);
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
				
				//Debugger
				if (keyPressed == Keyboard.S)
				{
					mainStage.stop();
					masterTemplate.StopAnimation();
				}
				else if (keyPressed == Keyboard.R)
				{
					masterTemplate.ResumePlayingAnimation();
				}
				
			}
			keyDownStatus[keyEvent.keyCode] = true;
		}
		
		//Switches to a templated animation of a specified name
		private function SwitchTemplateAnimation(animationName:String):void
		{
			//var animationDictKey:Object;
			//var animationDictionary:Dictionary = timelinesDict["Default"][animationName];
			//var t
			var defaultLayerInfo:Object = layerInfoDict["Default"][animationName];
			var templateChildrenCount:uint = masterTemplate.numChildren;
			var templateElements:Vector.<DisplayObject> = new Vector.<DisplayObject>(templateChildrenCount);
			var ShaftMask:DisplayObject = null, Shaft:DisplayObject = null, HeadMask:DisplayObject = null, Head:DisplayObject = null;
			for (var i:uint = 0; i < templateChildrenCount; ++i)
			{
				templateElements[i] = masterTemplate.getChildAt(i);
			}
			var depthCount:int = 0;
			//Counts how many objects in the layer information
			/*for (var elementObj in defaultLayerInfo.F0)
			{
				++depthCount;
			}
			var sortedDepthElements:Array = new Array(depthCount);*/
			var sortedDepthElements:Array = new Array();
			for (var childIndex:uint = 0; childIndex < templateChildrenCount; ++childIndex)
			{
				var element:DisplayObject = templateElements[childIndex];
				element.visible = false;
				var elementName:String = element.name;

				if (elementName in defaultLayerInfo.F0)
				{	
					sortedDepthElements[defaultLayerInfo.F0[elementName]] = element;
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
			}
			var topDepth:int = templateChildrenCount - 1;
			for (var arrayPosition:int = sortedDepthElements.length -1; arrayPosition >= 0; --arrayPosition )
			{
				masterTemplate.setChildIndex(sortedDepthElements[arrayPosition], topDepth - arrayPosition);
			}
			//If a mask-masked pair exists, set the mask. Otherwise, nullify the mask.
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
			
			for (var index:uint = 0, length:uint = animationNameIndexes.length; index < length; ++index)
			{
				if (animationName == animationNameIndexes[index])
				{
					masterTemplate.ChangeDefaultTimelinesUsed(index);
				}
			}
			//Sync the animation to the main stage's timeline (main stage's current frame - animation start frame % 120 + 1 to avoid setting it to frame 0)
			masterTemplate.PlayAnimation((mainStage.currentFrame -2) % 120 + 1);
		}
		
		//Attempts to create animation timelines of a template for the specified character
		private function CreateAnimationTimelinesForCharacter(characterName:String):void
		{
			//Reference to the class that has the embed motion xmls
			var animationMotion:Class;
			//Have to specify the full package path to the animation motion class
			var packagePath:String = "MotionXML." + characterName + ".";
			var fullClassPath:String;
			var animationName:String;
			//Iterate through all known animations and try to find their animationmotion class.
			for (var i:uint = 0, l:uint = animationNameIndexes.length; i < l; ++i)
			{
				animationName = animationNameIndexes[i];
				fullClassPath = packagePath + characterName + animationName + "Motions";
				//
				try
				{
					animationMotion = getDefinitionByName(fullClassPath) as Class;
				}
				catch (e:ReferenceError) //animation motion wasn't found
				{
					animationMotion = null;
					trace("Character " + characterName + " has no animation motion definition for animation: " + animationName);
				}
				//animation motion was found, now to process it
				if (animationMotion != null)
				{
					//Checks if the character name is Default. If so, also set these timelines to be the default timelines for the template
					if (characterName == "Default")
					{
						masterTemplate.SetDefaultTimelines(ProcessMotionStaticClass(animationMotion, masterTemplate), i);
					}
					else //Otherwise just add the timelines to the timelines dictionary, where they'll wait to be swapped in at a later time.
					{
						ProcessMotionStaticClass(animationMotion, masterTemplate);
					}
				}
			}
		}
		
		/*function printObject(obj:Object, numTabs:int=0): void
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
		}*/
	}

}