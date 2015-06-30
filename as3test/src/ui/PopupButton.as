package ui 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	public class PopupButton extends PushButton
	{
		private const panelPadding:uint = 10;
		
		private var halign:String = null;
		private var valign:String = null;
		private var panel:Panel = null;
		private var boundSprite:DisplayObjectContainer;
		
		public function PopupButton(parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number =  0, label:String = "")
		{
			super(parent, xpos, ypos, label, togglePopup);
		}
		
		private function handleClick(e:MouseEvent):void 
		{
			if (this.hitTestPoint(e.stageX, e.stageY) || panel.hitTestPoint(e.stageX, e.stageY)) return;
			adjustPanel(false);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleClick);
		}
		
		private function adjustPanel(_visible:Boolean) : void
		{
			if (panel == null) return;
			panel.visible = _visible;
			panel.mouseEnabled = _visible;
		}
		
		private function togglePopup(e:Event):void 
		{
			if (panel == null) return;
			
			panel.setSize(boundSprite.width + (2 * panelPadding), boundSprite.height + (2 * panelPadding));
			
			switch(halign)
			{
				case "leftInner":
					panel.x = x;
					break;
				case "leftOuter":
					panel.x = x-panel.width;
					break;
				case "rightOuter":
					panel.x = x + width;
					break;
				case "rightInner":
					panel.x = x + width - panel.width;
					break;
				case "middle":
					panel.x = x + width / 2 - panel.width / 2;
					break;
			}
			switch(valign)
			{
				case "topInner":
					panel.y = y;
					break;
				case "topOuter":
					panel.y = y-panel.height;
					break;
				case "bottomOuter":
					panel.y = y + height;
					break;
				case "bottomInner":
					panel.y = y + height - panel.height;
					break;
				case "middle":
					panel.y = y + height / 2 - panel.height / 2;
					break;
			}
			adjustPanel(!panel.visible);
			
			if (panel.visible) stage.addEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			else stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			
		}
		
		public function bindPopup(sprite:DisplayObjectContainer, _halign:String, _valign:String) : void
		{
			panel = new Panel(parent);
			
			boundSprite = sprite;
			panel.visible = false;
			
			boundSprite.x = panelPadding;
			boundSprite.y = panelPadding;
			panel.addChild(boundSprite);
			halign = _halign;
			valign = _valign;
		}
		
	}

}