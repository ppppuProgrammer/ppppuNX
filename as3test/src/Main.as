package
{
	import As3Test_fla.Symbol316_1;
	import com.greensock.data.TweenLiteVars;
	import fl.motion.AdjustColor; /* To use this with flash develop, it is required to change the compiler options to include the flash.swc that comes with flash pro. That can be found in (Adobe Flash directory)\Common\Configuration\ActionScript 3.0\libs\flash.swc */
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
	import ui.HSVCMenu;
	import ui.PopupButton;
	import ui.RGBAMenu;
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
		
		var peachCowgirl:AnimationDirector;
		var rosalinaCowgirl:AnimationDirector;
		var templateInUse:TemplateBase;
		var irisWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		var scleraWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		
		var hairColorMenu:ui.HSVCMenu = new ui.HSVCMenu("Hair");
		var skinColorMenu:ui.HSVCMenu = new ui.HSVCMenu("Skin");
		var scleraColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Sclera");
		var irisColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Iris");
		var lipsColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Lips");
		
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
			
			
			var pb_iris:ui.PopupButton = new ui.PopupButton(this, 480, 50, "Iris");
			pb_iris.bindPopup(irisColorMenu, "leftOuter", "topInner");
			
			var pb_hair:ui.PopupButton = new ui.PopupButton(this, 480, 70, "Hair");
			pb_hair.bindPopup(hairColorMenu, "leftOuter", "topInner");
			
			var pb_sclera:ui.PopupButton = new ui.PopupButton(this, 480, 90, "Sclera");
			pb_sclera.bindPopup(scleraColorMenu, "leftOuter", "topInner");
			
			var pb_lips:ui.PopupButton = new ui.PopupButton(this, 480, 110, "Lips");
			pb_lips.bindPopup(lipsColorMenu, "leftOuter", "topInner");
			
			var pb_skin:ui.PopupButton = new ui.PopupButton(this, 480, 130, "Skin");
			pb_skin.bindPopup(skinColorMenu, "leftOuter", "topInner");
			
			hairColorMenu.addEventListener(Event.CHANGE, HairSlidersChange);
			skinColorMenu.addEventListener(Event.CHANGE, SkinSlidersChange);
			scleraColorMenu.addEventListener(Event.CHANGE, ScleraSliderChanged);
			irisColorMenu.addEventListener(Event.CHANGE, IrisSliderChanged);
			lipsColorMenu.addEventListener(Event.CHANGE, LipsSliderChanged);
						
			peachCowgirl = new AnimationDirector(mainClip.TemplateController.getChildByName("Cowgirl"));

			
	
			ChangeSkinBase("Light");
			ChangeHeadwear("Peach");
			ChangeHairBase("Peach");
			ChangeEarring("Peach");
			ChangeLeggings("Peach");
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
			switch(keyPressed)
			{
				case Keyboard.Z:
					ChangeSkinBase("Light");
					break;
				case Keyboard.X:
					ChangeSkinBase("Tan");
					break;
				case Keyboard.C:
					ChangeSkinBase("Dark");
					break;
				case Keyboard.P:
					templateInUse.AddTimelines(GetMotionTimelinesByType("Rosalina", templateInUse.GetName(), "Body"));
					ChangeLeggings("Rosalina");
					break;
				case Keyboard.O:
					templateInUse.ResetToDefaultTimelines();
					break;
				case Keyboard.V:
					ChangeHairBase("Peach");
					ChangeEarring("Peach");
					ChangeHeadwear("Peach");
					ChangeLeggings("Peach");
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
					break;
				case Keyboard.B:
					ChangeHairBase("Rosalina");
					templateInUse.AddTimelines(GetMotionTimelinesByType("Rosalina", templateInUse.GetName(), "Hair"));
					break;
				case Keyboard.N:
					ChangeEarring("Rosalina");
					break;
				case Keyboard.M:
					ChangeHeadwear("Rosalina");
					break;
				case Keyboard.COMMA:
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
					break;
				case Keyboard.PERIOD:
					var lipsColor:ColorTransform = new ColorTransform(0, 0, 0, 0, 0, 0, 0, 255);
					lipsColor.color = 0xFFCFC7;
					ChangeLipsColor(lipsColor);
					break;
				case Keyboard.SLASH: //Experiment code for changing the gradient fill of a shape. Only affects the left ear.
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
					break;
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
		

		private function LipsSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.Mouth.LipsColor.transform.colorTransform = ct;
		}
		private function ScleraSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.EyeL.eye.scleraContainer.scleraColor.transform.colorTransform = ct;
			templateInUse.EyeR.eye.scleraContainer.scleraColor.transform.colorTransform = ct;
		}
		private function IrisSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform = ct;
			templateInUse.EyeR.eye.innerEyeContainer.iris.transform.colorTransform = ct;
		}
		
		public function SkinSlidersChange(e:Event)
		{
			var m:ui.HSVCMenu = e.target as ui.HSVCMenu;
			var cmf:ColorMatrixFilter = GetColorMatrixFilter(m.H, m.S, m.V, m.C);
			
			templateInUse.UpperLegL.UpperLeg.Skin.filters = [cmf];
			templateInUse.UpperLegR.UpperLeg.Skin.filters = [cmf];
			templateInUse.Groin.Groin.Skin.filters = [cmf];
			templateInUse.Labia.Labia.Skin.filters = [cmf];
			templateInUse.Hips.Hips.Skin.filters = [cmf];
			templateInUse.Chest.Chest.Skin.filters = [cmf];
			templateInUse.ArmL.Arm.Skin.filters = [cmf];
			templateInUse.ArmR.Arm.Skin.filters = [cmf];
			templateInUse.ForearmL.Forearm.Skin.filters = [cmf];
			templateInUse.ForearmR.Forearm.Skin.filters = [cmf];
			templateInUse.ShoulderL.Shoulder.Skin.filters = [cmf];
			templateInUse.ShoulderR.Shoulder.Skin.filters = [cmf];
			templateInUse.Neck.Neck.Skin.filters = [cmf];
			templateInUse.FrontButtL.FrontButt.Skin.filters = [cmf];
			templateInUse.FrontButtR.FrontButt.Skin.filters = [cmf];
			templateInUse.Navel.Navel.Skin.filters = [cmf];
			templateInUse.Face.face.Skin.filters = [cmf];
			templateInUse.AreolaL.Areola.filters = [cmf];
			templateInUse.AreolaR.Areola.filters = [cmf];
			templateInUse.NippleL.Nipple.filters = [cmf];
			templateInUse.NippleR.Nipple.filters = [cmf];
			templateInUse.EyeL.eye.eyelidContainer.eyelid.filters = [cmf];
			templateInUse.EyeR.eye.eyelidContainer.eyelid.filters = [cmf];
			templateInUse.EyeL.eye.scleraContainer.Skin.filters = [cmf];
			templateInUse.EyeR.eye.scleraContainer.Skin.filters = [cmf];
			templateInUse.BoobL.Breast.Skin.filters = [cmf];
			templateInUse.BoobR.Breast.Skin.filters = [cmf];
			templateInUse.EarL.Ear.Skin.filters = [cmf];
			templateInUse.EarR.Ear.Skin.filters = [cmf];
			templateInUse.HandL.Hand.Skin.filters = [cmf];
			templateInUse.HandR.Hand.Skin.filters = [cmf];
		}
		
		public function HairSlidersChange(e:Event)
		{
			var m:ui.HSVCMenu = e.target as ui.HSVCMenu;
			var cmf:ColorMatrixFilter = GetColorMatrixFilter(m.H, m.S, m.V, m.C);
			
			if (templateInUse)
			{
				templateInUse.HairSideL.filters = [cmf];
				templateInUse.HairSide2L.filters = [cmf];
				templateInUse.HairSide3L.filters = [cmf];
				templateInUse.HairSideR.filters = [cmf];
				templateInUse.HairSide2R.filters = [cmf];
				templateInUse.HairSide3R.filters = [cmf];
				templateInUse.HairFront.filters = [cmf];
				templateInUse.HairBack.filters = [cmf];
			}
		}

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
		private function ChangeIrisColor(colorTransform:ColorTransform, eyeToSwitch:uint = 0)
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
		}
		
		
		private function ChangeLipsColor(colorTransform:ColorTransform)
		{
			templateInUse.Mouth.LipsColor.transform.colorTransform = colorTransform;
		}
		/*private function ChangeScleraColor()
		{
			templateInUse.EyeL.eye.scleraContainer.scleraColor.transform.colorTransform;
			templateInUse.EyeR.eye.scleraContainer.scleraColor.transform.colorTransform;
		}*/
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
		
		private function ChangeLeggings(type:String)
		{
			templateInUse.LowerLegL.LowerLeg.Color.gotoAndStop(type);
			templateInUse.LowerLegR.LowerLeg.Color.gotoAndStop(type);
		}
	}
}