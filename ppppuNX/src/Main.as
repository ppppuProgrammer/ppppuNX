package
{
	import flash.display.Sprite;
	import ppppu.ppppuCore;
	import flash.events.Event;
	
	/**
	 * Main entryway into the program. Creates an instance of ppppuCore, adds it 
	 * @author ppppuProgrammer
	 */
	public class Main extends Sprite
	{
		var ppppuApp:ppppuCore;
		public function Main() 
		{
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			while (ppppuApp.initialized != true)
			{
				var i:int = 5 + 5;
			}
			ppppuApp.Setup();
		}
		
		private function init(e:Event = null):void 
		{
			ppppuApp = new ppppuCore();
			addChild(ppppuApp);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			ppppuApp.Initialize();
			//addEventListener(Event.ENTER_FRAME, FrameCheck, !true);
			//addEventListener(KeyboardEvent.KEY_DOWN, this.KeyPressCheck);
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			
		}
	}
}