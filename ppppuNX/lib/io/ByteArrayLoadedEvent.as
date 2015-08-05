package io
{
	import flash.display.LoaderInfo;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.media.Sound;
	
	public class ByteArrayLoadedEvent extends Event
	{
		public static const LOADED:String = "Loaded";
		private var _loaderInfo:LoaderInfo;
		public function ByteArrayLoadedEvent(li:LoaderInfo)
		{
			_loaderInfo = li;
			super(LOADED);
		}
		public function get loaderInfo() : LoaderInfo
		{
			return _loaderInfo;
		}
		public function getBitmap() : Bitmap
		{
			return loaderInfo.content as Bitmap;
		}
		public function getSound() : Sound
		{
			return loaderInfo.content as Sound;
		}
	}
}