package ppppu 
{
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
		//Keeps track of which template is currently being displayed.
		private var templateInUse:TemplateBase;
		//Responsible for holding the various timelines that will be added to a template. This dictionary is 3 levels deep, which is expressed by: timelineDict[Character][Animation][Part]
		private var timelinesDict:Dictionary = new Dictionary();
		private var templateDict:Dictionary = new Dictionary();
		public var mainStage:MainStage;
		//Keeps track of what keys were pressed and/or held down
		var keyDownStatus:Array = [];
		var animationNameIndexes:Array = ["Cowgirl", "LeanBack", "LeanForward", "Grind", "ReverseCowgirl", "Paizuri", "Blowjob", "SideRide", "Swivel", "Anal"];
		//Constructor
		public function ppppuCore() 
		{
			
			//Create the "main stage" that holds the character template and various other movieclips such as the transition and backlight 
			mainStage = new MainStage();
			mainStage.stop();
			addChild(mainStage);
			//Add an event listener that'll allow for frame checking.
			mainStage.addEventListener(Event.ENTER_FRAME, RunLoop);
			this.cacheAsBitmap = true;
			this.scrollRect = new Rectangle(0, 0, 480, 720);
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
			SetupTemplates();
			//Initializing the various default motion xmls for the animation templates.
			CreateAnimationTimelinesForCharacter("Default");
			CreateAnimationTimelinesForCharacter("Rosalina");
			
			mainStage.play();
		}
		
		private function RunLoop(e:Event):void
		{
			var mainStageMC:MovieClip = (e.target as MovieClip);
			if (mainStageMC.currentFrame == 2)
			{
				SwitchTemplateAnimation("Cowgirl");
				//templateInUse.PlayAnimation(mainStageMC.currentFrame-1);
			}
			//templateInUse.UpdateTimelines();
		}
		
		/*Responsible for processing all the motion xmls detailed in an animationMotions file, creating tweenLite tweens from them,
		 * and finally creating a timeline from those tweens and storing it in a dictionary*/
		private function ProcessMotionStaticClass(motionClass:Class, template:DisplayObject):Array
		{
			var timelineArray:Array = new Array();
			var templateAnimation:TemplateBase = template as TemplateBase;
			if (templateAnimation == null)
			{
				trace("Template animation is null for processing Motion Class: " + motionClass); 
				return null;
			}
			
			var charName:String = motionClass.CharacterName;
			var animName:String = motionClass.AnimationName;
			var xmlData:XMLList = describeType(motionClass).constant;
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
					timelineForMotion.data = xmlClassName;
					var tween:TweenOrder;
					for (var ti:int = 0, tl:int = tweens.length; ti < tl; ++ti)
					{
						tween = tweens[ti];
						if (tween.TargetObject != null)
						{
							timelineForMotion.to(tween.TargetObject, tween.DurationFrames, tween.TweenVars, tween.StartFrame);
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
					timelineArray[timelineArray.length] = timelineForMotion;
					timelineForMotion.pause();
				}
			}
			return timelineArray;
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
		
		private function SwitchTemplateAnimation(animationName:String):void
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
		}
		
		
		
		//Attempts to create animation timelines of a template for the specified character.
		private function CreateAnimationTimelinesForCharacter(characterName:String):void
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
		}
		
		private function SetupTemplates()
		{
			templateDict["Anal"] = new AnalTemplate();
			templateDict["Blowjob"] = new BlowjobTemplate();
			templateDict["Cowgirl"] = new CowgirlTemplate();
			templateDict["Grind"] = new GrindTemplate();
			templateDict["LeanBack"] = new LeanBackTemplate();
			templateDict["LeanForward"] = new LeanForwardTemplate();
			templateDict["Paizuri"] = new PaizuriTemplate();
			templateDict["ReverseCowgirl"] = new ReverseCowgirlTemplate();
			templateDict["SideRide"] = new SideRideTemplate();
			templateDict["Swivel"] = new SwivelTemplate();
		}
	}

}