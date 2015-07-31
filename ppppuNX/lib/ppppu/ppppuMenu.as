package ppppu 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ui.HSVCMenu;
	import ui.PopupButton;
	import ui.RGBAMenu;
	import ui.SlidingPanel;

	public class ppppuMenu extends Sprite
	{
		private var irisWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,54,113,193,255);
		private var scleraWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		private var lipsWorkColorTransform:ColorTransform = new ColorTransform(0, 0, 0, 0, 255, 153, 204, 255);
		
		private var hairColorMenu:ui.HSVCMenu = new ui.HSVCMenu("Hair");
		private var skinColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Skin");
		private var scleraColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Sclera");
		private var irisLColorMenu:ui.RGBAMenu = new ui.RGBAMenu("IrisL");
		private var irisRColorMenu:ui.RGBAMenu = new ui.RGBAMenu("IrisR");
		private var lipsColorMenu:ui.RGBAMenu = new ui.RGBAMenu("Lips");
		
		private var templateInUse:TemplateBase;
		
		public function ppppuMenu(target:TemplateBase) 
		{
			templateInUse = target;
			InitMenu();
		}
				
		private function InitMenu() : void
		{
			var p_Menu:Panel = new Panel(null);
			p_Menu.setSize(480, 120);
			
			var sp_Menu:SlidingPanel = new SlidingPanel(p_Menu, new Rectangle(0, 690, 480, 30), new Point(0, 720), new Point(0, 600));
			addChild(sp_Menu);
			
			var p_GradientSubMenu:Panel = new Panel(null);
			p_GradientSubMenu.setSize(100, 80);
			//Add labels for skin gradients sub menu
			var l_faceGradient:Label = new Label(p_GradientSubMenu, 0, 0, "Face");
			var l_breastGradient:Label = new Label(p_GradientSubMenu, 0, 20, "Breast");
			var l_vulvaGradient:Label = new Label(p_GradientSubMenu, 0, 40, "Vulva");
			var l_anusGradient:Label = new Label(p_GradientSubMenu, 0, 60, "Anus");
			
			
			//Add buttons for the gradient sub menu
			
			//Face/Ear buttons
			var pb_faceGradPoint1:PopupButton = new PopupButton(p_GradientSubMenu, 35, 1);
			pb_faceGradPoint1.setSize(16, 16);
			pb_faceGradPoint1.addChild(new ColorButtonGraphic);
			
			var pb_faceGradPoint2:PopupButton = new PopupButton(p_GradientSubMenu, 55, 1);
			pb_faceGradPoint2.setSize(16, 16);
			pb_faceGradPoint2.addChild(new ColorButtonGraphic);
			
			//Vulva buttons
			var pb_vulvaGradPoint1:PopupButton = new PopupButton(p_GradientSubMenu, 35, 41);
			pb_vulvaGradPoint1.setSize(16, 16);
			pb_vulvaGradPoint1.addChild(new ColorButtonGraphic);
			
			var pb_vulvaGradPoint2:PopupButton = new PopupButton(p_GradientSubMenu, 55, 41);
			pb_vulvaGradPoint2.setSize(16, 16);
			pb_vulvaGradPoint2.addChild(new ColorButtonGraphic);
			
			//Anus buttons
			var pb_anusGradPoint1:PopupButton = new PopupButton(p_GradientSubMenu, 35, 61);
			pb_anusGradPoint1.setSize(16, 16);
			pb_anusGradPoint1.addChild(new ColorButtonGraphic);
			
			var pb_anusGradPoint2:PopupButton = new PopupButton(p_GradientSubMenu, 55, 61);
			pb_anusGradPoint2.setSize(16, 16);
			pb_anusGradPoint2.addChild(new ColorButtonGraphic);
			
			//Breast buttons
			var pb_breastGradPoint1:PopupButton = new PopupButton(p_GradientSubMenu, 35, 21);
			pb_breastGradPoint1.setSize(16, 16);
			pb_breastGradPoint1.addChild(new ColorButtonGraphic);
			
			var pb_breastGradPoint2:PopupButton = new PopupButton(p_GradientSubMenu, 55, 21);
			pb_breastGradPoint2.setSize(16, 16);
			pb_breastGradPoint2.addChild(new ColorButtonGraphic);
			
			var pb_breastGradPoint3:PopupButton = new PopupButton(p_GradientSubMenu, 75, 21);
			pb_breastGradPoint3.setSize(16, 16);
			pb_breastGradPoint3.addChild(new ColorButtonGraphic);
			
			var con_iris:Sprite = new Sprite();
			irisRColorMenu.x = 160;
			con_iris.addChild(irisLColorMenu);
			con_iris.addChild(irisRColorMenu);
			var pb_iris:ui.PopupButton = new ui.PopupButton(p_Menu, 10, 10, "Iris");
			pb_iris.bindPopup(con_iris, "rightOuter", "bottomInner");
			
			var pb_hair:ui.PopupButton = new ui.PopupButton(p_Menu, 10, 30, "Hair");
			pb_hair.bindPopup(hairColorMenu, "rightOuter", "bottomInner");
			
			var pb_sclera:ui.PopupButton = new ui.PopupButton(p_Menu, 10, 50, "Sclera");
			pb_sclera.bindPopup(scleraColorMenu, "rightOuter", "bottomInner");
			
			var pb_lips:ui.PopupButton = new ui.PopupButton(p_Menu, 10, 70, "Lips");
			pb_lips.bindPopup(lipsColorMenu, "rightOuter", "bottomInner");
			
			var pb_skin:ui.PopupButton = new ui.PopupButton(p_Menu, 10, 90, "Skin");
			pb_skin.bindPopup(skinColorMenu, "rightOuter", "bottomInner");
			
			var pb_skinGradients:PopupButton = new PopupButton(p_Menu, 120, 90, "Skin Gradients");
			pb_skinGradients.bindPopup(p_GradientSubMenu, "rightOuter", "bottomInner");
			
			hairColorMenu.addEventListener(Event.CHANGE, HairSlidersChange);
			skinColorMenu.addEventListener(Event.CHANGE, SkinSlidersChange);
			scleraColorMenu.addEventListener(Event.CHANGE, ScleraSliderChanged);
			scleraColorMenu.setValue(scleraWorkColorTransform);
			lipsColorMenu.addEventListener(Event.CHANGE, LipsSliderChanged);
			lipsColorMenu.setValue(lipsWorkColorTransform);
			irisLColorMenu.addEventListener(Event.CHANGE, IrisLSliderChanged);
			irisLColorMenu.setValue(irisWorkColorTransform);
			irisRColorMenu.addEventListener(Event.CHANGE, IrisRSliderChanged);
			irisRColorMenu.setValue(irisWorkColorTransform);
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
			templateInUse.EyeL.Element.ScleraSettings.Sclera.scleraColor.transform.colorTransform = ct;
			templateInUse.EyeR.Element.ScleraSettings.Sclera.scleraColor.transform.colorTransform = ct;
		}
		private function IrisLSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.EyeL.Element.InnerEyeSettings.InnerEye.Iris.transform.colorTransform = ct;
		}
		private function IrisRSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.EyeR.Element.InnerEyeSettings.InnerEye.Iris.transform.colorTransform = ct;
		}
		
		public function SkinSlidersChange(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			//Alpha is to never be adjustable
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, 255);
			//var cmf:ColorMatrixFilter = GetColorMatrixFilter(m.H, m.S, m.V, m.C);
			
			//Color only
			templateInUse.UpperLegL.Element.Skin.transform.colorTransform = ct;
			templateInUse.UpperLegR.Element.Skin.transform.colorTransform = ct;
			templateInUse.Groin.Element.Skin.transform.colorTransform = ct;
			templateInUse.Groin2.Element.Skin.transform.colorTransform = ct;
			templateInUse.Hips.Element.Skin.transform.colorTransform = ct;
			templateInUse.Hips2.Element.Skin.transform.colorTransform = ct;
			templateInUse.TurnedHips.Element.Skin.transform.colorTransform = ct;
			templateInUse.TurnedMidTorso.Element.Skin.transform.colorTransform = ct;
			templateInUse.TurnedUpperTorso.Element.Skin.transform.colorTransform = ct;
			//templateInUse.Vulva.Element.SkinGradient.transform.colorTransform = ct;
			templateInUse.Vulva2.Element.Skin.transform.colorTransform = ct;
			//templateInUse.VulvaBackview.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.TurnedVulva.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.Anus.Element.SkinGradient.transform.colorTransform = ct;
			templateInUse.MidTorso.Element.Skin.transform.colorTransform = ct;
			templateInUse.UpperTorso.Element.Skin.transform.colorTransform = ct;
			templateInUse.MidBack.Element.Skin.transform.colorTransform = ct;
			templateInUse.UpperBack.Element.Skin.transform.colorTransform = ct;
			templateInUse.LowerBack.Element.Skin.transform.colorTransform = ct;
			templateInUse.Chest.Element.Skin.transform.colorTransform = ct;
			templateInUse.ArmL.Element.Skin.transform.colorTransform = ct;
			templateInUse.ArmR.Element.Skin.transform.colorTransform = ct;
			templateInUse.Arm2L.Element.Skin.transform.colorTransform = ct;
			templateInUse.Arm2R.Element.Skin.transform.colorTransform = ct;
			templateInUse.Arm3L.Element.Skin.transform.colorTransform = ct;
			templateInUse.Arm3R.Element.Skin.transform.colorTransform = ct;
			templateInUse.ForearmL.Element.Skin.transform.colorTransform = ct;
			templateInUse.ForearmR.Element.Skin.transform.colorTransform = ct;
			templateInUse.ShoulderL.Element.Skin.transform.colorTransform = ct;
			templateInUse.ShoulderR.Element.Skin.transform.colorTransform = ct;
			templateInUse.Neck.Element.Skin.transform.colorTransform = ct;
			templateInUse.FrontButtL.Element.Skin.transform.colorTransform = ct;
			templateInUse.FrontButtR.Element.Skin.transform.colorTransform = ct;
			templateInUse.ButtCheekL.Element.Skin.transform.colorTransform = ct;
			templateInUse.ButtCheekR.Element.Skin.transform.colorTransform = ct;
			templateInUse.Navel.Element.Skin.transform.colorTransform = ct;
			//templateInUse.Face.Element.SkinGradient.transform.colorTransform = ct;
			templateInUse.TurnedFace.Element.Skin.transform.colorTransform = ct;
			templateInUse.TurnedFace2.Element.Skin.transform.colorTransform = ct;
			templateInUse.TurnedFace3.Element.Skin.transform.colorTransform = ct;
			//templateInUse.AreolaL.Element.transform.colorTransform = ct;
			//templateInUse.AreolaR.Element.transform.colorTransform = ct;
			//templateInUse.NippleL.Element.transform.colorTransform = ct;
			//templateInUse.NippleR.Element.transform.colorTransform = ct;
			templateInUse.EyeL.Element.EyelidSettings.Eyelid.transform.colorTransform = ct;
			templateInUse.EyeR.Element.EyelidSettings.Eyelid.transform.colorTransform = ct;
			templateInUse.EyeL.Element.ScleraSettings.Sclera.Skin.transform.colorTransform = ct;
			templateInUse.EyeR.Element.ScleraSettings.Sclera.Skin.transform.colorTransform = ct;
			templateInUse.BoobL.Element.Skin.transform.colorTransform = ct;
			templateInUse.BoobR.Element.Skin.transform.colorTransform = ct;
			//templateInUse.Boob2L.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.Boob2R.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.Boob3L.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.Boob3R.Element.SkinGradient.transform.colorTransform = ct;
			templateInUse.SideBoobL.Element.Skin.transform.colorTransform = ct;
			//templateInUse.EarL.Element.SkinGradient.transform.colorTransform = ct;
			//templateInUse.EarR.Element.SkinGradient.transform.colorTransform = ct;
			templateInUse.HandL.Element.Skin.transform.colorTransform = ct;
			templateInUse.HandR.Element.Skin.transform.colorTransform = ct;
			templateInUse.Hand2L.Element.Skin.transform.colorTransform = ct;
			templateInUse.Hand2R.Element.Skin.transform.colorTransform = ct;
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
				templateInUse.HairFrontAngled.filters = [cmf];
				templateInUse.HairFrontAngled2.filters = [cmf];
				templateInUse.HairBack.filters = [cmf];
			}
		}
	}

}