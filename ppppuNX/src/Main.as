package
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author 
	 */
	public class Main extends MovieClip
	{
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			//var mainClip:Symbol316_1 = new Symbol316_1();
			var sliderTest:RGBMenu = new RGBMenu();
			//var sliderTest:MenuSlider = new MenuSlider();
			sliderTest.x = 100;
			sliderTest.y = 100;
			addChild(sliderTest);
			/*sliderTest.SetMaxValue(255);
			sliderTest.SetMinValue(-255);*/
			//sliderTest.scaleX = 2.0;
			//sliderTest.scaleY = 2.5;
			
			var hsvMenu:HSVMenu = new HSVMenu();
			hsvMenu.x = 100;
			hsvMenu.y = 200;
			addChild(hsvMenu);
			
			var charMenu:CharacterMenu = new CharacterMenu();
			charMenu.x = 100;
			charMenu.y = 400;
			addChild(charMenu);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//addEventListener(Event.ENTER_FRAME, FrameCheck, !true);
			addEventListener(KeyboardEvent.KEY_DOWN, this.KeyPressCheck);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			
		}
		public function KeyPressCheck(keyEvent:KeyboardEvent):void
		{
			var keyPressed:int = keyEvent.keyCode;
			if(keyPressed == Keyboard.Q)
			{	
			}
		}
	}
}