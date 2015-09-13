package ppppu {
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public class ppppuCharacter 
	{
		//private var m_CharMC:MovieClip = null; //The movie clip that contains all the animations of the character
		//private var m_InDiamondMC:MovieClip = null;
		//private var m_OutDiamondMC:MovieClip = null;
		//private var m_ColorTransform:ColorTransform = null;
		//private var m_BacklightColor:uint = null;
		//private var m_TransitionDiamondMC:MovieClip = null;
		//private var m_defOutDiaMC:Boolean = true;
		//private var m_defInDiaMC:Boolean = true;
		//private var m_defTransDiaMC:Boolean = true;
		
		protected var m_name:String;
		protected var m_playAnimationFrame:int = 0;
		protected var m_randomizePlayAnim:Boolean = true;
		protected var m_lockedAnimation:Vector.<Boolean>; //Keeps track if an animation can be switched to.
		//protected var m_useBacklight:Boolean = true;
		protected var m_innerDiamondColor1:uint;
		protected var m_innerDiamondColor2:uint;
		protected var m_innerDiamondColor3:uint;
		protected var m_outerDiamondColor:uint;
		protected var m_backlightColor:uint = UtilityFunctions.GetColorUintFromRGB(255,210,0);
		protected var m_defaultSkinColor:uint;
		protected var m_defaultSkinGradient_Face:Array;//2
		protected var m_defaultSkinGradient_Breasts:Array;//3
		protected var m_defaultSkinGradient_Vulva:Array;//2
		protected var m_defaultSkinGradient_Anus:Array;//2
		protected var m_defaultIrisLColor:uint;
		protected var m_defaultIrisRColor:uint;
		protected var m_defaultScleraColor:uint;
		protected var m_defaultNippleColor:uint;
		protected var m_defaultLipColor:uint;
		//protected var m_hairColor:ColorMatrixFilter;
		protected var m_voiceSet:Vector.<Sound>; //Holds voices specific to a character.
		protected var m_voicePlayRate:int = 15;
		protected var m_voicePlayChance:int = 50;
		protected var m_voiceVolume:int = 100;
		protected var m_voiceCooldown:int = 15;//Time in frames that must pass before a character can play a voice clip
		
		//private var m_scleraLColor:uint;
		//private var m_scleraRColor:uint;
		
		private var m_wornHeadwear:String; //Indicates which headwear the character is wearing. Unsure if it should be the frame number or the name of the headwear.
		private var m_wornEarring:String; //Indicates which earring the character is wearing. Unsure if it should be the frame number or the name of the earring.
		//private var m_numOfLockedAnimations:int = 0;
		
		/*public function ppppuCharacter(charMC:MovieClip,characterColorTransform:ColorTransform, outDiamondMC:MovieClip, defOutDiaMC:Boolean, inDiamondMC:MovieClip, defInDiaMC:Boolean, transitionDiamondMC:MovieClip, defTransDiaMC:Boolean, BacklightColorTransform:ColorTransform, useLight:Boolean=true) 
		{
			m_CharMC = charMC;
			m_InDiamondMC = inDiamondMC;
			m_ColorTransform = characterColorTransform;
			m_OutDiamondMC = outDiamondMC;
			m_TransitionDiamondMC = transitionDiamondMC;
			m_defOutDiaMC = defOutDiaMC;
			m_defInDiaMC = defInDiaMC;
			m_defTransDiaMC = defTransDiaMC;
			m_BacklightColorTransform = BacklightColorTransform;
			m_useBacklight = useLight;
		}*/
		public function GetName():String { return m_name; }
		public function GetDiamondColor1():uint { return m_innerDiamondColor1;}
		public function GetDiamondColor2():uint{ return m_innerDiamondColor2;}
		public function GetDiamondColor3():uint { return m_innerDiamondColor3;}
		public function GetOuterDiamondColor():uint { return m_outerDiamondColor; }
		public function GetBacklightColor():uint { return m_backlightColor;}	
		public function GetSkinColor():uint { return m_defaultSkinColor;}
		public function GetFaceGradients():Array{ return m_defaultSkinGradient_Face;}//2
		public function GetBreastGradients():Array{ return m_defaultSkinGradient_Breasts;}//3
		public function GetVulvaGradients():Array{ return m_defaultSkinGradient_Vulva;}//2
		public function GetAnusGradients():Array{ return m_defaultSkinGradient_Anus;}//2
		public function GetIrisLColor():uint { return m_defaultIrisLColor;}
		public function GetIrisRColor():uint { return m_defaultIrisRColor;}
		public function GetScleraColor():uint { return m_defaultScleraColor;}
		public function GetNippleColor():uint { return m_defaultNippleColor;}
		public function GetLipColor():uint { return m_defaultLipColor; }
		public function GetVoiceSet():Vector.<Sound> { return m_voiceSet; }
		public function GetVoiceCooldown():int { return m_voiceCooldown; }	
		public function GetVoicePlayChance():int { return m_voicePlayChance;}
		public function GetVoicePlayRate(): int { return m_voicePlayRate;}
		
		public function RandomizePlayAnim():void
		{
			//15 frame movie clip has 14 actual animations
			//array[0-13]
			// movieclip frame setting: 2 - 15
			if(m_randomizePlayAnim)
			{
				//generates a number from 0 to (totalFrames - 1)
				var randomAnimIndex:int = Math.floor(Math.random() * GetNumberOfAnimations() + 1);
				if((GetNumberOfAnimations() - GetNumberOfLockedAnimations()) > 2)
				{
					//To clarify this, indexes start from 0 and frames start from 1. So to convert frames->index, subtract 1 from the frame number.
					//To convert index->frame, add 1 to the index number.
					while(randomAnimIndex == m_playAnimationFrame-1 || GetAnimationLockedStatus(randomAnimIndex))
					{
						randomAnimIndex = Math.floor(Math.random() * GetNumberOfAnimations() + 1);
					}
				}
				else
				{
					while(GetAnimationLockedStatus(randomAnimIndex))
					{
						randomAnimIndex = Math.floor(Math.random() * GetNumberOfAnimations() + 1);
					}
				}
				SetPlayAnimation(randomAnimIndex);
			}
		}

		//Used when there is no character or related movie clips on the stage. To be used when switching to a different character
		public function AddCharacterClipsToAnotherMovieClip(parentMC:MovieClip, backlightMC:MovieClip):void
		{
			var clipFrameNum:int = ((parentMC.currentFrame - 7) % 120) + 1;

			parentMC.addChild(m_CharMC);
			RandomizePlayAnim();
			PlayingLockedAnimCheck();
			PlayAnimation();
		}
		
		public function SetPlayAnimation(animNumber:int):void
		{
			if(animNumber < 1)
			{
				animNumber = 1;
			}
			else if(animNumber > GetNumberOfAnimations())
			{
				animNumber = GetNumberOfAnimations();
			}
			m_playAnimationFrame = animNumber + 1;
		}
		
		public function SetRandomizeAnimation(randomStatus:Boolean):void
		{
			m_randomizePlayAnim = randomStatus;
		}
		public function GetRandomAnimStatus() : Boolean
		{
			return m_randomizePlayAnim;
		}
		public function ToggleRandomizeAnimation():void
		{
			m_randomizePlayAnim = !m_randomizePlayAnim;
		}
		public function GetAnimationLockedStatus(animIndex:int):Boolean
		{
			//have to convert animindex(starts from 1) into an array index (starts at 0)
			return m_lockedAnimation[int(animIndex-1)];
		}
		public function SetAnimationLockedStatus(animIndex:int, lockStatus:Boolean):void
		{
			if(animIndex < 1 || animIndex > GetNumberOfAnimations())
			{
				return;
			}
			m_lockedAnimation[int(animIndex-1)] = lockStatus;
		}
		public function GetNumberOfAnimations():int
		{
			return m_CharMC.totalFrames - 1;
		}
		/*public function GetAnimationCurrentFrame():int
		{
			return (m_CharMC.getChildAt(0) as MovieClip).currentFrame;
		}*/
		public function GetNumberOfLockedAnimations():int
		{
			var lockedAnimNum:int = 0;
			for(var i:int = 0, l:int = m_lockedAnimation.length; i < l; ++i)
			{
				if(m_lockedAnimation[i])
				{
					++lockedAnimNum;
				}
			}
			return lockedAnimNum;
		}
		private function PlayingLockedAnimCheck():void
		{
			//Only 1 animation is available, so search for it and use it.
			if(GetAnimationLockedStatus(m_playAnimationFrame-1) && (GetNumberOfAnimations() - GetNumberOfLockedAnimations() == 1))
			{
				var unlockedAnimNum:int = 1;
				for each(var locked:Boolean in m_lockedAnimation)
				{
					if(!locked)
					{
						break;
					}
					++unlockedAnimNum;
				}
				SetPlayAnimation(unlockedAnimNum);
			}
		}
		/*public function GetParentMovieClip():MovieClip
		{
			var parentMC:MovieClip = m_CharMC.parent as MovieClip;
			return parentMC;
		}*/
	}
}
