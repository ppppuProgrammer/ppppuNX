package io 
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;

	public class FileReferenceHelper 
	{
		private var fr:FileReference = new FileReference();
		/*
		 * Expect handler to be in form:
		 *	 handler(e:MediaLoadedEvent) : void
		 */
		private var handler:Function;
		
		public function FileReferenceHelper(_handler:Function, filterText:String = "Any", filterPattern:String = "*.*") 
		{
			handler = _handler;
			fr.addEventListener(Event.SELECT, fileSelected);
			var filter:FileFilter = new FileFilter(filterText, filterPattern);
			fr.browse([filter]);
		}
		
		private function fileSelected(e:Event):void 
		{
			fr.removeEventListener(Event.SELECT, fileSelected);
			fr.addEventListener(Event.COMPLETE, fileLoaded);
			fr.load();
		}
		
		private function fileLoaded(e:Event):void 
		{
			fr.removeEventListener(Event.COMPLETE, fileLoaded);
			
			var bl:ByteLoader = new ByteLoader();
			bl.addEventListener(ByteArrayLoadedEvent.LOADED, handler);
			bl.load(fr.data);
		}
		
	}

}