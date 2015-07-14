package
{
	import flash.display.MovieClip;
	import ppppu.ppppuCore;
	import flash.events.Event;
	
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
			var ppppuApp:ppppuCore = new ppppuCore();
			addChild(ppppuApp);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			ppppuApp.Initialize();
			//addEventListener(Event.ENTER_FRAME, FrameCheck, !true);
			//addEventListener(KeyboardEvent.KEY_DOWN, this.KeyPressCheck);
			
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyPressCheck);
			
		}
	}
}