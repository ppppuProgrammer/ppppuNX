package ppppu 
{
	import com.bit101.components.Panel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ui.HSVCMenu;
	import ui.RGBAMenu;
	import ui.SlidingPanel;

	public class ppppuMenu extends Sprite
	{
		private var irisWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,54,113,193,255);
		private var scleraWorkColorTransform:ColorTransform = new ColorTransform(0,0,0,0,255,255,255,255);
		private var lipsWorkColorTransform:ColorTransform = new ColorTransform(0, 0, 0, 0, 255, 153, 204, 255);
		
		private var hairColorMenu:ui.HSVCMenu = new ui.HSVCMenu("Hair");
		private var skinColorMenu:ui.HSVCMenu = new ui.HSVCMenu("Skin");
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
			templateInUse.EyeL.eye.scleraContainer.scleraColor.transform.colorTransform = ct;
			templateInUse.EyeR.eye.scleraContainer.scleraColor.transform.colorTransform = ct;
		}
		private function IrisLSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
			templateInUse.EyeL.eye.innerEyeContainer.iris.transform.colorTransform = ct;
		}
		private function IrisRSliderChanged(e:Event)
		{
			var m:ui.RGBAMenu = e.target as ui.RGBAMenu;
			var ct:ColorTransform = new ColorTransform(0, 0, 0, 0, m.R, m.G, m.B, m.A);
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
				templateInUse.HairBack.filters = [cmf];
			}
		}
	}

}