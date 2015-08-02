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
	import ppppu.ppppuMenu;
	public class PopupButton extends PushButton
	{
		private const panelPadding:uint = 10;
		
		private var halign:String = null;
		private var valign:String = null;
		private var panel:Panel = null;
		private var boundSprite:DisplayObjectContainer;
		private var eventPriority:int = -1;
		
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
		
		public function adjustPanel(_visible:Boolean) : void
		{
			if (panel == null) return;
			if (panel.parent == null && _visible)  
			parent.addChild(panel);
			if (panel.parent != null && !_visible) 
			parent.removeChild(panel);
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
			adjustPanel(panel.parent == null);
			
			if (panel.visible) 
			{
				/*To allow for submenus, the event listener needs information on the order to execute. Otherwise
				 * the earliest added button will have it's handleClick done first, leaving its children to no longer
				 * have access to the stage, causing an error if they have a function relying on the stage (like handleClick).*/
				if (eventPriority == -1)
				{
					var currentContainer:DisplayObjectContainer = this;
					//If the parent is an instance of the main menu, stop.
					while (!(currentContainer.parent is ppppuMenu))
					{
						//Set currentContainer to its parent
						currentContainer = currentContainer.parent;
						//Increase event priority
						++eventPriority;
					}
					if (eventPriority == -1) { eventPriority = 0 }; //Fail safe
				}
				stage.addEventListener(MouseEvent.MOUSE_DOWN, handleClick, false, eventPriority);
			}
			else stage.removeEventListener(MouseEvent.MOUSE_DOWN, handleClick);
			
		}
		
		public function bindPopup(sprite:DisplayObjectContainer, _halign:String, _valign:String) : void
		{
			panel = new Panel(parent);
			
			boundSprite = sprite;
			adjustPanel(false);
			
			boundSprite.x = panelPadding;
			boundSprite.y = panelPadding;
			panel.addChild(boundSprite);
			halign = _halign;
			valign = _valign;
		}
		
	}

}