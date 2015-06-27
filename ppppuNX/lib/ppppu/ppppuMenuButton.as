package ppppu 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	public class ppppuMenuButton extends MovieClip
	{
		private var m_menuIndex:int = -1;
		private var m_menuCommand:String = null;
		public function ppppuMenuButton()
		{
			try
			{
				gotoAndStop("_up");
			}
			catch(error:ArgumentError)
			{
				gotoAndStop(1);
			}
		}
		public function SetButtonFunction(command:String, indexNum:int=-1)
		{
			if(command != null)
			{
				m_menuCommand = command;
			}
			else
			{
				return;
			}
			if(indexNum >= 0)
			{
				m_menuIndex = indexNum;
			}
			
			buttonMode = true;
		}
		
		public function SetHitArea(hitZone:Sprite)
		{
			if(hitArea != null)
			{
				removeChildren();
			}
			hitZone.mouseEnabled = false;
			hitZone.visible = false;
			hitArea = hitZone;
			addChild(hitArea);
		}
		
		public function GetMenuIndex():int
		{
			return m_menuIndex;
		}
		
		public function GetMenuCommand():String
		{
			return m_menuCommand;
		}
	}
}