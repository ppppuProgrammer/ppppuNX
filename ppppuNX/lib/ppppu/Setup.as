package ppppu 
{
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import ppppu.ppppuCharacterManager;
	import ppppu.ppppuMenuButton;
	//import flash.media.Sound;
	/**
	 * Placeholder class for code that was contained in the actual movie clips in older ppppu interactive versions. This class SHOULD NOT
	 * be used and code from it should be reviewed for efficiency/possible clean up, then moved into ppppuCore.
	 * @author ...
	 */
	public class Setup 
	{
		
		public function MusicSwfLoadSetup()
		{
			const highQualityMusicFile:String = "ppppSuperWiiUv4_interactive-HQMusic.swf";

			var loader:Loader = new Loader();
			var highQualityMusicDomain:ApplicationDomain = new ApplicationDomain();
			var loadHighQualityMusicSuccessful:Boolean;
			var context:LoaderContext = new LoaderContext(false,highQualityMusicDomain);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler); 
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, failureHandler);
			loader.load(new URLRequest(highQualityMusicFile), context);
			stop(); //stop the movie clip from playing

			function completeHandler(event:Event):void 
			{ 
				loadHighQualityMusicSuccessful = true;
				play(); //resume playing movie clip
				trace("Loaded swf"); 
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, failureHandler);
			} 

			function failureHandler(event:Event):void 
			{ 
				loadHighQualityMusicSuccessful = false;
				play(); //resume playing movie clip
				trace("Failed to load swf");
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, failureHandler);
			} 
		}
		
		public function Setup() 
		{
			const flashStartFrame:int = 7;

			//Movie clip initialization.
			var helpScreenMC:HelpScreen = new HelpScreen();
			var peachMC:PeachMovieClip = new PeachMovieClip();
			var rosalinaMC:RosalinaMovieClip = new RosalinaMovieClip();
			var daisyMC:DaisyMovieClip = new DaisyMovieClip();
			var samusMC:SamusMovieClip = new SamusMovieClip();
			var shantaeMC:ShantaeMovieClip = new ShantaeMovieClip();
			var midnaMC:MidnaMovieClip = new MidnaMovieClip();
			var zeldaMC:ZeldaMovieClip = new ZeldaMovieClip();
			var isabelleMC:IsabelleMovieClip = new IsabelleMovieClip();

			var lightMC:LightMC = new LightMC();
			var outerDiamondMC:OuterDiamondMC = new OuterDiamondMC();

			var innerDiamondMC:PeachRosaInnerDiamondMC = new PeachRosaInnerDiamondMC();
			var samusInnerDiamondMC:SamusInnerDiamondMC = new SamusInnerDiamondMC();
			var daisyInnerDiamondMC:DaisyInnerDiamondMC = new DaisyInnerDiamondMC();
			var shaeInnerDiamondMC:ShantaeInnerDiamondMC = new ShantaeInnerDiamondMC();
			var midnaInnerDiamondMC:MidnaInnerDiamondMC = new MidnaInnerDiamondMC();
			var zeldaInnerDiamondMC:ZeldaInnerDiamondMC = new ZeldaInnerDiamondMC();
			var isabelleInnerDiamondMC:IsabelleInnerDiamondMC = new IsabelleInnerDiamondMC();

			var transitionMC:PeachRosaTransitionMC = new PeachRosaTransitionMC();
			var samusTransitionMC:SamusTransitionMC = new SamusTransitionMC();
			var daisyTransitionMC:DaisyTransitionMC = new DaisyTransitionMC();
			var shaeTransitionMC:ShantaeTransitionMC = new ShantaeTransitionMC();
			var midnaTransitionMC:MidnaTransitionMC = new MidnaTransitionMC();
			var zeldaTransitionMC:ZeldaTransitionMC = new ZeldaTransitionMC();
			var isabelleTransitionMC:IsabelleTransitionMC = new IsabelleTransitionMC();

			var midnaLightColor:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0, -26, 19, 122);
			var isabelleLightColor:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0, 156, -22, -103);
			//var characterManager = new ppppuCharacterManager(null, null, null, null);
			var characterManager = new ppppuCharacterManager(this, outerDiamondMC, innerDiamondMC, transitionMC, lightMC);

			//points to attach certain movie clips at.
			var lightPoint:Point = new Point(241.95, 327);
			var diamondPoint:Point = new Point(240, 370);
			//var iDiamondPoint:Point = new Point(240, 370);

			//var lightTargetPoint:Point = new Point(0,0);// = this.globalToLocal(lightPoint); 
			//var oDiamondTargetPoint:Point = new Point(0,0);// = this.globalToLocal(oDiamondPoint); 
			//var iDiamondTargetPoint:Point = new Point(0,0);// = this.globalToLocal(iDiamondPoint);

			//Peach's color is the default, so the default constructor for the color transform is fine
			var peachColor:ColorTransform = new ColorTransform();
			var rosalinaColor:ColorTransform = new ColorTransform(0.62, 1.0, 1.0, 1.0, -59, 22, 102, 0);
			var daisyColor:ColorTransform = new ColorTransform(1.0, 1.0, 0.0, 1.0, 3, 84, 51, 0);
			var samusColor:ColorTransform = new ColorTransform(1.0, 0.0, 0.0, 1.0, 3, 44, 46, 0);
			var shantaeColor:ColorTransform = new ColorTransform(1.0,1.0,1.0,1.0,-9, 64,-120);
			var midnaColor:ColorTransform = new ColorTransform(1.0,1.0,1.0,1.0, -48, 84,73,0);
			var zeldaColor:ColorTransform = new ColorTransform(1.0,1.0,1.0,1.0, 3, 135,39,0);
			var isabelleColor:ColorTransform = new ColorTransform(/*1.0,1.0,1.0,1.0, -103,21,90,0*/);
			isabelleColor.color = 0x956329;

			//mouse isn't used for this, so disable mouse interactivity with objects;
			//mouseEnabled = false;
			//mouseChildren = false;

			this.stop();
			//setup movie clips before we start using them.
			SetupMovieClips();
			//Initializes characters. Adds characters in this function
			InitializeCharacters();
			//Creates the menus for the flash. This will also not allow any more characters to be added
			characterManager.CreateMenus(this);
			characterManager.InitializeMusicManager(this, stage.frameRate);
			SetupCharacterMusic();
			this.addEventListener(Event.ENTER_FRAME, this.CheckFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyReleaseCheck);
			var keyDownStatus:Array = [];
			this.play();

			//this.stage
			//var bbbMusic:Sound = new bbbSound();
			//var bbbMusic2:Sound = new bbb2Sound();
			function SetupMovieClips()
			{
				
				TempAddMovieClipForPlacement(lightMC, this, lightPoint);
				TempAddMovieClipForPlacement(outerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(innerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(transitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(samusInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(samusTransitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(daisyInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(daisyTransitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(shaeInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(shaeTransitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(midnaInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(midnaTransitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(zeldaInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(zeldaTransitionMC, this, diamondPoint);
				TempAddMovieClipForPlacement(isabelleInnerDiamondMC, this, diamondPoint);
				TempAddMovieClipForPlacement(isabelleTransitionMC, this, diamondPoint);

				//Set the position of the character movie clips 
				var defX:Number = -54.75, defY = 92.00;
				SetDisplayObjPosition(peachMC, defX, defY);
				SetDisplayObjPosition(rosalinaMC, defX, defY);
				SetDisplayObjPosition(daisyMC, defX, defY);
				SetDisplayObjPosition(samusMC, defX, defY);
				SetDisplayObjPosition(shantaeMC, defX, defY);
				SetDisplayObjPosition(midnaMC, defX, defY);
				SetDisplayObjPosition(zeldaMC, defX, defY);
				SetDisplayObjPosition(isabelleMC, defX, defY);
				
				//Set the position of the help screen
				//SetDisplayObjPosition(helpScreenMC, ((stage.stageWidth - helpScreenMC.width)/2), 0);
				helpScreenMC.visible = false;
				this.addChild(helpScreenMC);
				helpScreenMC.x = (this.getRect(this).right - helpScreenMC.width) / 2;
				helpScreenMC.y = 0;
			}

			function SetupCharacterMusic()
			{
				var daisyBGM:Sound;
				var shantaeBGM:Sound;
				var zeldaBGM:Sound;
				var isabelleBGM:Sound;
				var samusBGM:Sound;
				
				if(loadHighQualityMusicSuccessful == true)
				{
					var DaisyMusicClass:Class = highQualityMusicDomain.getDefinition("DaisyTheme_High") as Class;
					var ShantaeMusicClass:Class = highQualityMusicDomain.getDefinition("BurningTown_High") as Class;
					var ZeldaMusicClass:Class = highQualityMusicDomain.getDefinition("GerudoValley_High") as Class;
					var IsabelleMusicClass:Class = highQualityMusicDomain.getDefinition("IsabelleTheme_High") as Class;
					var SamusMusicClass:Class = highQualityMusicDomain.getDefinition("SamusTheme_High") as Class;
					if(DaisyMusicClass != null)
					{
						daisyBGM = new DaisyMusicClass();
					}
					if(SamusMusicClass != null)
					{
						samusBGM = new SamusMusicClass();
					}
					if(ShantaeMusicClass != null)
					{
						shantaeBGM = new ShantaeMusicClass();
					}
					if(ZeldaMusicClass != null)
					{
						zeldaBGM = new ZeldaMusicClass();
					}
					if(IsabelleMusicClass != null)
					{
						isabelleBGM = new IsabelleMusicClass();
					}
				}
				//fallback in case high quality music could not be found
				if(loadHighQualityMusicSuccessful == false || daisyBGM == null)
				{
					daisyBGM = new DaisyTheme();
				}
				if(loadHighQualityMusicSuccessful == false || samusBGM == null)
				{
					samusBGM = new SamusTheme();
				}
				if(loadHighQualityMusicSuccessful == false || shantaeBGM == null)
				{
					shantaeBGM = new BurningTownBGM();
				}
				if(loadHighQualityMusicSuccessful == false || zeldaBGM == null)
				{
					zeldaBGM = new GerudoValleyBGM();
				}
				if(loadHighQualityMusicSuccessful == false || isabelleBGM == null)
				{
					isabelleBGM = new IsabelleTheme();
				}
				
				//add music function:
				/*	To facilate accurate playback timing & looping, there are a few mp3 quirks that need to be dealt with.
				Also do note that all of this is when dealing with mp3s that have 44100hz playback, primarily due to the fact
				that the ppppuMusic class has trouble playing sounds that don't have a sample rate of 44100hz.
					The first is the extra padding the encoders add at the beginning of an mp3.
				Encoder delay is at the beginning of the file and is consistant among songs that use the same encoder.
				This is the reason why startTime is always the length of 576 samples or ((576/44100)/1000) milliseconds.
					The seconds quirk is the added padding at the end of an mp3. Using the LAME codec will allow padding information to be
				available using a LAME tag reader. The padding is how many samples of silence there are at the end of a song.
				So the (character)_endLoopTime variable is used to essentially cut away the padding from being played.*/
				
				//AddMusicForCharacter(characterName:String, characterBGM:Sound = null, loopStartTimeMs:Number=0, loopEndTimeMs:Number=-1, musicStartTimeMs:Number=0)
				var startTime:Number = ConvertSamplesToMilliseconds(576);
				//End loop times are typically the length of the song with mp3 encoding padding (encoder delay + end padding) subtracted from the length.
				//If an end loop time isn't reliant on the end of the file as a reference point, the end extra padding can be ignored.
				var daisy_endLoopTime:Number = daisyBGM.length - (ConvertSamplesToMilliseconds(1394) + startTime);
				var samus_endLoopTime:Number = samusBGM.length - (ConvertSamplesToMilliseconds(1547) + startTime);
				var shantae_endLoopTime:Number = shantaeBGM.length - (ConvertSamplesToMilliseconds(1080) + startTime);
				var zelda_endLoopTime:Number = zeldaBGM.length - (ConvertSamplesToMilliseconds(647) + startTime);
				var isabelle_endLoopTime:Number = isabelleBGM.length - (ConvertSamplesToMilliseconds(618) + startTime);
				characterManager.AddMusicForCharacter("Daisy", daisyBGM, "mario adventures i", ConvertSamplesToMilliseconds(792431+576)/*17968.956916099774389*/, daisy_endLoopTime, startTime);
				characterManager.AddMusicForCharacter("Samus", samusBGM, "record of samus", ConvertSamplesToMilliseconds(101410+576)/*2299.5464852607710782*/, samus_endLoopTime, startTime);
				characterManager.AddMusicForCharacter("Shantae", shantaeBGM, "we love burning town", ConvertSamplesToMilliseconds(347142+576)/*7871.7006802721080021*/, shantae_endLoopTime, startTime);
				characterManager.AddMusicForCharacter("Midna", zeldaBGM, "gerudo valley", ConvertSamplesToMilliseconds(723190+576)/*16398.866213151926786*/, zelda_endLoopTime, startTime);
				characterManager.AddMusicForCharacter("Zelda", zeldaBGM, "gerudo valley", ConvertSamplesToMilliseconds(723190+576)/*16398.866213151926786*/, zelda_endLoopTime, startTime);
				characterManager.AddMusicForCharacter("Isabelle", isabelleBGM, "2:00 a.m.", ConvertSamplesToMilliseconds(190538+576)/*4320.5895691609975984*/, isabelle_endLoopTime, startTime);
			}

			/*function prototype for adding character: 
			AddCharacter(name:String, characterMovieClip:MovieClip, 
				charColorTransform:ColorTransform, innerDiamondMovieClip:MovieClip, 
				transitionDiamondMovieClip:MovieClip, outerDiamondMovieClip:MovieClip,
				usesLight:Boolean, backlightcolor:ColorTransform)

			The diamond movie clips are optional parameters as exhibited by Peach and Rosalina*/
			function InitializeCharacters()
			{
				//hit area sprite declaration for character buttons
				var zeldaHitArea:TriangleBtnHitArea = new TriangleBtnHitArea();
				var isabelleHitArea:SquareBtnHitArea = new SquareBtnHitArea(79, 75);
				//var standardCircleHitArea:CircleBtnHitArea = new CircleBtnHitArea();
				var shantaeHitArea:SquareBtnHitArea = new SquareBtnHitArea(132,65);
				var peachButton:PeachButton = new PeachButton();
				var rosalinaButton:RosalinaButton = new RosalinaButton();
				var daisyButton:DaisyButton = new DaisyButton();
				var samusButton:SamusButton = new SamusButton();
				var shantaeButton:ShantaeButton = new ShantaeButton();
				var midnaButton:MidnaButton = new MidnaButton();
				var zeldaButton:ZeldaButton = new ZeldaButton();
				var isabelleButton:IsabelleButton = new IsabelleButton();
				
				peachButton.SetHitArea(new CircleBtnHitArea());
				rosalinaButton.SetHitArea(new CircleBtnHitArea());
				daisyButton.SetHitArea(new CircleBtnHitArea());
				samusButton.SetHitArea(new CircleBtnHitArea());
				shantaeButton.SetHitArea(shantaeHitArea);
				midnaButton.SetHitArea(new CircleBtnHitArea());
				zeldaButton.SetHitArea(zeldaHitArea);
				isabelleButton.SetHitArea(isabelleHitArea);
				characterManager.AddCharacter("Peach", peachMC, peachColor, peachButton);
				characterManager.AddCharacter("Rosalina", rosalinaMC, rosalinaColor, rosalinaButton);
				characterManager.AddCharacter("Daisy", daisyMC, daisyColor, daisyButton, daisyInnerDiamondMC, daisyTransitionMC);
				characterManager.AddCharacter("Samus", samusMC, samusColor, samusButton, samusInnerDiamondMC, samusTransitionMC);
				characterManager.AddCharacter("Shantae", shantaeMC, shantaeColor, shantaeButton, shaeInnerDiamondMC, shaeTransitionMC);
				characterManager.AddCharacter("Zelda", zeldaMC, zeldaColor, zeldaButton, zeldaInnerDiamondMC, zeldaTransitionMC, null, null, false);
				characterManager.AddCharacter("Midna", midnaMC, midnaColor, midnaButton, midnaInnerDiamondMC, midnaTransitionMC, null, midnaLightColor);
				characterManager.AddCharacter("Isabelle", isabelleMC, isabelleColor, isabelleButton, isabelleInnerDiamondMC, isabelleTransitionMC, null, isabelleLightColor);
			}
			function CheckFrame(e:Event)
			{
				var frameNum:int = this.currentFrame;
				//if(frameNum == 6)
				//{
					//bbbMusic.play();
				//}
				/*starts on frame 7 and each cycle lasts 120 frames. 
				That's 7-126, 127-246,...*/
				if(frameNum == flashStartFrame)
				{
					characterManager.ToggleMenu();
				}
				if(frameNum % 120 == flashStartFrame) //Add character clip
				{
				//frameNum != 7 is so Peach is the first character displayed on start
					RemoveCurrentCharacterClips();
					if(characterManager.GetCharSwitchStatus() && frameNum != flashStartFrame)
					{
						//if selectRandomChar is false then increment currentChar
						characterManager.CharacterSwitchLogic();
					}
					characterManager.AddCurrentCharacter(this);
				}
				EnsureHelpScreenOnTop();
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
						characterManager.RandomizeCurrentCharacterAnim();
					}
					else if((!(49 > keyPressed) && !(keyPressed > 57)) ||  (!(97 > keyPressed) && !(keyPressed > 105)))
					{
						//keypress of 1 has a keycode of 49
						if(keyPressed > 96)
						{
							keyPressed = keyPressed - 48;
						}
						//AnimationFrame has to be a value greater than 0
						var animationFrame = keyPressed - 49 + 1; 
						characterManager.HandleAnimActionForCurrentCharacter(animationFrame);
					}
					else if(keyPressed == Keyboard.SPACE)
					{
						characterManager.SetCharSwitchStatus(!characterManager.GetCharSwitchStatus());
						//if(characterManager.GetRandomSelectStatus() && !characterManager.GetCharSwitchStatus())
						//{
							//characterManager.SetRandomSelectStatus(false);
						//}
					}
					else if(keyPressed == Keyboard.MINUS || keyPressed == Keyboard.NUMPAD_SUBTRACT)
					{
						//Try to go to the previous page of animations
						characterManager.GotoPrevAnimationPage();
					}
					else if(keyPressed == Keyboard.EQUAL || keyPressed == Keyboard.NUMPAD_ADD)
					{
						//Try to go to the next page of animations
						characterManager.GotoNextAnimationPage();
					}
					else if(keyPressed == Keyboard.S)
					{
						//toggle animation lock/goto mode
						characterManager.ToggleAnimationLockMode();
					}
					else if(keyPressed == Keyboard.LEFT)
					{
						//(Un)lock the character who the menu cursor is on
						characterManager.ToggleSelectedMenuCharacterLock();
					}
					else if(keyPressed == Keyboard.RIGHT)
					{
						//Go to the character who the menu cursor is on
						characterManager.GotoSelectedMenuCharacter();
					}
					else if(keyPressed == Keyboard.UP)
					{
						//Move menu cursor to the character above
						characterManager.MoveMenuCursorToPrevPos();
					}
					else if(keyPressed == Keyboard.DOWN)
					{
						//Move menu cursor to the character below
						characterManager.MoveMenuCursorToNextPos();
					}
					else if(keyPressed == Keyboard.SHIFT)
					{
						//Toggles random character switching
						characterManager.SetRandomSelectStatus(!characterManager.GetRandomSelectStatus());
					}
					else if(keyPressed == Keyboard.CONTROL)
					{
						characterManager.ToggleMenu();
					}
					else if(keyPressed == Keyboard.H)
					{	
						helpScreenMC.gotoAndStop(1);
						helpScreenMC.visible = !helpScreenMC.visible;
					}
					else if(keyPressed == Keyboard.L)
					{
						characterManager.ToggleBackLight(((this.currentFrame - 7)% 120) + 1);
					}
					else if(keyPressed == Keyboard.B)
					{
						characterManager.ToggleBackground(((this.currentFrame - 7)% 120) + 1);
					}
					else if(keyPressed == Keyboard.M)
					{
						characterManager.ToggleMusicPlay();
					}
					else if(keyPressed == Keyboard.N)
					{
						characterManager.SwitchMusicForCurrentCharacter();
					}
					else if(keyPressed == Keyboard.Z)
					{
						if(helpScreenMC.currentFrame == helpScreenMC.totalFrames)
						{
							helpScreenMC.gotoAndStop(1);
						}
						else
						{
							helpScreenMC.nextFrame();
						}
					}
					else if(keyPressed == Keyboard.X)
					{
						characterManager.ChangeMusicForCurrentCharacter(false);
					}
					else if(keyPressed == Keyboard.C)
					{
						characterManager.ChangeMusicForCurrentCharacter(true);
					}
					else if(keyPressed == Keyboard.G)
					{
						characterManager.SetCurrentMusicForAllCharacters();
					}
					/*else if(keyPressed == Keyboard.E)
					{
						characterManager.musicManager.DEBUG_GoToMusicLastSection();
					}
					keyDownStatus[keyPressed] = true;*/
				}
				keyDownStatus[keyEvent.keyCode] = true;
				EnsureHelpScreenOnTop();
			}

			function RemoveCurrentCharacterClips()
			{
				characterManager.RemoveCurrentCharacter();
			}

			//Sets a movie clip in relation to it's parent clip when using global coordinates 
			function AdjustMovieClipPlacement(clipMC:MovieClip, globalAttachPoint:Point)
			{
				if(clipMC.parent == null)
					return;
				var clipTargetPoint:Point = clipMC.parent.globalToLocal(globalAttachPoint);
				SetDisplayObjPosition(clipMC, clipTargetPoint.x, clipTargetPoint.y)
			}

			//Use this if setting the position for movie clips for the first time when using a global point
			function TempAddMovieClipForPlacement(clipMC:MovieClip, parentClip:MovieClip, globalAttachPoint:Point)
			{
				parentClip.addChild(clipMC);
				AdjustMovieClipPlacement(clipMC, globalAttachPoint);
				parentClip.removeChild(clipMC);
			}

			function EnsureHelpScreenOnTop()
			{
				if(helpScreenMC.visible)
				{
					this.setChildIndex(helpScreenMC, this.numChildren -1);
				}
			}



			//Helper func so code can look cleaner in the body of other functions
			function SetDisplayObjPosition(disObj:DisplayObject, x:Number, y:Number)
			{
				disObj.x = x;
				disObj.y = y;
			}

			function ConvertSamplesToMilliseconds(sampleNum:Number):Number
			{
				return (sampleNum/44100.0)*1000.0
			}
		}
		
	}

}