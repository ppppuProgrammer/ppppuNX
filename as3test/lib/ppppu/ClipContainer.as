package ppppu {
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/*Holds various movie clips that are used for animation differences from a base template. 
	Generally will be used for facial and hair changes.*/
	
	/*A container for a movie clip on a template animation. Can only hold 1 movie clip at a time.*/
	public class ClipContainer extends MovieClip 
	{
		
		//private var characterClips:Dictionary = new Dictionary();
		private var m_clip:MovieClip;
		public function ClipContainer() 
		{
			// constructor code
			this.x = 0;
			this.y = 0;
			this.visible = true;
			//this.alpha = 0;
		}
		
		public function SetClipForDisplaying(clip:MovieClip/*, characterName:String="Default"*/)
		{
			if (clip)
			{
				RemoveClipFromDisplay();
				m_clip = clip;
			}
			this.addChild(m_clip);
			/*characterClips[characterName] = clip;
			if (characterName == "Default")
			{
				clip.visible = true;
				this.visible = true;
			}
			else 
			{
				clip.visible = false;
			}
			this.addChild(clip);*/
		}
		public function RemoveClipFromDisplay()
		{
			if (m_clip)
			{
				this.removeChild(m_clip);
				m_clip = null;
			}
		}
		/*public function SwitchDisplayedCharacterClipMotion(characterName:String = "Default")
		{
			var clip:MovieClip;
			for(var key:String in characterClips)
			{
				clip = characterClips[key];
				if (key == characterName && clip != null)
				{
					this.visible = true;
					clip.visible = true;
				}
				else if (key == characterName && clip == null)
				{
					//Fall back to default
					clip = characterClips["Default"];
					if (clip != null)
					{
						clip.visible = true;
					}
				}
				else if(clip != null)
				{
					//Make invisible
					clip.visible = false;
				}
			}
		}
		public function SwitchDisplayedCharacterClip(characterName:String="Default")
		{
			var clip:MovieClip;
			for(var key:String in characterClips)
			{
				clip = characterClips[key];
				if (key == characterName && clip != null)
				{
					this.visible = true;
					clip.visible = true;
				}
				else if (key == characterName && clip == null)
				{
					//Fall back to default
					clip = characterClips["Default"];
					if (clip != null)
					{
						clip.visible = true;
					}
				}
				else if(clip != null)
				{
					//Make invisible
					clip.visible = false;
				}
			}
		}*/
	}
}
