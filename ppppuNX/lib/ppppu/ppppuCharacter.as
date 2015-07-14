package ppppu {
	import flash.geom.ColorTransform;
	import flash.display.MovieClip;
	
	public class ppppuCharacter 
	{
		private var m_CharMC:MovieClip = null; //The movie clip that contains all the animations of the character
		private var m_InDiamondMC:MovieClip = null;
		private var m_OutDiamondMC:MovieClip = null;
		private var m_ColorTransform:ColorTransform = null;
		private var m_BacklightColorTransform:ColorTransform = null;
		private var m_TransitionDiamondMC:MovieClip = null;
		private var m_defOutDiaMC:Boolean = true;
		private var m_defInDiaMC:Boolean = true;
		private var m_defTransDiaMC:Boolean = true;
		private var m_playAnimationFrame:int = 0;
		private var m_randomizePlayAnim:Boolean = true;
		private var m_lockedAnimation:Vector.<Boolean>; //Keeps track if an animation can be switched to.
		private var m_useBacklight:Boolean = true;
		private var m_defaultSkinColor:uint;
		private var m_irisLColor:uint;
		private var m_irisRColor:uint;
		private var m_scleraColor:uint;
		//private var m_scleraLColor:uint;
		//private var m_scleraRColor:uint;
		private var m_wornHeadwear:String; //Indicates which headwear the character is wearing. Unsure if it should be the frame number or the name of the headwear.
		private var m_wornEarring:String; //Indicates which earring the character is wearing. Unsure if it should be the frame number or the name of the earring.
		//private var m_numOfLockedAnimations:int = 0;
		
		public function ppppuCharacter(charMC:MovieClip,characterColorTransform:ColorTransform, outDiamondMC:MovieClip, defOutDiaMC:Boolean, inDiamondMC:MovieClip, defInDiaMC:Boolean, transitionDiamondMC:MovieClip, defTransDiaMC:Boolean, BacklightColorTransform:ColorTransform, useLight:Boolean=true) 
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
		}
		/*Checks if a clip has the needed data to be usable. Needed movie clips are: charMC(the one with 9+ animations)
		and the color transform to be applied to the various diamond movie clips. The actual diamond movie clips are not
		required as the default one (peach/rosalina) will be used and have the color transform applied to it.*/
		public function HasNecessaryData():Boolean
		{
			if(m_CharMC && m_CharMC.totalFrames > 1)
			{
				m_lockedAnimation = new Vector.<Boolean>(GetNumberOfAnimations());
				return true;
			}
			else
			{
				return false;
			}
		}
		public function GetCharacterMC():MovieClip
		{
			return m_CharMC;
		}
		
		public function GetIDiamondMC():MovieClip
		{
			return m_InDiamondMC;
		}
		public function GetColorTransform():ColorTransform
		{
			return m_ColorTransform;
		}
		public function GetODiamondMC():MovieClip
		{
			return m_OutDiamondMC;
		}
		public function GetTransitionDiamondMC():MovieClip
		{
			return m_TransitionDiamondMC;
		}
		public function RandomizePlayAnim()
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
		public function ChangeBackgroundVisibility(showBackground:Boolean, playFrameNum:int)
		{
			if(playFrameNum < 1)
			{
				playFrameNum = 1;
			}
			if(m_InDiamondMC)
			{
				m_InDiamondMC.visible = showBackground;
				if(showBackground)
				{
					m_InDiamondMC.gotoAndPlay(playFrameNum);
				}
				else
				{
					m_InDiamondMC.stop();
				}
			}
			if(m_OutDiamondMC)
			{
				m_OutDiamondMC.visible = showBackground;
				if(showBackground)
				{
					m_OutDiamondMC.gotoAndPlay(playFrameNum);
				}
				else
				{
					m_OutDiamondMC.stop();
				}
			}
			if(m_TransitionDiamondMC)
			{
				m_TransitionDiamondMC.visible = showBackground;
				if(showBackground)
				{
					m_TransitionDiamondMC.gotoAndPlay(playFrameNum);
					
				}
				else
				{
					m_TransitionDiamondMC.stop();
				}
			}
		}
		public function RemoveClipsFromParent(backlightMC:MovieClip)
		{
			if(m_CharMC != null && m_CharMC.parent != null)
			{
				m_CharMC.stop();
				(m_CharMC.getChildAt(0) as MovieClip).stop();
				m_CharMC.parent.removeChild(m_CharMC);
			}
			
			if(m_OutDiamondMC != null && m_OutDiamondMC.parent != null)
			{
				m_OutDiamondMC.stop();
				m_OutDiamondMC.parent.removeChild(m_OutDiamondMC);
			}
			
			if(backlightMC != null && backlightMC.parent != null)
			{
				backlightMC.stop();
				backlightMC.parent.removeChild(backlightMC);
			}
			
			//For the split diamond (transition) graphic
			if(m_TransitionDiamondMC != null && m_TransitionDiamondMC.parent != null)
			{
				m_TransitionDiamondMC.stop();
				m_TransitionDiamondMC.parent.removeChild(m_TransitionDiamondMC);
			}
			
			//For inner diamonds
			if(m_InDiamondMC != null && m_InDiamondMC.parent != null)
			{
				m_InDiamondMC.stop();
				m_InDiamondMC.parent.removeChild(m_InDiamondMC);
			}
		}
		//Used when there is no character or related movie clips on the stage. To be used when switching to a different character
		public function AddCharacterClipsToAnotherMovieClip(parentMC:MovieClip, backlightMC:MovieClip)
		{
			var clipFrameNum:int = ((parentMC.currentFrame - 7) % 120) + 1;
			//Add the inner diamonds pattern first
			if(m_InDiamondMC)
			{
				if(m_defInDiaMC)
				{
					m_InDiamondMC.transform.colorTransform = m_ColorTransform;
				}
				parentMC.addChild(m_InDiamondMC);
				m_InDiamondMC.gotoAndPlay(clipFrameNum);
			}
			//Then add transitional diamond pattern
			if(m_TransitionDiamondMC)
			{
				if(m_defTransDiaMC)
				{
					m_TransitionDiamondMC.transform.colorTransform = m_ColorTransform;
				}
				parentMC.addChild(m_TransitionDiamondMC);
				m_TransitionDiamondMC.gotoAndPlay(clipFrameNum);
			}
			//Add the backlight
			if(backlightMC && m_useBacklight)
			{
				parentMC.addChild(backlightMC);
				backlightMC.gotoAndPlay(clipFrameNum);
				backlightMC.transform.colorTransform = m_BacklightColorTransform;
			}
			//Add the outer diamond pattern
			if(m_OutDiamondMC)
			{
				if(m_defOutDiaMC)
				{
					m_OutDiamondMC.transform.colorTransform = m_ColorTransform;
				}
				parentMC.addChild(m_OutDiamondMC);
				m_OutDiamondMC.gotoAndPlay(clipFrameNum);
			}
			
			//Finally add the character
			if(m_CharMC == null)
			{
				throw new Error("Error: Character Movie clip was found to be null.");
			}
			parentMC.addChild(m_CharMC);
			RandomizePlayAnim();
			PlayingLockedAnimCheck();
			PlayAnimation();
		}
		public function PlayAnimation()
		{
			//select the animation to play
			m_CharMC.gotoAndStop(m_playAnimationFrame);
			//and set this animation's frame number to reflect where it would be if animations weren't changed on a whim
			var animationMC:MovieClip = m_CharMC.getChildAt(0) as MovieClip;
			var parentMC:MovieClip = m_CharMC.parent as MovieClip;
			if(animationMC)
			{
				animationMC.gotoAndPlay(((parentMC.currentFrame - 7) % 120) + 1);
			}

			if(m_OutDiamondMC)
			{
				m_OutDiamondMC.gotoAndPlay(((parentMC.currentFrame - 7) % 120) + 1);
			}
			
			if(m_TransitionDiamondMC)
			{
				m_TransitionDiamondMC.gotoAndPlay(((parentMC.currentFrame - 7) % 120) + 1);
			}
			
			if(m_InDiamondMC)
			{
				m_InDiamondMC.gotoAndPlay(((parentMC.currentFrame - 7) % 120) + 1);
			}
		}
		
		public function SetPlayAnimation(animNumber:int)
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
		
		public function SetRandomizeAnimation(randomStatus:Boolean)
		{
			m_randomizePlayAnim = randomStatus;
		}
		public function GetRandomAnimStatus() : Boolean
		{
			return m_randomizePlayAnim;
		}
		public function ToggleRandomizeAnimation()
		{
			m_randomizePlayAnim = !m_randomizePlayAnim;
		}
		public function GetAnimationLockedStatus(animIndex:int):Boolean
		{
			//have to convert animindex(starts from 1) into an array index (starts at 0)
			return m_lockedAnimation[int(animIndex-1)];
		}
		public function SetAnimationLockedStatus(animIndex:int, lockStatus:Boolean)
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
			for(var i:int = 0, l = m_lockedAnimation.length; i < l; ++i)
			{
				if(m_lockedAnimation[i])
				{
					++lockedAnimNum;
				}
			}
			return lockedAnimNum;
		}
		private function PlayingLockedAnimCheck()
		{
			//Only 1 animation is available, so search for it and use it.
			if(GetAnimationLockedStatus(m_playAnimationFrame-1) && (GetNumberOfAnimations() - GetNumberOfLockedAnimations() == 1))
			{
				var unlockedAnimNum:int = 1;
				for each(var locked in m_lockedAnimation)
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
