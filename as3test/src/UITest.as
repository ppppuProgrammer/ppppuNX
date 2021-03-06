// 7ch.purpledrank

package
{
	import com.bit101.components.Accordion;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import com.bit101.components.Slider;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import ui.HSVCMenu;
	import ui.PopupButton;
	import ui.RGBAMenu;
	import ui.SlidingPanel;
	public class UITest extends Sprite 
	{
		
		public function UITest() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			

			var p:Panel = new Panel(null, 0, 0);
			p.setSize(130, 80)
			
			
			
			var rgba_iris:ui.RGBAMenu = new ui.RGBAMenu("Iris:");
			rgba_iris.addEventListener(Event.CHANGE, handler);
			var pb_iris:ui.PopupButton = new ui.PopupButton(p, 10, 10, "Iris");
			pb_iris.bindPopup(rgba_iris, "rightOuter", "topInner");
			
			
			var hsvc_hair:ui.HSVCMenu = new ui.HSVCMenu("Hair:");
			hsvc_hair.addEventListener(Event.CHANGE, handler);
			var pb_hair:ui.PopupButton = new ui.PopupButton(p, 10, 40, "Hair");
			pb_hair.bindPopup(hsvc_hair, "rightOuter", "topInner");
			
			var slidingPanel:SlidingPanel = new SlidingPanel(p, new Rectangle(0, 0, 100, 100), new Point( -100, 0), new Point(0, 0));
			slidingPanel.x = 200;
			slidingPanel.y = 200;
			addChild(slidingPanel);
		}
		
		private function handler(e:Event):void 
		{
			//var m:RGBAMenu = e.target as RGBAMenu;
			//trace(m.R.toString() + "_" + m.G.toString() + "_" + m.B.toString() + "_" + m.A.toString());
			//Do something with m .R .G .B .A
		}
		
		
	}
	
}