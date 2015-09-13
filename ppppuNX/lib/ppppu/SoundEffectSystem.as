package ppppu 
{
	import flash.events.DRMReturnVoucherCompleteEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * Responsible for handling the playing of sound effects in the program.
	 * @author 
	 */
	public class SoundEffectSystem 
	{
		//Holds sounds that aren't character specific.
		private var generalSoundBank:Vector.<Sound>;
		private var masterTemplate:MasterTemplate; //To be able to check the currently playing animation 
		
		private var startSoundPlayFrame:int = 12;
		//Amount of time in frames that a general sound could be played
		private var generalSoundRate:int = 15;
		//The percent change that a general sound will play
		private var generalSoundPlayChance:int = 100;
		private var generalSoundVolume:int = 100;
		private var currentCharacterVoiceSet:Vector.<Sound>;
		private var currentCharacterSoundPlayChance:int = 40;
		private var currentCharacterSoundRate:int = 15;
		private var currentCharacterCooldown:int = 15;
		
		//Anti annoyance variables for character voices
		private var voiceCooldown:int = 0; //Amount of frames until the character can have a sound of theirs play.
		private var dontRepeatVoiceClips:Vector.<int>; //Keeps track of the most recently played voices and prevents them from playing for a while.
		private const trackRepeatPercent:Number = 0.40; //The percentage of a characters voice set to keep track of for repeats
		private var antiRepeatInsertIndex:int = 0; //Keeps track of what index to use for the dontRepeatVoiceClips vector
		
		private var generalSoundChannel:SoundChannel = new SoundChannel();
		private var characterSoundChannel:SoundChannel = new SoundChannel();
		
		public function SoundEffectSystem() 
		{
			generalSoundBank = new <Sound>[new sfxDown1, new sfxDown2, new sfxDown3, new sfxDown4, new sfxDown5, new sfxDown6, 
			new sfxDown7, new sfxDown8, new sfxDown9, new sfxDown10, new sfxDown11, new sfxDown12, new sfxDown13];
		}
		
		//When called, has the voice system do various checks to play the appropriate sound(s).
		public function Tick(frameOfAnimation:int):void
		{
			if (voiceCooldown > 0)
			{
				--voiceCooldown;
			}
			var modifiedFrameNumber:int= (frameOfAnimation - startSoundPlayFrame)
			if (modifiedFrameNumber % generalSoundRate == 0 && generalSoundPlayChance)
			{
				if ((Math.floor(Math.random() * 100) + 1) <= generalSoundPlayChance)
				{
					generalSoundChannel.stop();
					generalSoundChannel = generalSoundBank[Math.floor(Math.random() * generalSoundBank.length)].play();
				}
			}
			
			if (modifiedFrameNumber % currentCharacterSoundRate == 0 && currentCharacterSoundPlayChance)
			{
				if ((Math.floor(Math.random() * 100) + 1) <= currentCharacterSoundPlayChance)
				{
					characterSoundChannel.stop();
					if (currentCharacterVoiceSet && voiceCooldown == 0)
					{
						var soundIndex:int= Math.floor(Math.random() * currentCharacterVoiceSet.length);
						while (dontRepeatVoiceClips.indexOf(soundIndex) != -1)
						{
							soundIndex = Math.floor(Math.random() * currentCharacterVoiceSet.length);
						}
						
						characterSoundChannel = currentCharacterVoiceSet[soundIndex].play();
						voiceCooldown = currentCharacterCooldown;
						dontRepeatVoiceClips[antiRepeatInsertIndex] = soundIndex;
						++antiRepeatInsertIndex;
						if (antiRepeatInsertIndex >= dontRepeatVoiceClips.length)
						{
							antiRepeatInsertIndex = 0;
						}
					}
				}
			}
		}
		
		public function ChangeCharacterVoiceSet(voiceSet:Vector.<Sound>):void
		{
			if (voiceSet)
			{
				currentCharacterVoiceSet = voiceSet;
				voiceCooldown = 0;
				dontRepeatVoiceClips = new Vector.<int>(voiceSet.length * .33, true);
			}
			else
			{
				currentCharacterVoiceSet = null;
			}
		}
		
		public function ChangeCharacterVoiceChance(chance:int):void
		{
			currentCharacterSoundPlayChance = chance;
		}
		
		public function ChangeCharacterVoiceRate(rate:int):void
		{
				currentCharacterSoundRate = rate;
		}
		
		public function ChangeCharacterVoiceCooldown(cooldown:int):void
		{
			currentCharacterCooldown = cooldown;
			voiceCooldown = 0;
		}
	}

}