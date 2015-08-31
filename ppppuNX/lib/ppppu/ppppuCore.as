package ppppu 
{
	import avmplus.DescribeTypeJSON;
	import CharacterHair.*;
	import com.greensock.easing.Linear;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import ppppu.TweenDataParser;
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
		private var animationNameIndexes:Vector.<String> = new <String>["Cowgirl", "LeanBack", "LeanForward", "Grind", "ReverseCowgirl", "Paizuri", "Blowjob", "SideRide", "Swivel", "Anal"];
		private var characterNameList:Vector.<String> = new <String>["Peach"/*, "Rosalina"*/];
		private const defaultCharacter:String = characterNameList[0];
		private var currentCharacter:String = defaultCharacter;
		private var currentAnimationIndex:uint = 0;
		private var embedTweenDataConverter:TweenDataParser = new TweenDataParser();
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
			/*var test:CustomElementContainer = new CustomElementContainer();
			test.AddSprites(null, new DaisyHairBack(), null, new RosalinaHairBack());
			test.x = test.y = 200; 
			addChild(test);*/
			masterTemplate.visible = false;
		}
		
		//Sets up the various aspects of the flash to get it ready for performing.
		public function Initialize():void
		{
			//Add the key listeners
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleaseCheck);
			//Initializing plugins for the GSAP library
			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, TransformMatrixPlugin, VisiblePlugin]);
			//Set the default Ease for the tweens
			TweenLite.defaultEase = Linear.ease;
			TweenLite.defaultOverwrite = "none";
			//Disable mouse interaction for various objects
			mainStage.mouseEnabled = false;
			//Master template mouse event disabling
			masterTemplate.mouseChildren = false;
			masterTemplate.mouseEnabled = false;
			for (var childIndex:uint = 0, templateChildrenCount:uint = masterTemplate.numChildren; childIndex < templateChildrenCount; ++childIndex)
			{
				masterTemplate.getChildAt(childIndex).visible = false;
			}
			mainStage.addChild(masterTemplate);
			
			//Switch the first animation.
			SwitchTemplateAnimation(0);
			//SwitchTemplateAnimation(8);
			//Testing new way of handling hair
			var hairFront:AnchoredElementBase = new AnchoredElementBase("HairFront", AnchoredElementBase.HAIRELEMENT);
			hairFront.AddNewDefinition(new PeachHairFrontDef());
			hairFront.AddNewDefinition(new RosalinaHairFrontDef());
			//hairFront.ChangeDisplayedSprite(0);
			hairFront.SetAnchorObjectForAnimation(masterTemplate["Face"],"Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			
			var hairFrontAngled:AnchoredElementBase = new AnchoredElementBase("HairFrontAngled", AnchoredElementBase.HAIRELEMENT);
			hairFrontAngled.AddNewDefinition(new PeachHairFrontAngledDef);
			hairFrontAngled.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairFrontAngled.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			
			var hairFrontAngled2:AnchoredElementBase = new AnchoredElementBase("HairFrontAngled2", AnchoredElementBase.HAIRELEMENT);
			hairFrontAngled2.AddNewDefinition(new PeachHairFrontAngled2Def);
			hairFrontAngled2.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			
			var hairSideL:AnchoredElementBase = new AnchoredElementBase("HairSideL", AnchoredElementBase.HAIRELEMENT);
			hairSideL.AddNewDefinition(new PeachHairSideLDef);
			hairSideL.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSideL.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSideL.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSideL.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairSideR:AnchoredElementBase = new AnchoredElementBase("HairSideR", AnchoredElementBase.HAIRELEMENT);
			hairSideR.AddNewDefinition(new PeachHairSideRDef);
			hairSideR.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSideR.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSideR.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSideR.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairSide2L:AnchoredElementBase = new AnchoredElementBase("HairSide2L", AnchoredElementBase.HAIRELEMENT);
			hairSide2L.AddNewDefinition(new PeachHairSide2LDef);
			hairSide2L.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSide2L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSide2L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSide2L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairSide2R:AnchoredElementBase = new AnchoredElementBase("HairSide2R", AnchoredElementBase.HAIRELEMENT);
			hairSide2R.AddNewDefinition(new PeachHairSide2RDef);
			hairSide2R.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSide2R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSide2R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSide2R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairSide3L:AnchoredElementBase = new AnchoredElementBase("HairSide3L", AnchoredElementBase.HAIRELEMENT);
			hairSide3L.AddNewDefinition(new PeachHairSide3LDef);
			hairSide3L.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSide3L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSide3L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSide3L.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairSide3R:AnchoredElementBase = new AnchoredElementBase("HairSide3R", AnchoredElementBase.HAIRELEMENT);
			hairSide3R.AddNewDefinition(new PeachHairSide3RDef);
			hairSide3R.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairSide3R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairSide3R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairSide3R.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			var hairBack:AnchoredElementBase = new AnchoredElementBase("HairBack", AnchoredElementBase.HAIRELEMENT);
			hairBack.AddNewDefinition(new PeachHairBackDef);
			hairBack.SetAnchorObjectForAnimation(masterTemplate["Face"], "Cowgirl", "LeanBack", "LeanForward", "Paizuri", "Swivel");
			hairBack.SetAnchorObjectForAnimation(masterTemplate["TurnedFace2"], "Grind", "SideRide");
			hairBack.SetAnchorObjectForAnimation(masterTemplate["TurnedFace3"], "Blowjob");
			hairBack.SetAnchorObjectForAnimation(masterTemplate["TurnedFace"], "Anal", "ReverseCowgirl");
			
			masterTemplate.AddNewElementToTemplate(hairBack);
			masterTemplate.AddNewElementToTemplate(hairSideL);
			masterTemplate.AddNewElementToTemplate(hairSideR);
			masterTemplate.AddNewElementToTemplate(hairSide3L);
			masterTemplate.AddNewElementToTemplate(hairSide3R);
			masterTemplate.AddNewElementToTemplate(hairSide2L);
			masterTemplate.AddNewElementToTemplate(hairSide2R);
			masterTemplate.AddNewElementToTemplate(hairFront);
			
			
			
			
			masterTemplate.AddNewElementToTemplate(hairFrontAngled);
			masterTemplate.AddNewElementToTemplate(hairFrontAngled2);
			
			var menu:ppppuMenu = new ppppuMenu(masterTemplate);
			addChild(menu);
			
			mainStage.play();
		}
		
		//The "heart beat" of the flash. Ran every frame to monitor and react to certain, often frame sensitive, events
		private function RunLoop(e:Event):void
		{
			var mainStageMC:MovieClip = (e.target as MovieClip);
			masterTemplate.Update(((mainStageMC.currentFrame -2) % 120) + 1);
			masterTemplate.UpdateAnchoredElements();
			//2nd frame is the start point of the animations and playing of Beep block skyway.
			/*if (mainStageMC.currentFrame == 1)
			{
				
			}*/
			if (mainStageMC.currentFrame == 2)
			{
				masterTemplate.visible = true;
				//Go to the 
				SwitchTemplateAnimation(currentAnimationIndex);
				masterTemplate.PlayAnimation(mainStageMC.currentFrame);
			}
		}
		
		/*Responsible for processing all the motion xmls detailed in an animationMotions file, creating tweenLite tweens from them,
		 * and finally creating a timeline from those tweens and storing it in a dictionary*/
		private function ProcessMotionStaticClass(motionClass:Class, template:DisplayObject):Vector.<TimelineMax>
		{
			
			//Create an instance of the animation motion class
			var animationMotionInstance:Object = new motionClass();
			
			var timelineVector:Vector.<TimelineMax>;// = new Vector.<TimelineMax>();
			var templateAnimation:TemplateBase = template as TemplateBase;
			
			if (templateAnimation == null)
			{
				trace("Template animation is null for processing Motion Class: " + motionClass); 
				return null;
			}
			
			var charName:String = animationMotionInstance.CharacterName; //Character the animation motion is for
			var animName:String = animationMotionInstance.AnimationName; //The type of animation template that the animation motion is for
			var layerInfo:String = animationMotionInstance.LayerInfo; //Contains information that is used to rearrange the depth of elements displayed.
			
			//LayerInfo was found, so process it
			if (layerInfo != null && layerInfo.length > 0)
			{
				//LayerInfo strings are in JSON format, which is parsed as an Object
				var layerInfoObject:Object = JSON.parse(layerInfo);
				//If the layer info dictionary for the character doesn't exist, create it.
				if (layerInfoDict[charName] == null) { layerInfoDict[charName] = new Dictionary(); }
				//Set the layer info for an animation of the character
				layerInfoDict[charName][animName] = layerInfoObject;
			}
			
			//Get the description of the animation motion class
			var jsonClassDescriber:DescribeTypeJSON = new DescribeTypeJSON();
			var motionClassDescription:Object = jsonClassDescriber.describeType(motionClass, DescribeTypeJSON.INCLUDE_VARIABLES | DescribeTypeJSON.INCLUDE_TRAITS | DescribeTypeJSON.INCLUDE_ITRAITS);
			
			//Get an array of the animation motion class' variables
			var varsInMotionClass:Array = motionClassDescription.traits.variables as Array;
			var currentVarInfo:Object;
			var objectClassNames:Vector.<String> = new Vector.<String>();
			
			//Create the timeline vector
			timelineVector = new Vector.<TimelineMax>();
			
			//Run through the variables array 
			for (var index:int = 0, length:int = varsInMotionClass.length; index < length; ++index)
			{
				//Get the information of the variable at the index
				currentVarInfo = varsInMotionClass[index];
				var currentVarName:String = currentVarInfo.name as String;
				
				//Get the actual instance of the variable from the instance of the animation motion created at the beginning of this function.
				var currentVariable:Object = animationMotionInstance[currentVarName];
				//Only care about the variable if it's a byte array
				if (currentVariable is ByteArray)
				{
					//Add the name of the element into the objectClassNames vector
					objectClassNames[objectClassNames.length] = currentVarName;
					if (currentVariable.length != 0)
					{
						//Deserialize the byte array into a vector of tween data objects
						var vectorOfTweenData:Vector.<Object> = currentVariable.readObject() as Vector.<Object>;
						
						var templateElement:DisplayObject = templateAnimation[currentVarName];
						
						//Create the array of tweens, using the vector of tween data.
						var tweens:Array = embedTweenDataConverter.IntegrateTweenData(templateElement, vectorOfTweenData);
						//Declare the timeline for the tweens
						var timelineForMotion:TimelineMax = null; 
						
						//If the target element from the template exists
						if (templateElement != null)
						{
							//Create the timeline that will use the tweens
							timelineForMotion = new TimelineMax( { useFrames:true, repeat: -1, paused:true } );
							//Set the data of the timeline to have a property for the template's element 
							timelineForMotion.data = { targetElement: templateElement };
							//Add the tweens
							timelineForMotion.add(tweens,"+=0", "sequence");
						}
						else
						{
							//Without the template element, tweening isn't possible.
							trace("Critical Warning! Animation " + animName + " is unable to target Element \"" + currentVarName + "\"");
						}
						
						//Dictionary existance checking. Create a dictionary if the specified one doesn't exist.
						if (timelinesDict[charName] == null)
						{
							//Code in here is theoretically unreachable but keep it here until that is fully tested.
							CreateTimelineDictionaryForCharacter(charName);
							timelinesDict[charName] = new Dictionary();
						}
						if (timelinesDict[charName][animName] == null)
						{
							//Creates a dictionary in the charName dictionary that's contained in timelinesDict.
							timelinesDict[charName][animName] = new Dictionary();
						}
						
						if (timelineForMotion)
						{
							//Setting the timelines dictionary to contain the created time line.
							timelinesDict[charName][animName][currentVarName] = timelineForMotion;
							//Adding the created timeline to timelineVector
							timelineVector[timelineVector.length] = timelineForMotion;
							//Tell the timeline to start paused, to help save on processing a little.
							timelineForMotion.pause();
						}
					}
					else
					{
						trace("Warning! Tween data for element " + templateElement.name + " of animation " + animName + " was empty. Timeline was not constructed.");
					}
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

			if(keyDownStatus[keyPressed] == undefined || keyDownStatus[keyPressed] == false || (keyPressed == 48 || keyPressed == 96))
			{
				if((keyPressed == 48 || keyPressed == 96))
				{
					var randomAnimIndex:int = Math.floor(Math.random() * animationNameIndexes.length);
					SwitchTemplateAnimation(randomAnimIndex);
				}
				else if((!(49 > keyPressed) && !(keyPressed > 57)) ||  (!(97 > keyPressed) && !(keyPressed > 105)))
				{
					//keypress of 1 has a keycode of 49
					if(keyPressed > 96)
					{
						keyPressed = keyPressed - 48;
					}
					SwitchTemplateAnimation(keyPressed - 49);
				}
				
				if (keyPressed == Keyboard.Z)
				{
					/*currentCharacter = defaultCharacter;
					masterTemplate.ChangeHair(currentCharacter);
					masterTemplate.ChangeHeadwear(currentCharacter);
					masterTemplate.ChangeEarring(currentCharacter);
					
					//Lazy way of updating the timelines. In the future, create a method that will swap in the necessary timelines and use that
					SwitchTemplateAnimation(currentAnimationIndex);*/
				}
				if (keyPressed == Keyboard.Q)
				{
					masterTemplate.HairFront.ChangeDisplayedSprite(0);
				}
				else if (keyPressed == Keyboard.W)
				{
					masterTemplate["HairFront"].ChangeDisplayedSprite(1);
				}
				if (keyPressed == Keyboard.X)
				{
					masterTemplate.Face.Element.scaleX *= .75;
				}
				if (keyPressed == Keyboard.C)
				{
					masterTemplate.Face.Element.scaleX *= 1.25;
				}
				if (keyPressed == Keyboard.V)
				{
					masterTemplate.Face.Element.scaleY *= .75;
				}
				if (keyPressed == Keyboard.B)
				{
					masterTemplate.Face.Element.scaleY *= 1.25;
				}
				/*if (keyPressed == Keyboard.X)
				{
					currentCharacter = "Rosalina";
					masterTemplate.ChangeHair(currentCharacter);
					masterTemplate.ChangeHeadwear(currentCharacter);
					masterTemplate.ChangeEarring(currentCharacter);
					
					//Still using the lazy way of updating the timelines.
					SwitchTemplateAnimation(currentAnimationIndex);
				}*/
				//Debugger
				if (keyPressed == Keyboard.S)
				{
					mainStage.stop();
					masterTemplate.StopAnimation();
				}
				else if (keyPressed == Keyboard.R)
				{
					mainStage.play();
					masterTemplate.ResumePlayingAnimation();
				}
				
			}
			keyDownStatus[keyEvent.keyCode] = true;
		}
		
		//Switches to a templated animation of a specified name
		private function SwitchTemplateAnimation(animationIndex:uint):void
		{
			var animationName:String = animationNameIndexes[animationIndex];
			masterTemplate.currentAnimationName = animationName;
			if (!(defaultCharacter in timelinesDict))
			{
				CreateTimelineDictionaryForCharacter(defaultCharacter);
			}
			if (!(animationName in timelinesDict[defaultCharacter]))
			{
				CreateTimelinesForCharacterAnimation(defaultCharacter, animationIndex);
			}
			var defaultLayerInfo:Object = layerInfoDict[defaultCharacter][animationName];
			var currentCharLayerInfo:Object=null;
			if (defaultCharacter != currentCharacter)
			{
				currentCharLayerInfo = layerInfoDict[currentCharacter][animationName];
			}
			masterTemplate.SetElementDepthLayout(defaultLayerInfo);
			masterTemplate.ImmediantLayoutUpdate((mainStage.currentFrame -2) % 120 + 1);
			
			for (var index:uint = 0, length:uint = animationNameIndexes.length; index < length; ++index)
			{
				if (animationName == animationNameIndexes[index])
				{
					masterTemplate.ChangeDefaultTimelinesUsed(index);
				}
			}
			if (currentCharacter != defaultCharacter)
			{
				//Checks if the dictionary is null. If so, attempt to create it.
				if (!(currentCharacter in timelinesDict))
				{
					CreateTimelineDictionaryForCharacter(currentCharacter);
				}
				if (!(animationName in timelinesDict[currentCharacter]))
				{
					CreateTimelinesForCharacterAnimation(currentCharacter, animationIndex);
				}
				var timelinesForCharacter:Dictionary = timelinesDict[currentCharacter][animationName];
				var currCharTimeline:TimelineMax;
				for each(currCharTimeline in timelinesForCharacter)
				{
					masterTemplate.AddTimeline(currCharTimeline);
				}
			}
			//Sync the animation to the main stage's timeline (main stage's current frame - animation start frame % 120 + 1 to avoid setting it to frame 0)
			masterTemplate.PlayAnimation((mainStage.currentFrame -2) % 120 + 1);
			currentAnimationIndex = animationIndex;
			
		}
		
		/*Attempts to create timelines of a specified animation for the specified character.*/
		private function CreateTimelinesForCharacterAnimation(characterName:String, animationIndex:uint):void
		{
			//Reference to the class that has the embed motion xmls
			var animationMotion:Class = null;
			//Have to specify the full package path to the animation motion class
			var packagePath:String = "MotionXML." + characterName + ".";
			var fullClassPath:String;
			var animationName:String;
			
			//Iterate through all known animations and try to find their animationmotion class.
			if(animationIndex < animationNameIndexes.length)
			{
				animationName = animationNameIndexes[animationIndex];
				fullClassPath = packagePath + characterName + animationName + "Motions";
				//
				//try
				//{
					animationMotion = getDefinitionByName(fullClassPath) as Class;
				/*}
				catch (e:ReferenceError) //animation motion wasn't found
				{
					animationMotion = null;
					trace("Character " + characterName + " has no animation motion definition for animation: " + animationName);
				}*/
				//animation motion was found, now to process it
				if (animationMotion != null)
				{
					//Checks if the character name is Default. If so, also set these timelines to be the default timelines for the template
					if (characterName == defaultCharacter)
					{
						masterTemplate.SetDefaultTimelines(ProcessMotionStaticClass(animationMotion, masterTemplate), animationIndex);
					}
					else //Otherwise just add the timelines to the timelines dictionary, where they'll wait to be swapped in at a later time.
					{
						ProcessMotionStaticClass(animationMotion, masterTemplate);
					}
				}
			}
		}
		private function CreateTimelineDictionaryForCharacter(characterName:String):void
		{
			if (timelinesDict[characterName] === undefined)
			{
				timelinesDict[characterName] = new Dictionary();
			}
		}
	}

}