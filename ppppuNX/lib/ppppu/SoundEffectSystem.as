package ppppu 
{
	import flash.media.Sound;
	/**
	 * Responsible for handling the playing of sound effects in the program.
	 * @author 
	 */
	public class SoundEffectSystem 
	{
		//Holds sounds that aren't character specific.
		//private var generalSoundBank:Undecided;
		private var masterTemplate:MasterTemplate; //To be able to check the currently playing animation 
		
		//Amount of time in frames that a general sound could be played
		private var generalSoundRate:int = 15;
		//The percent change that a general sound will play
		private var generalSoundPlayChance:int = 100;
		private var generalSoundVolume:int = 100;
		private var currentCharacterSoundBank;
		private var characterSoundPlayChance;
		private var characterSoundRate:int = 0;
		
		public function SoundEffectSystem() 
		{
			
		}
		
		//When called, has the voice system do various checks to play the appropriate sound(s).
		public function Tick(frameOfAnimation:int)
		{
			if (frameOfAnimation % generalSoundRate == 0 && generalSoundPlayChance)
			{
				if ((Math.floor(Math.random() * 100) + 1) <= generalSoundPlayChance)
				{
					
				}
			}
			
			if (frameOfAnimation % characterSoundRate == 0 && characterSoundPlayChance)
			{
				if ((Math.floor(Math.random() * 100) + 1) <= characterSoundPlayChance)
				{
					
				}
			}
		}
		
	}

}