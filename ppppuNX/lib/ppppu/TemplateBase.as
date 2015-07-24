package ppppu 
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	//import EyeContainer;
	//import MouthContainer;
	/**
	 * ...
	 * @author 
	 */
	public dynamic class TemplateBase extends MovieClip
	{
		/*Master timeline for the template animation. Contains all the timelines for parts of the animation that are 
		 * controlled  by series of tweens defined by a motion xml.*/
		public var masterTimeline:TimelineLite = new TimelineLite( { /*useFrames:true,*/ smoothChildTiming:true } );
		//Master template version this array contains arrays of timelines. To access the index of the appropriate animation, refer to the animationNameIndexes array in ppppuCore.
		private var defaultTimelines:Vector.<Vector.<TimelineMax>> = new Vector.<Vector.<TimelineMax>>();
		
		/*public var EyeL:EyeContainer;
		public var EyeR:EyeContainer;*/
		public var EarringL:EarringContainer;
		public var EarringR:EarringContainer;
		public var Headwear:BaseHeadwear;
		public var Mouth:MouthContainer;
		public var HairBack:HairBackContainer;
		public var HairSideL:BaseHairSide;
		public var HairSideR:BaseHairSide;
		public var HairSide2L:BaseHairSide2;
		public var HairSide2R:BaseHairSide2;
		public var HairSide3L:BaseHairSide3;
		public var HairSide3R:BaseHairSide3;
		public var HairFront:BaseHairFront;
		public var LowerLegL:LowerLegContainer;
		public var LowerLegR:LowerLegContainer;
		public var EarL:MovieClip;
		public var EarR:MovieClip;
		
		private var millisecPerFrame:Number;
		/*public var HairFront:BaseHairFront;*/
		
		public function TemplateBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, StageSetup);
			//SetupEyeContainer(EyeL);
			//SetupEyeContainer(EyeR);
			if (EarL) { EarL.Element.gotoAndStop(1); EarL.Element.Skin.gotoAndStop(1); EarL.Element.Lines.gotoAndStop(1); }
			if(EarR) {EarR.Element.gotoAndStop(1); EarR.Element.Skin.gotoAndStop(1); EarR.Element.Lines.gotoAndStop(1);}
			EarringL.Element.gotoAndStop(1);
			EarringR.Element.gotoAndStop(1);
			Mouth.MouthBase.gotoAndStop(1);
			Mouth.LipsColor.gotoAndStop(1);
			Mouth.LipsHighlight.gotoAndStop(1);
			Mouth.Tongue.Element.gotoAndStop(1);
			Mouth.Tongue.visible = false;
			Headwear.gotoAndStop(1);
			SetupHair();
			if(LowerLegL) LowerLegL.Element.Color.gotoAndStop(1);
			if(LowerLegR) LowerLegR.Element.Color.gotoAndStop(1);
		}
		
		//Used to obtain the time spent per frame for the flash.
		private function StageSetup(e:Event):void
		{
			millisecPerFrame = 1000.0 / stage.frameRate;
			removeEventListener(Event.ADDED_TO_STAGE, StageSetup);
		}
		private function SetupHair():void
		{
			HairBack.Element.gotoAndStop(1);
			HairSideL.gotoAndStop(1);
			HairSideR.gotoAndStop(1);
			HairSide2L.gotoAndStop(1);
			HairSide2R.gotoAndStop(1);
			HairSide3L.gotoAndStop(1);
			HairSide3R.gotoAndStop(1);
			if (HairFront)
			{
				HairFront.gotoAndStop(1);
			}
		}
		
		//Initializes the eye container to go to it's default look (and to stop cycling through the other possible visual it can take.)
		/*private function SetupEyeContainer(EyeC:EyeContainer):void
		{
			EyeC.eye.EyebrowSettings.gotoAndStop(1);
			EyeC.eye.EyebrowSettings.Eyebrow.gotoAndStop(1);
			EyeC.eye.EyelashSettings.gotoAndStop(1);
			EyeC.eye.EyelashSettings.Eyelash.gotoAndStop(1);
			EyeC.eye.EyeMaskSettings.EyeMask.gotoAndStop(1);
			EyeC.eye.EyelidSettings.gotoAndStop(1);
			EyeC.eye.EyelidSettings.Eyelid.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Highlight.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Pupil.gotoAndStop(1);
			EyeC.eye.InnerEyeSettings.InnerEye.Iris.gotoAndStop(1);
		}*/
		
		/*Sets the vector of timelines passed to it as the default timelines used for a specified animation.
		For reference, ppppuCore's animationNameIndexes variable details which index is linked to a specific animation name*/
		public function SetDefaultTimelines(defTimelines:Vector.<TimelineMax>, animationIndex:uint):void
		{
			//Quick check to make sure that there are timelines in the vector
			if (defTimelines.length > 0)
			{
				defaultTimelines[animationIndex] = defTimelines;
			}
		}
		
		//Starts playing the currently set animation at a specified frame.
		public function PlayAnimation(startAtFrame:uint):void
		{
			//startAtFrame -= 1;
			//masterTimeline.play(startAtFrame);
			//The timelines and tweens are time based, so there needs to be a conversion from frame to time (in milliseconds)
			masterTimeline.play((startAtFrame * millisecPerFrame) / 1000.0);
			//Get all timelines currently used
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				//Tell the child timeline to play at the specified time
				(childTimelines[i] as TimelineMax).play((startAtFrame * millisecPerFrame)/1000.0 );
			}
		}
		
		public function ResumePlayingAnimation():void
		{
			masterTimeline.play();
			//Get all timelines currently used
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				//Tell the child timeline to play at the specified time
				(childTimelines[i] as TimelineMax).play();
			}
		}
		
		public function JumpToFrameAnimation(startAtFrame:uint):void
		{
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineMax).seek((startAtFrame * millisecPerFrame)/1000.0 );
			}
		}
		
		/*Pauses the animation. Currently used, it's just here in case there is a time where the animation needs to be paused. 
		Might be useful when character editing facilities are better and they need a still to look at.*/
		public function StopAnimation():void
		{
			masterTimeline.stop();
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).stop();
			}
		}
		
		/*Removes all currently active timelines and adds the default timelines for a specified animation by it's index number.*/
		public function ChangeDefaultTimelinesUsed(animationIndex:uint):void
		{
			if (animationIndex < defaultTimelines.length)
			{
				ClearTimelines();
				AddTimelines(defaultTimelines[animationIndex]);
			}
		}
		
		/*public function ResetToDefaultTimelines()
		{
			masterTimeline.clear();
			masterTimeline.add(defaultTimelines);
			//UpdateTimelines();
		}*/
		
		/*Removes all children timelines, which control the various body part elements of the master template, from the master timeline.
		 Additionally, these body part elements are set to be invisible. */
		public function ClearTimelines():void
		{
			//Get the timelines used currently
			var childTimelines:Array = masterTimeline.getChildren(true, false);
			var currentChildTimeline:TimelineMax;
			//Iterate through all the timelines 
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				currentChildTimeline = childTimelines[i] as TimelineMax;
				//The element that the timeline controls is to become invisible.
				//TODO: Test if it is more efficient, performance wise, to remove the element from the master template.
				(currentChildTimeline.data.targetElement as DisplayObject).visible = false;
			}
			//Remove the array of timelines from the master timeline, leaving it clear for another animation.
			masterTimeline.remove(childTimelines);
			//Unused, if remove() calls actually kills timelines (as in, no longer exist in memory), then use clear()
			//masterTimeline.clear();
		}
		
		//Adds the timelines contained in a vector to the master timeline.
		public function AddTimelines(timelinesToAdd:Vector.<TimelineMax>):void
		{
			for (var i:uint = 0, l:uint = timelinesToAdd.length; i < l; ++i)
			{
				AddTimeline(timelinesToAdd[i] as TimelineMax);
				//trace(i + ": " + timelinesToAdd[i].data.targetElement.name )
			}
		}
		
		//Adds a specified Timeline to the master timeline.
		public function AddTimeline(tlToAdd:TimelineMax):void
		{
			//The display object that the timeline controls
			var timelineDisplayObject:DisplayObject = tlToAdd.data.targetElement as DisplayObject;
			//Get the name of the element that the timeline controls
			var timelineForPart:String = timelineDisplayObject.name;
			//Make the display object visible
			timelineDisplayObject.visible = true;
			var currentFrame:int = this.currentFrame;
			
			if (timelineForPart)
			{
				//Check to see if the master timeline already has a nested timeline for the specified display object.
				//If it does, then replace it. Otherwise, add it.
				
				//Get all active timelines
				var childTimelines:Array = masterTimeline.getChildren(true, false);
				var childTlForPart:String;
				var childTimeline:TimelineMax;
				//Iterating through the active timelines array.
				for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
				{
					childTimeline = childTimelines[i] as TimelineMax;
					if (childTimeline)
					{
						childTlForPart = childTimeline.data.targetElement.name as String;
						if (timelineForPart == childTlForPart)
						{
							//Match was found, so replace the match with tlToAdd.
							ReplaceTimeline(childTimeline, tlToAdd);
							return; //Finished, so return to exit out the function early. 
						}
					}
				}
				//Looked through all the timelines nested in the master timeline and there were no matches for tlToAdd to override.
				masterTimeline.add(tlToAdd);
				//tlToAdd.seek(this.currentFrame);
				//tlToAdd.seek(((((this.parent as MovieClip).currentFrame-2) % 120) * millisecPerFrame) / 1000.0);
			}
		}
		
		//Replaces a specified timeline with another and then sets the newly added timeline to the frame that the removed one was on.
		public function ReplaceTimeline(tlToRemove:TimelineMax, tlToAdd:TimelineMax):void
		{
			if (tlToRemove != tlToAdd)
			{
				masterTimeline.remove(tlToRemove);
				masterTimeline.add(tlToAdd);
				//tlToAdd.seek(this.currentFrame);
				//tlToAdd.seek(((((this.parent as MovieClip).currentFrame-2) % 120) * millisecPerFrame) / 1000.0);
			}
		}
		
		//public function GetName():String{return this.name}
		
		/*public function TemplateBase() 
		{
			//EyeL.gotoAndStop(1);
			//EyeR.gotoAndStop(1);
			Mouth.gotoAndStop(1);
		}*/
		
		/*public function OnAnimationRestart()
		{
			EyeL.ResetInitialTransforms();
			EyeR.ResetInitialTransforms();
		}*/
		
	}

}