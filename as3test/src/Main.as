package
{
	import As3Test_fla.Symbol316_1;
	import com.greensock.data.TweenLiteVars;
	import fl.motion.AdjustColor;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.ui.Keyboard;
	import flash.events.*;
	import flash.media.*;
	import adobe.utils.*;
	import flash.accessibility.*;
	import flash.desktop.*;
	import flash.display.*;
	import flash.errors.*;
	import flash.external.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.globalization.*;
	import flash.net.*;
	import flash.net.drm.*;
	import flash.printing.*;
	import flash.profiler.*;
	import flash.sampler.*;
	import flash.sensors.*;
	import flash.system.*;
	import flash.text.*;
	import flash.text.ime.*;
	import flash.text.engine.*;
	import flash.ui.*;
	import flash.utils.*;
	import flash.xml.*;
	import flash.display.Stage;
	import MotionXML.Default.Cowgirl.DefaultCowgirlMotions;
	import MotionXML.Rosalina.Cowgirl.RosalinaCowgirlMotions;
	import ppppu.AnimationDirector;
	import ppppu.HueColorMatrixFilter;
	import ppppu.TemplateBase;
	import ppppu.MouthContainerBase;
	import com.greensock.plugins.*;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.*;
	import mx.utils.StringUtil;
	import ppppu.XmlMotionToTweens;
	//Can't use unless these components are packed into a swc, which I legally can't distribute. 
	//import flash.controls.Slider;
	//import flash.controls.Label;
	/**
	 * ...
	 * @author 
	 */
	//TODO Set up program so there is a default case to use for motion clips (ie can set a default character by name "Peach")
	/*TODO Figure out why some tweens are bad. Timelines for certain body parts (like neck) have a duration of 9999(repeating)
	 * and with this a distorted look. (for ref, neck is index ~46*/ 
	public class Main extends MovieClip
	{
		private const SIDEBOOB_MAX_HOR_SKEW:Number = -8;
		private const SIDEBOOB_MAX_VERT_SKEW:Number = -10;
		private const SIDEBOOB_SCALE_TO_START_SKEW:Number = 1.0;
		private const SIDEBOOB_MAX_Y_DISPLACEMENT:Number = 16;
		
		private const eyeColorBaseText:String = "Iris Color - R: {0}, G: {1}, B: {2}, A: {3}";
		private const scleraColorBaseText:String = "Sclera Color - R: {0}, G: {1}, B: {2}, A: {3}";
		private var eyeColorDisplayText:String = "";
		private var scleraColorDisplayText:String = "";
		private var irisColorTextField:TextField = new TextField();
		private var scleraColorTextField:TextField = new TextField();
		
		var peachCowgirl:AnimationDirector;
		var rosalinaCowgirl:AnimationDirector;
		var templateInUse:TemplateBase;
		var irisWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		var scleraWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		
		//Disabled due to legal reasons (can't distribute flash components in swc form, which is how these are usable in flash develop.
		/*var hairSliderH:Slider = new Slider();
		var hairSliderC:Slider = new Slider();
		var hairSliderV:Slider = new Slider();
		var hairSliderS:Slider = new Slider();
		var hairHLabel:Label = new Label();
		var hairSLabel:Label = new Label();
		var hairVLabel:Label = new Label();
		var hairCLabel:Label = new Label();
		var hairValueHLabel:Label = new Label();
		var hairValueSLabel:Label = new Label();
		var hairValueVLabel:Label = new Label();
		var hairValueCLabel:Label = new Label();
		var hairLabelTextField:TextField = new TextField();*/
		
		var timelinesDict:Dictionary = new Dictionary();
		
		var UsePeachGradient:Boolean = true;
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var mainClip:Symbol316_1 = new Symbol316_1();
			addChild(mainClip);
			mainClip.TemplateController.gotoAndStop("Cowgirl");
			templateInUse = mainClip.TemplateController.getChildByName("Cowgirl") as TemplateBase;
			TweenPlugin.activate([FramePlugin, FrameLabelPlugin, TransformMatrixPlugin, VisiblePlugin]);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, FrameCheck, !true);
			addEventListener(KeyboardEvent.KEY_DOWN, this.KeyPressCheck);
			
			//Class stuff
			(mainClip.TemplateController.getChildByName("Cowgirl") as TemplateBase).SetDefaultTimelines(
				ProcessMotionStaticClass(DefaultCowgirlMotions, mainClip.TemplateController.getChildByName("Cowgirl")));
			this.ProcessMotionStaticClass(RosalinaCowgirlMotions, mainClip.TemplateController.getChildByName("Cowgirl"));
			
			//Create Sliders for hair adjustment
			
			/*hairSliderH.minimum = -180;
			hairSliderH.maximum = 180;
			hairSliderH.snapInterval = 1;
			hairSliderH.tickInterval = 20;
			hairSliderH.liveDragging = true;
			
			hairSliderS.minimum = 0.0;
			hairSliderS.maximum = 6.0;
			hairSliderS.value = 1.0;
			hairSliderS.snapInterval = .01;
			hairSliderS.tickInterval = .25;
			hairSliderS.liveDragging = true;
			
			hairSliderV.minimum = 0.0;
			hairSliderV.value = 1.0;
			hairSliderV.maximum = 6.0;
			hairSliderV.snapInterval = .01;
			hairSliderV.tickInterval = .25;
			hairSliderV.liveDragging = true;
			
			hairSliderC.minimum = 0.0;
			hairSliderC.value = 1.0;
			hairSliderC.maximum = 6.0;
			hairSliderC.snapInterval = .01;
			hairSliderC.tickInterval = .25;
			hairSliderC.liveDragging = true;
			
			hairSliderH.x = hairSliderS.x = hairSliderV.x = hairSliderC.x = 500;
			hairSliderH.y = 25;
			hairSliderS.y = 75;
			hairSliderV.y = 125;
			hairSliderC.y = 175;
			
			addChild(hairSliderH);
			addChild(hairSliderS);
			addChild(hairSliderV);
			addChild(hairSliderC);
			
			var hairSliderAltH:Slider = new Slider();
			var hairSliderAltS:Slider = new Slider();
			var hairSliderAltV:Slider = new Slider();
			var hairSliderAltC:Slider = new Slider();
			
			//slider events
			hairSliderH.addEventListener(Event.CHANGE, HairSlidersChange);
			hairSliderS.addEventListener(Event.CHANGE, HairSlidersChange);
			hairSliderV.addEventListener(Event.CHANGE, HairSlidersChange);
			hairSliderC.addEventListener(Event.CHANGE, HairSlidersChange);
			
			//hair labels
			hairHLabel.x = hairSLabel.x = hairVLabel.x = hairCLabel.x = 485;
			hairHLabel.y = 5;
			hairSLabel.y = 55;
			hairVLabel.y = 105;
			hairCLabel.y = 155;
			hairHLabel.autoSize = hairSLabel.autoSize = hairVLabel.autoSize = hairCLabel.autoSize = TextFieldAutoSize.CENTER;
			hairHLabel.text = "Hue";
			hairSLabel.text = "Saturation"; 
			hairVLabel.text = "Brightness"; 
			hairCLabel.text = "Contrast";
			hairValueHLabel.x = hairValueSLabel.x = hairValueVLabel.x = hairValueCLabel.x = 550;
			hairValueHLabel.y = 15;
			hairValueSLabel.y = 65;
			hairValueVLabel.y = 115;
			hairValueCLabel.y = 165;
			hairValueHLabel.autoSize = hairValueSLabel.autoSize = hairValueVLabel.autoSize = hairValueCLabel.autoSize = TextFieldAutoSize.CENTER;
			hairValueHLabel.text = "0";
			hairValueSLabel.text = hairValueVLabel.text = hairValueCLabel.text = "1.0";
			addChild(hairHLabel);
			addChild(hairSLabel);
			addChild(hairVLabel);
			addChild(hairCLabel);
			addChild(hairValueHLabel);
			addChild(hairValueSLabel);
			addChild(hairValueVLabel);
			addChild(hairValueCLabel);*/
			
			peachCowgirl = new AnimationDirector(mainClip.TemplateController.getChildByName("Cowgirl"));
			irisColorTextField.text = eyeColorDisplayText;
			irisColorTextField.textColor = 0xFFFFFF;
			irisColorTextField.autoSize = TextFieldAutoSize.LEFT;
			irisColorTextField.x = 0;
			irisColorTextField.y = 0;
			scleraColorTextField.text = scleraColorDisplayText;
			scleraColorTextField.textColor = 0xFFFFFF;
			scleraColorTextField.autoSize = TextFieldAutoSize.LEFT;
			scleraColorTextField.x = 240;
			scleraColorTextField.y = 0;
			addChild(irisColorTextField);
			addChild(scleraColorTextField);

			ChangeSkinBase("Light");
			ChangeHeadwear("Peach");
			ChangeHairBase("Peach");
			ChangeEarring("Peach");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			
		}

		private function ProcessMotionStaticClass(motionClass:Class, template:DisplayObject):Array
		{
			var timelineArray:Array = new Array();
			var templateAnimation:TemplateBase = template as TemplateBase;
			if (templateAnimation == null)
			{
				trace("Template animation is null for processing Motion Class: " + motionClass); 
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
					var timelineForMotion:TimelineMax = new TimelineMax( { useFrames:true, repeat: -1 } );
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
		
		public function RestartTimeline()
		{
			
		}
		
		private function FrameCheck(e:Event)
		{
			templateInUse.UpdateTimelines();
		}
		
		public function KeyPressCheck(keyEvent:KeyboardEvent):void
		{
			var keyPressed:int = keyEvent.keyCode;
			if(keyPressed == Keyboard.Q)
			{	
				++irisWorkColorTransform.redOffset;
				if (irisWorkColorTransform.redOffset > 255)
				{
					irisWorkColorTransform.redOffset = 255;
				}
				UpdateIrisDisplayText();
			}
			else if(keyPressed == Keyboard.W)
			{	
				--irisWorkColorTransform.redOffset;
				if (irisWorkColorTransform.redOffset < 0)
				{
					irisWorkColorTransform.redOffset = 0;
				}
				UpdateIrisDisplayText();
			}
			if(keyPressed == Keyboard.E)
			{	
				++irisWorkColorTransform.greenOffset;
				if (irisWorkColorTransform.greenOffset > 255)
				{
					irisWorkColorTransform.greenOffset = 255;
				}
				UpdateIrisDisplayText();
			}
			else if(keyPressed == Keyboard.R)
			{	
				--irisWorkColorTransform.greenOffset;
				if (irisWorkColorTransform.greenOffset < 0)
				{
					irisWorkColorTransform.greenOffset = 0;
				}
				UpdateIrisDisplayText();
			}
			if(keyPressed == Keyboard.T)
			{	
				++irisWorkColorTransform.blueOffset;
				if (irisWorkColorTransform.blueOffset > 255)
				{
					irisWorkColorTransform.blueOffset = 255;
				}
				UpdateIrisDisplayText();
			}
			else if(keyPressed == Keyboard.Y)
			{	
				--irisWorkColorTransform.blueOffset;
				if (irisWorkColorTransform.blueOffset < 0)
				{
					irisWorkColorTransform.blueOffset = 0;
				}
				UpdateIrisDisplayText();
			}
			if(keyPressed == Keyboard.U)
			{	
				++irisWorkColorTransform.alphaOffset;
				if (irisWorkColorTransform.alphaOffset > 255)
				{
					irisWorkColorTransform.alphaOffset = 255;
				}
				UpdateIrisDisplayText();
			}
			else if(keyPressed == Keyboard.I)
			{	
				--irisWorkColorTransform.alphaOffset;
				if (irisWorkColorTransform.alphaOffset < 0)
				{
					irisWorkColorTransform.alphaOffset = 0;
				}
				UpdateIrisDisplayText();
			}
			
			if(keyPressed == Keyboard.A)
			{	
				++scleraWorkColorTransform.redOffset;
				if (scleraWorkColorTransform.redOffset > 255)
				{
					scleraWorkColorTransform.redOffset = 255;
				}
				UpdateScleraDisplayText();
			}
			else if(keyPressed == Keyboard.S)
			{	
				--scleraWorkColorTransform.redOffset;
				if (scleraWorkColorTransform.redOffset < 0)
				{
					scleraWorkColorTransform.redOffset = 0;
				}
				UpdateScleraDisplayText();
			}
			if(keyPressed == Keyboard.D)
			{	
				++scleraWorkColorTransform.greenOffset;
				if (scleraWorkColorTransform.greenOffset > 255)
				{
					scleraWorkColorTransform.greenOffset = 255;
				}
				UpdateScleraDisplayText();
			}
			else if(keyPressed == Keyboard.F)
			{	
				--scleraWorkColorTransform.greenOffset;
				if (scleraWorkColorTransform.greenOffset < 0)
				{
					scleraWorkColorTransform.greenOffset = 0;
				}
				UpdateScleraDisplayText();
			}
			if(keyPressed == Keyboard.G)
			{	
				++scleraWorkColorTransform.blueOffset;
				if (scleraWorkColorTransform.blueOffset > 255)
				{
					scleraWorkColorTransform.blueOffset = 255;
				}
				UpdateScleraDisplayText();
			}
			else if(keyPressed == Keyboard.H)
			{	
				--scleraWorkColorTransform.blueOffset;
				if (scleraWorkColorTransform.blueOffset < 0)
				{
					scleraWorkColorTransform.blueOffset = 0;
				}
				UpdateScleraDisplayText();
			}
			if(keyPressed == Keyboard.J)
			{	
				++scleraWorkColorTransform.alphaOffset;
				if (scleraWorkColorTransform.alphaOffset > 255)
				{
					scleraWorkColorTransform.alphaOffset = 255;
				}
				UpdateScleraDisplayText();
			}
			else if(keyPressed == Keyboard.K)
			{	
				--scleraWorkColorTransform.alphaOffset;
				if (scleraWorkColorTransform.alphaOffset < 0)
				{
					scleraWorkColorTransform.alphaOffset = 0;
				}
				UpdateScleraDisplayText();
			}
			if (keyPressed == Keyboard.Z)
			{
				ChangeSkinBase("Light");
			}
			else if (keyPressed == Keyboard.X)
			{
				ChangeSkinBase("Tan");
			}
			else if (keyPressed == Keyboard.C)
			{
				ChangeSkinBase("Dark");
			}
			else if (keyPressed == Keyboard.P)
			{
				templateInUse.AddTimelines(GetMotionTimelinesByType("Rosalina", templateInUse.GetName(), "Body"));
			}
			else if (keyPressed == Keyboard.O)
			{
				templateInUse.ResetToDefaultTimelines();
			}
			else if (keyPressed == Keyboard.V) //Peach
			{
				ChangeHairBase("Peach");
				ChangeEarring("Peach");
				ChangeHeadwear("Peach");
				var irisColor:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0, 255);
				irisColor.color = 0x3671C1;
				ChangeIrisColor(irisColor, 0);
				var lipsColor:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0, 255);
				lipsColor.color = 0xFF99CC;
				ChangeLipsColor(lipsColor);
				//eye stuff
				templateInUse.EyeL.eye.innerEyeContainer.MoveChildren(0, 0);
				templateInUse.EyeR.eye.innerEyeContainer.MoveChildren(0, 0);
				//reset eyelid
				templateInUse.EyeL.eye.eyelidContainer.eyelid.transform.matrix.identity();
				templateInUse.EyeR.eye.eyelidContainer.eyelid.transform.matrix.identity();
				templateInUse.EyeL.eye.gotoAndStop("Open");
				templateInUse.EyeR.eye.gotoAndStop("Open");
				
				templateInUse.ResetToDefaultTimelines();
			}
			else if (keyPressed == Keyboard.B) //Rosalina Hair
			{
				ChangeHairBase("Rosalina");
				templateInUse.AddTimelines(GetMotionTimelinesByType("Rosalina", templateInUse.GetName(), "Hair"));
			}
			else if (keyPressed == Keyboard.N) //Rosalina Earring
			{
				ChangeEarring("Rosalina");
			}
			else if (keyPressed == Keyboard.M) //Rosalina Headwear
			{
				ChangeHeadwear("Rosalina");
			}
			else if (keyPressed == Keyboard.COMMA) //Rosalina Eye
			{
				var irisColor:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0, 255);
				irisColor.color = 0x36BDC1;
				ChangeIrisColor(irisColor, 0);
				templateInUse.EyeR.eye.gotoAndStop("HalfOpen");
				templateInUse.EyeR.eye.innerEyeContainer.MoveChildren(0, 2.5);
				templateInUse.EyeL.eye.gotoAndStop("HalfOpen");
				templateInUse.EyeL.eye.innerEyeContainer.MoveChildren(0, 2.5);
				var eyelidMatrix:Matrix = new Matrix();
				XmlMotionToTweens.SetMatrixScaleY(eyelidMatrix, .6);
				XmlMotionToTweens.SetMatrixSkewY(eyelidMatrix, 3.3);
				eyelidMatrix.ty = 15.5;
				templateInUse.EyeR.eye.eyelidContainer.eyelid.transform.matrix.copyFrom(eyelidMatrix);
				templateInUse.EyeL.eye.eyelidContainer.eyelid.transform.matrix.copyFrom(eyelidMatrix);
			}
			else if (keyPressed == Keyboard.PERIOD) //Rosalina lips
			{
				var lipsColor:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0, 255);
				lipsColor.color = 0xFFCFC7;
				ChangeLipsColor(lipsColor);
			}
			else if (keyPressed == Keyboard.SLASH)
			{
				var graphicsData:Vector.<IGraphicsData> = (templateInUse.EarL.Ear.Skin.getChildAt(0) as Shape).graphics.readGraphicsData();
				UsePeachGradient = !UsePeachGradient;
				for (var i:uint = 0, l:uint = graphicsData.length; i < l; ++i)
				{
					if (graphicsData[i] is GraphicsGradientFill)
					{
						var gradientFill:GraphicsGradientFill = graphicsData[i] as GraphicsGradientFill;
						if (UsePeachGradient)
						{
							gradientFill.colors[0] = GetColorUintValue(255, 220, 198);
							gradientFill.colors[1] = GetColorUintValue(243, 182, 154);
						}
						else
						{
							gradientFill.colors[0] = GetColorUintValue(209, 149, 97);
							gradientFill.colors[1] = GetColorUintValue(164, 112, 80);
						}
						graphicsData[i] = gradientFill;
						
					}
				}
				(templateInUse.EarL.Ear.Skin.getChildAt(0) as Shape).graphics.clear();
				(templateInUse.EarL.Ear.Skin.getChildAt(0) as Shape).graphics.drawGraphicsData(graphicsData);
			}
		}
		
		private function GetColorUintValue(red:uint=0, green:uint=0, blue:uint=0):uint
		{
			if (red > 0xFF) red = 0xFF; if (green > 0xFF) green = 0xFF; if (blue > 0xFF) blue = 0xFF;
			if (red < 0x00) red = 0x00; if (green < 0x00) green = 0x00; if (blue < 0x00) blue = 0x00;
			var colorValue:uint = 0;
			colorValue += (0xFF << 24) + (red << 16) + (green << 8) + blue;
			return colorValue;
		}
		
		/*Returns an array of timelines for a certain template of a character. Optionally can specify to get timelines
		 * for a specific region. Current regions are all, hair, body, earring, headwear*/
		private function GetMotionTimelinesByType(characterName:String, templateName:String, type:String="All"):Array 
		{
			var timelines:Array = new Array();
			var charAnimDictionary:Dictionary = timelinesDict[characterName][templateName];
			if (charAnimDictionary)
			{
				var key:Object;
				var timeline:TimelineLite;
				var partName:String;
				for (key in charAnimDictionary)
				{
					timeline = charAnimDictionary[key] as TimelineLite;
					if (timeline)
					{
						partName = key as String; 
						switch(type)
						{
							case "Body":
							{
								if (partName.indexOf("Hair") == -1)
								{
									timelines[timelines.length] = timeline;
								}
								break;
							}
							case "Hair":
							{
								if (partName.indexOf("Hair") > -1)
								{
									timelines[timelines.length] = timeline;
								}
								break;
							}
							case "All": 
								timelines[timelines.length] = timeline;
								break;
						}
					}
				}
			}
			return timelines;
		}
		public function UpdateIrisDisplayText()
		{
			templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform = irisWorkColorTransform;
			templateInUse.EyeR.eye.innerEyeContainer.iris.transform.colorTransform = irisWorkColorTransform;
			var irisColorTransform:ColorTransform = templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform;
			eyeColorDisplayText = StringUtil.substitute(eyeColorBaseText, irisColorTransform.redOffset.toString(), irisColorTransform.greenOffset.toString(), irisColorTransform.blueOffset.toString(), irisColorTransform.alphaOffset.toString());
			irisColorTextField.text = eyeColorDisplayText;
		}
		public function UpdateScleraDisplayText()
		{
			templateInUse.EyeL.eye.scleraContainer.scleraColor.transform.colorTransform = scleraWorkColorTransform;
			templateInUse.EyeR.eye.scleraContainer.scleraColor.transform.colorTransform = scleraWorkColorTransform;
			var scleraColorTransform:ColorTransform = templateInUse.EyeL.eye.scleraContainer.scleraColor.transform.colorTransform;
			scleraColorDisplayText = StringUtil.substitute(scleraColorBaseText, scleraColorTransform.redOffset.toString(), scleraColorTransform.greenOffset.toString(), scleraColorTransform.blueOffset.toString(), scleraColorTransform.alphaOffset.toString());
			scleraColorTextField.text = scleraColorDisplayText;
		}
		
		/*public function HairSlidersChange(e:Event)
		{
			var hue:Number = hairSliderH.value;
			var sat:Number = hairSliderS.value;
			var value:Number = hairSliderV.value;
			var contrast:Number = hairSliderC.value;
			
			hairValueHLabel.text = hue.toString();
			hairValueSLabel.text = sat.toString();
			hairValueVLabel.text = value.toString();
			hairValueCLabel.text = contrast.toString();
			
			if (templateInUse)
			{
				var cmf:ColorMatrixFilter = GetColorMatrixFilter(hue, sat, value, contrast);
				templateInUse.HairSideL.filters = [cmf];
				templateInUse.HairSide2L.filters = [cmf];
				templateInUse.HairSide3L.filters = [cmf];
				templateInUse.HairSideR.filters = [cmf];
				templateInUse.HairSide2R.filters = [cmf];
				templateInUse.HairSide3R.filters = [cmf];
				templateInUse.HairFront.filters = [cmf];
				templateInUse.HairBack.filters = [cmf];
			}
		}*/
		
		//Source: http://blog.wonderwhy-er.com/as3-hsl-to-rgb/
		private function HSLtoRGB(a:Number, hue:Number, saturation:Number, lightness:Number):uint
		{
			a = Math.max(0,Math.min(1,a));
			saturation = Math.max(0,Math.min(1,saturation));
			lightness = Math.max(0,Math.min(1,lightness));
			hue = hue%360;
			if(hue<0)hue+=360;
			hue/=60;
			var C:Number = (1-Math.abs(2*lightness-1))*saturation;
			var X:Number = C*(1-Math.abs((hue%2)-1));
			var m:Number = lightness-1/2*C;
			C=(C+m)*255;
			X=(X+m)*255;
			m*=255;
			if(hue<1) return (Math.round(a*255)<<24)+(C<<16)+(X<<8)+m;
			if(hue<2) return (Math.round(a*255)<<24)+(X<<16)+(C<<8)+m;
			if(hue<3) return (Math.round(a*255)<<24)+(m<<16)+(C<<8)+X;
			if(hue<4) return (Math.round(a*255)<<24)+(m<<16)+(X<<8)+C;
			if(hue<5) return (Math.round(a*255)<<24)+(X<<16)+(m<<8)+C;
			return (Math.round(a*255)<<24)+(C<<16)+(m<<8)+X;
		}
		
		private function GetColorMatrixFilter(hue:Number, saturation:Number, brightness:Number, contrast:Number):ColorMatrixFilter
		{
			var colorMatrixValues:Array = new Array(1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0);
			var hueDegrees:Number = hue * Math.PI / 180.0;
			var U:Number = Math.cos(hueDegrees); //For rotation around YIQ Y axis
			var W:Number = Math.sin(hueDegrees); //For rotation around YIQ Y axis
			//var S:Number = saturation;
			var V:Number = brightness;
			var C:Number = contrast;
			var VSU:Number = V*saturation*U; //To reduce the number of multiplication operations needed
			var VSW:Number = V*saturation*W; //To reduce the number of multiplication operations needed
			var cOffset:Number = 128 - C * 128;
			colorMatrixValues[0] = (.299*V + .701*VSU + .168*VSW)*C;
			colorMatrixValues[1] = (.587*V - .587*VSU + .330*VSW)*C;
			colorMatrixValues[2] = (.114*V - .114*VSU - .497*VSW)*C;
			//colorMatrixValues[3] = 0; //alpha offset
			colorMatrixValues[4] = cOffset;
			colorMatrixValues[5] = (.299*V - .299*VSU - .328*VSW)*C;
			colorMatrixValues[6] = (.587*V + .413*VSU + .035*VSW)*C;
			colorMatrixValues[7] = (.114*V - .114*VSU + .292*VSW)*C;
			//colorMatrixValues[8] = 0; //alpha offset
			colorMatrixValues[9] = cOffset;
			colorMatrixValues[10] = (.299*V - .3*VSU + 1.25*VSW)*C;
			colorMatrixValues[11] = (.587*V - .588*VSU - 1.05*VSW)*C;
			colorMatrixValues[12] = (.114*V + .886*VSU - .203*VSW)*C; 
			//colorMatrixValues[13] = 0; //alpha offset
			colorMatrixValues[14] = cOffset;
			//colorMatrixValues[15] = 0; //alpha
			//colorMatrixValues[16] = 0; //alpha
			//colorMatrixValues[17] = 0; //alpha
			//colorMatrixValues[18] = 0; //alpha offset
			//colorMatrixValues[19] = 0;
			return new ColorMatrixFilter(colorMatrixValues);
		}
		
		//eyeToSwitch: 0 is both, 1 is lef, 2 is right
		private function ChangeIrisColor(colorTransform:ColorTransform, eyeToSwitch:uint)
		{
			irisWorkColorTransform = colorTransform;
			switch(eyeToSwitch)
			{
				case 0:
					templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform = colorTransform;
					templateInUse.EyeR.eye.innerEyeContainer.iris.transform.colorTransform = colorTransform;
					break;
				case 1:
					templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform = colorTransform;
					break;
				case 2:
					templateInUse.EyeR.eye.innerEyeContainer.iris.transform.colorTransform = colorTransform;
					break;
					
			}
			UpdateIrisDisplayText();
		}
		
		private function ChangeLipsColor(colorTransform:ColorTransform)
		{
			templateInUse.Mouth.LipsColor.transform.colorTransform = colorTransform;
		}
		private function ChangeSkinBase(type:String)
		{
			templateInUse.UpperLegL.UpperLeg.Skin.gotoAndStop(type);
			templateInUse.UpperLegR.UpperLeg.Skin.gotoAndStop(type);
			templateInUse.Groin.Groin.Skin.gotoAndStop(type);
			templateInUse.Labia.Labia.Skin.gotoAndStop(type);
			templateInUse.Hips.Hips.Skin.gotoAndStop(type);
			templateInUse.Chest.Chest.Skin.gotoAndStop(type);
			templateInUse.ArmL.Arm.Skin.gotoAndStop(type);
			templateInUse.ArmR.Arm.Skin.gotoAndStop(type);
			templateInUse.ForearmL.Forearm.Skin.gotoAndStop(type);
			templateInUse.ForearmR.Forearm.Skin.gotoAndStop(type);
			templateInUse.ShoulderL.Shoulder.Skin.gotoAndStop(type);
			templateInUse.ShoulderR.Shoulder.Skin.gotoAndStop(type);
			templateInUse.Neck.Neck.Skin.gotoAndStop(type);
			templateInUse.FrontButtL.FrontButt.Skin.gotoAndStop(type);
			templateInUse.FrontButtR.FrontButt.Skin.gotoAndStop(type);
			templateInUse.Navel.Navel.Skin.gotoAndStop(type);
			templateInUse.Face.face.Skin.gotoAndStop(type);
			templateInUse.AreolaL.Areola.gotoAndStop(type);
			templateInUse.AreolaR.Areola.gotoAndStop(type);
			templateInUse.NippleL.Nipple.gotoAndStop(type);
			templateInUse.NippleR.Nipple.gotoAndStop(type);
			templateInUse.EyeL.eye.eyelidContainer.eyelid.gotoAndStop(type);
			templateInUse.EyeR.eye.eyelidContainer.eyelid.gotoAndStop(type);
			templateInUse.EyeL.eye.scleraContainer.Skin.gotoAndStop(type);
			templateInUse.EyeR.eye.scleraContainer.Skin.gotoAndStop(type);
			templateInUse.BoobL.Breast.Skin.gotoAndStop(type);
			templateInUse.BoobR.Breast.Skin.gotoAndStop(type);
			templateInUse.EarL.Ear.Skin.gotoAndStop(type);
			templateInUse.EarR.Ear.Skin.gotoAndStop(type);
			templateInUse.HandL.Hand.Skin.gotoAndStop(type);
			templateInUse.HandR.Hand.Skin.gotoAndStop(type);
		}
		private function ChangeHairBase(type:String)
		{
			templateInUse.HairSideL.gotoAndStop(type);
			templateInUse.HairSide2L.gotoAndStop(type);
			templateInUse.HairSide3L.gotoAndStop(type);
			templateInUse.HairSideR.gotoAndStop(type);
			templateInUse.HairSide2R.gotoAndStop(type);
			templateInUse.HairSide3R.gotoAndStop(type);
			templateInUse.HairFront.gotoAndStop(type);
			templateInUse.HairBack.gotoAndStop(type);
		}
		
		private function ChangeEarring(type:String)
		{
			templateInUse.EarringL.Earring.gotoAndStop(type);
			templateInUse.EarringFrontL.Earring.gotoAndStop(type);
			templateInUse.EarringR.Earring.gotoAndStop(type);
			templateInUse.EarringFrontR.Earring.gotoAndStop(type);
		}
		private function ChangeHeadwear(type:String)
		{
			templateInUse.Headwear.gotoAndStop(type);
		}
	}
}