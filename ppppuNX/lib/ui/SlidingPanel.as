package ui 
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SlidingPanel extends Sprite 
	{
		private var edgeHint:Sprite = new Sprite();
		private var mouseArea:Rectangle = null;
		private var startPoint:Point = null;
		private var endPoint:Point = null;
		private var panelContainer:Sprite = null;
		
		private var slideActive:Boolean = false;
		private var mouseInArea:Boolean = false;
		
		private const SMOOTHING:uint = 4;
		private const TIMEOUT:uint = 20;
		private var timeoutTicks:uint = 0;
		
		public function SlidingPanel(_panelContainer:Sprite, _mouseArea:Rectangle, _startPoint:Point, _endPoint:Point) 
		{
			panelContainer = _panelContainer;
			startPoint = _startPoint;
			endPoint = _endPoint;
			mouseArea = _mouseArea;
			
			

			addEventListener(Event.ENTER_FRAME, tick);
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_mouseArea.width, _mouseArea.height, (Math.PI/180)*90, 0, 00);
			edgeHint.graphics.beginGradientFill(GradientType.LINEAR,[ 0x002255, 0x002255], [0, .6], [ 0, 255], matrix);
			edgeHint.graphics.drawRect( 0, 0, _mouseArea.width, _mouseArea.height);
			edgeHint.graphics.endFill();
			edgeHint.x = mouseArea.x;
			edgeHint.y = mouseArea.y;
			
			addChild(edgeHint);
			
			panelContainer.x = startPoint.x;
			panelContainer.y = startPoint.y;
			
			panelContainer.visible = false;
			panelContainer.mouseEnabled = panelContainer.mouseChildren = slideActive;
			addChild(panelContainer);
		}
		
		private function tick(e:Event):void 
		{
			var mouseLoc:Point = new Point(mouseX, mouseY);
			mouseInArea = mouseArea.containsPoint(mouseLoc) || (slideActive && panelContainer.hitTestPoint(mouseLoc.x + x, mouseLoc.y + y, true));
			
			var targetAlpha:Number = mouseInArea ? 1 : 0;
			edgeHint.alpha += (targetAlpha - edgeHint.alpha) / SMOOTHING;
						
			if ((mouseInArea && !slideActive) || (!mouseInArea && slideActive)) timeoutTicks++;
			else timeoutTicks = 0;
			
			if (timeoutTicks == TIMEOUT)
			{
				if (slideActive) { timeoutTicks = 0; return; } //TODO: for debug purposes so menu doesn't close. remove this asap
				slideActive = !slideActive;
				if (slideActive) panelContainer.visible = true;
			}
			
			panelContainer.mouseEnabled = panelContainer.mouseChildren = slideActive;
			
			//Triggered once when menu is closing.
			if (!slideActive && timeoutTicks == TIMEOUT)
			{
				//Mouse up event releases active dragging on sliders.
				stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, -1000, -1000, stage));
				//Mouse down collapses popup buttons.
				stage.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, -1000, -1000, stage));
			}
			
			//Prevent rounding nonsense, snap to target if distance < threshold.
			var targetPoint:Point = slideActive ? endPoint : startPoint;
			if (Point.distance(new Point(panelContainer.x, panelContainer.y), targetPoint) < 3)
			{
				panelContainer.x = targetPoint.x;
				panelContainer.y = targetPoint.y;
				if (!slideActive) panelContainer.visible = false;
				return;
			}
			
			panelContainer.x += (targetPoint.x - panelContainer.x) / SMOOTHING;
			panelContainer.y += (targetPoint.y - panelContainer.y) / SMOOTHING;
			
		}
		
		public function IsPanelActive():Boolean
		{
			return this.panelContainer.visible;
		}
	}

}