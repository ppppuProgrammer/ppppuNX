package io
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;

	public class ByteLoader extends EventDispatcher
	{
		public function ByteLoader() { }
		
		public function load(ba:ByteArray) : void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT,
				function(e:Event) : void
				{
					var ev:ByteArrayLoadedEvent = new ByteArrayLoadedEvent(e.target as LoaderInfo);
					dispatchEvent(ev);
				}
			);
			loader.loadBytes(ba);
		}
		
		private function errorHandler(e:IOErrorEvent):void 
		{
			//Nothing, for now.
		}
	}
}