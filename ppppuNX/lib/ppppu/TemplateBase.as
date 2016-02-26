package ppppu 
{
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
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
		private var masterTimeline:TimelineLite = new TimelineLite( { useFrames:true, smoothChildTiming:true, paused:true } );
		//Master template version this array contains arrays of timelines. To access the index of the appropriate animation, refer to the animationNameIndexes array in ppppuCore.
		private var defaultTimelines:Vector.<Vector.<TimelineMax>> = new Vector.<Vector.<TimelineMax>>();
		
		//Used for changes in the expression given by the mouth.
		private var expressionTimeline:TimelineMax;
		
		private var customElementsList:Vector.<AnchoredElementBase> = new Vector.<AnchoredElementBase>();
		public var currentAnimationName:String = "None";
		
		//An Object that contains a number of depth layout change Objects for specified frames of the current animation.
		private var currentAnimationElementDepthLayout:Object;
		//The element depth layout for the latest frame based depth change of the animation.
		private var latestFrameDepthLayout:Object;
		private var elementDepthLayoutChangeFrames:Array;
		
		//How far into the current animation we're in
		private var frameCounter:int = 0;
		//The total number of frames in the current animation.
		//TODO: allow this to be set, which is needed for animations with non-standard frames(not 120)
		private var currentAnimationTotalFrames:int = 120;
		
		//The primary movie clip for the flash in terms as asset displaying.
		private var m_ppppuStage:PPPPU_Stage;
		
		private var animationPaused:Boolean = false;
		
		/*public var EyeL:EyeContainer;
		public var EyeR:EyeContainer;*/
		public var EarringL:EarringContainer;
		public var EarringR:EarringContainer;
		public var Headwear:HeadwearContainer;
		public var Mouth:MouthContainer;
		public var LowerLegL:LowerLegContainer;
		public var LowerLegR:LowerLegContainer;
		public var EarL:MovieClip;
		public var EarR:MovieClip;
		public var EyeL:EyeContainer;
		public var EyeR:EyeContainer;
		public var HairFrontLayer:Sprite;
		public var HairBehindHeadwearLayer:Sprite;
		public var HairBehindFaceLayer:Sprite;
		public var HairBackLayer:Sprite;
		
		public var customSkinElements:Vector.<AnchoredElementBase> = new Vector.<AnchoredElementBase>();
		public var customHairElements:Vector.<AnchoredElementBase> = new Vector.<AnchoredElementBase>();
		
		public var currentlyUsedHeadSprite:Sprite;
		
		public var currentAnimationInfo:AnimationInfo = null;
		//public var faceVerticalAngle:Number = 0; //0 is straight forward, angle > 0 is looking up, angle < 0 is looking down.  
		
		//private var debugWindow:Sprite = new Sprite();
		//private var debugBorder:Sprite = new Sprite();
		private var debugTextDisplay:TextField = new TextField();
		private var debugLineDrawer:Sprite = new Sprite();
		private var debug_HairVisible:Boolean = true;
		private var debug_HairBackTest:Boolean = false;
		private var headLastPosition:Point = new Point();
		public function TemplateBase()
		{
			addEventListener(Event.ADDED_TO_STAGE, TemplateAddedToStage);
			SetupEyeContainer(EyeL);
			SetupEyeContainer(EyeR);
			if (EarL) { EarL.Element.gotoAndStop(1); EarL.Element.SkinGradient.gotoAndStop(1); EarL.Element.Lines.gotoAndStop(1); }
			if(EarR) {EarR.Element.gotoAndStop(1); EarR.Element.SkinGradient.gotoAndStop(1); EarR.Element.Lines.gotoAndStop(1);}
			EarringL.Element.gotoAndStop(1);
			EarringR.Element.gotoAndStop(1);
			//Mouth.MouthBase.gotoAndStop(1);
			Mouth.Tongue.Element.gotoAndStop(1);
			Mouth.Tongue.visible = false;
			Headwear.Element.gotoAndStop(1);
			//SetupHair();
			if(LowerLegL) LowerLegL.Element.Color.gotoAndStop(1);
			if (LowerLegR) LowerLegR.Element.Color.gotoAndStop(1);
			
			HairFrontLayer/*.getChildAt(0)*/.visible = false;
			HairBehindHeadwearLayer/*.getChildAt(0)*/.visible = false;
			HairBehindFaceLayer/*.getChildAt(0)*/.visible = false;
			HairBackLayer/*.getChildAt(0)*/.visible = false;
			
			//debug text display setup
			//debugWindow.addChild(debugBorder);
			//debugWindow.addChild(debugTextDisplay);
			debugTextDisplay.x = 0;
			debugTextDisplay.y = 0;
			debugTextDisplay.background = true;
			debugTextDisplay.border = true;
			//debugTextDisplay.autoSize = TextFieldAutoSize.
			debugTextDisplay.selectable = false;
		}
		
		public function AddNewElementToTemplate(element:AnchoredElementBase):void
		{
			if (element)
			{
				//Add the element to the custom elements list. This is for updating purposes.
				customElementsList[customElementsList.length] = element;
				if (element.type == AnchoredElementBase.HAIRELEMENT)
				{
					customHairElements[customHairElements.length] = element;
				}
			}
		}
		
		
		public function Update():void
		{
			if (animationPaused == false) //If animation isn't paused, update
			{
				++frameCounter;
				if (frameCounter >= currentAnimationTotalFrames)
				{
					frameCounter = 0;
				}
				ImmediantLayoutUpdate(frameCounter);
				
				
				UpdateDebugDisplay();
				
				UpdateAnchoredElements();
			}
		}
		
		/*Function that tests if there is a element depth layout change that it to occur on the specified frame and if so, start using
		 * that layout. Should be called every frame.*/
		/*public function Update(animFrame:int):void
		{
			
			ImmediantLayoutUpdate(animFrame);
			
			
			UpdateDebugDisplay();
			
			UpdateAnchoredElements();
		}*/
		
		/*Modifies the elements depth layout to match the latest layout that should be used. For example, if an animation has 3 layout changes
		 * at frame 1, 34 and 90 and there is a switch to this animation on the 89th frame, the layout for the 34th frame will be used. 
		 * This function should be called when the animation is switched*/
		public function ImmediantLayoutUpdate(animFrame:int):void
		{
			//Start at the end and work backwards
			for (var i:int = elementDepthLayoutChangeFrames.length - 1; i >= 0; --i)
			{
				var frame:String = elementDepthLayoutChangeFrames[i];
				//frame = frame.substring(1);
				var depthChangeFrame:int = parseInt(frame, 10);
				if (animFrame >= depthChangeFrame)
				{
					latestFrameDepthLayout = currentAnimationElementDepthLayout[elementDepthLayoutChangeFrames[i]];
					ChangeElementDepths(latestFrameDepthLayout);
					break; //Break out the for loop
				}
			}
			//UpdateAnchoredElements();
		}
		
		public function ChangeElementDepths(depthLayout:Object):void
		{
			var templateChildrenCount:uint = numChildren;
			var templateElements:Vector.<DisplayObject> = new Vector.<DisplayObject>(templateChildrenCount);
			var ShaftMask:DisplayObject = null, Shaft:DisplayObject = null, HeadMask:DisplayObject = null, Head:DisplayObject = null;
			for (var i:uint = 0; i < templateChildrenCount; ++i)
			{
				templateElements[i] = getChildAt(i);
			}
			var sortedDepthElements:Array = new Array();
			for (var childIndex:uint = 0; childIndex < templateChildrenCount; ++childIndex)
			{
				var element:DisplayObject = templateElements[childIndex];
				element.visible = false;
				var elementName:String = element.name;

				if (elementName in depthLayout)
				{	
					sortedDepthElements[depthLayout[elementName]] = element;
					//Mask checking
					
					//Shaft
					if (elementName.indexOf("PenisShaft") != -1 && elementName.indexOf("Mask") != -1)
					{
						ShaftMask = element;
					}
					else if (elementName.indexOf("PenisShaft") != -1)
					{
						Shaft = element;
					}
					
					//Head
					if (elementName.indexOf("PenisHead") != -1 && elementName.indexOf("Mask") != -1)
					{
						HeadMask = element;
					}
					else if (elementName.indexOf("PenisHead") != -1)
					{
						Head = element;
					}
					
					//Head (face) checking
					if (elementName.indexOf("Face") != -1)
					{
						currentlyUsedHeadSprite = element as Sprite;
					}
				}
			}
			
			/*Anchored elements need to be updated now to be up to date on the current animation and if need be, change their anchored
			DisplayObject object.*/
			RefreshAnchorForAnchoredElements();
			
			//With the base list sorted, now custom elements can be added.
			//var sortedCustomHairElements:Vector.<AnchoredElementBase> = customHairElements.sort(Helper_SortCustomElementDepthsFunc);
			
			//Revised version
			for (var customHairIndex:int = 0, customHairLength:int = customHairElements.length; customHairIndex < customHairLength; ++customHairIndex)
			{
				var customElement:AnchoredElementBase = customHairElements[customHairIndex];
				var hairLayerToPutElementOn:int = customElement.GetHairLayerForAnimation(currentAnimationName);
				var hairLayer:Sprite = null;
				//Check if the hair isn't already on the layer it needs to be on.
				if (customElement.GetCurrentLayerId() != hairLayerToPutElementOn)
				{
					if (customElement.parent) { customElement.parent.removeChild(customElement); }
					
					if (hairLayerToPutElementOn == -1) { customElement.SetLayerId( -1); } //Hair isn't on any of the layers
					else if (hairLayerToPutElementOn == HairDefinition.LAYER_FRONT)	{hairLayer = HairFrontLayer; }
					else if (hairLayerToPutElementOn == HairDefinition.LAYER_BEHIND_FACE)	{ hairLayer = HairBehindFaceLayer; }
					else if (hairLayerToPutElementOn == HairDefinition.LAYER_BEHIND_HEADWEAR)	{ hairLayer = HairBehindHeadwearLayer; }
					else if (hairLayerToPutElementOn == HairDefinition.LAYER_BACK)	{ hairLayer = HairBackLayer; }	
					
					if (hairLayer)
					{ 
						var depthPriority:int = customElement.GetCurrentDepthPriority();
						var depth:int = -1;
						for (var hairChildIndex:int = 1, l:int = hairLayer.numChildren; hairChildIndex < l && depth != -1; ++hairChildIndex )
						{
							var comparedElement:AnchoredElementBase = hairLayer.getChildAt(hairChildIndex) as AnchoredElementBase;
							//Compared element has higher priority than the one about to be set, so end of the line
							if (comparedElement && comparedElement.GetCurrentDepthPriority() < depthPriority)
							{
								depth = hairChildIndex;
							}
						}
						//For loop finished without finding something with higher priority. The added object has the current highest priority then and is displayed on top. 
						if (depth == -1)
						{
							depth = hairLayer.numChildren;
						}
						
						hairLayer.addChildAt(customElement, depth ); 
						customElement.SetLayerId(hairLayerToPutElementOn);
					}
				}
			}
			
			var topDepth:int = templateChildrenCount - 1;
			for (var arrayPosition:int = 0, length:int = sortedDepthElements.length; arrayPosition < length; ++arrayPosition )
			{
				if(sortedDepthElements[arrayPosition])
				{
					setChildIndex(sortedDepthElements[arrayPosition], numChildren - 1);
					(sortedDepthElements[arrayPosition] as Sprite).visible = true;
					//trace(arrayPosition + ": " + sortedDepthElements[arrayPosition].name);
				}
			}	
			
			//If a mask-masked pair exists, set the mask. Otherwise, nullify the mask.
			if (Shaft && ShaftMask)
			{
				Shaft.mask = ShaftMask;
			}
			else if (Shaft && !ShaftMask)
			{
				Shaft.mask = null;
			}
			
			if (Head && HeadMask)
			{
				Head.mask = HeadMask;
			}
			else if (Head && !HeadMask)
			{
				Head.mask = null;
			}
			
		}
		
		public function UpdateAnchoredElements():void
		{
			for (var i:int = 0, l:int = customElementsList.length; i < l; ++i )
			{
				if (customElementsList[i].name == "HairBack" && debug_HairBackTest)
				{
					customElementsList[i].Update();	
				}
				else if (customElementsList[i].type == AnchoredElementBase.HAIRELEMENT && (!debug_HairVisible || debug_HairBackTest))
				{
					
				}
				else{customElementsList[i].Update();}
			}
		}
		public function RefreshAnchorForAnchoredElements():void
		{
			for (var i:int = 0, l:int = customElementsList.length; i < l; ++i )
			{
				customElementsList[i].RefreshCurrentAnchor();
			}
		}
		
		/*public function ChangeHair(character:String):void
		{
			HairBack.Element.gotoAndStop(character);
			HairSideL.gotoAndStop(character);
			HairSideR.gotoAndStop(character);
			HairSide2L.gotoAndStop(character);
			HairSide2R.gotoAndStop(character);
			HairSide3L.gotoAndStop(character);
			HairSide3R.gotoAndStop(character);
			if (HairFront)
			{
				HairFront.gotoAndStop(character);
			}
			HairFrontAngled.gotoAndStop(character);
			HairFrontAngled2.gotoAndStop(character);
		}*/
		
		public function ChangeHeadwear(character:String):void
		{
			Headwear.Element.gotoAndStop(character);
		}
		
		public function ChangeEarring(character:String):void
		{
			EarringL.Element.gotoAndStop(character);
			EarringR.Element.gotoAndStop(character);
		}
		
		//Initializes the eye container to go to it's default look (and to stop cycling through the other possible visual it can take.)
		private function SetupEyeContainer(EyeC:EyeContainer):void
		{
			EyeC.Element.EyebrowSettings.gotoAndStop(1);
			EyeC.Element.EyebrowSettings.Eyebrow.gotoAndStop(1);
			EyeC.Element.EyelashSettings.gotoAndStop(1);
			EyeC.Element.EyelashSettings.Eyelash.gotoAndStop(1);
			EyeC.Element.EyeMaskSettings.EyeMask.gotoAndStop(1);
			EyeC.Element.EyelidSettings.gotoAndStop(1);
			EyeC.Element.EyelidSettings.Eyelid.gotoAndStop(1);
			EyeC.Element.EyelashSettings.Eyelash.EyelashTypes.gotoAndStop(1);
			EyeC.Element.InnerEyeSettings.gotoAndStop(1);
			EyeC.Element.InnerEyeSettings.InnerEye.gotoAndStop(1);
			EyeC.Element.InnerEyeSettings.InnerEye.Highlight.gotoAndStop(1);
			EyeC.Element.InnerEyeSettings.InnerEye.Pupil.gotoAndStop(1);
			EyeC.Element.InnerEyeSettings.InnerEye.Iris.gotoAndStop(1);
			EyeC.Element.ScleraSettings.gotoAndStop(1);
			EyeC.Element.ScleraSettings.Sclera.gotoAndStop(1);
		}
		
		/*Sets the vector of timelines passed to it as the default timelines used for a specified animation.
		For reference, ppppuCore's animationNameIndexes variable details which index is linked to a specific animation name*/
		public function SetDefaultTimelines(defTimelines:Vector.<TimelineMax>, animationIndex:uint):void
		{
			//Quick check to make sure that there are timelines in the vector
			if (defTimelines.length > 0)
			{
				for (var i:int = 0, l:int = animationIndex; i < l; ++i)
				{
					if (animationIndex > defaultTimelines.length)
					{
						defaultTimelines.push(null);
					}
				}
				defaultTimelines[animationIndex] = defTimelines;
			}
		}
		
		//Starts playing the currently set animation at a specified frame.
		public function PlayAnimation(startAtFrame:uint):void
		{
			//--startAtFrame;
			if (animationPaused) { animationPaused = false;}
			masterTimeline.play(startAtFrame);
			//Get all timelines currently used
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				//Tell the child timeline to play at the specified time
				(childTimelines[i] as TimelineMax).play(startAtFrame);
			}
			//ImmediantLayoutUpdate(startAtFrame);
		}
		
		public function ResumePlayingAnimation():void
		{
			animationPaused = false;
			masterTimeline.play();
			//Get all timelines currently used
			var childTimelines:Array = masterTimeline.getChildren(!true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				//Tell the child timeline to play at the specified time
				(childTimelines[i] as TimelineMax).play(frameCounter);
			}
		}
		
		public function JumpToFrameAnimation(frame:uint):void
		{
			//--startAtFrame;
			//var time:int = startAtFrame; //useFrames version
			//if (masterTimeline.paused() == false)
			//{
				
			//}
			//else
			//{
				masterTimeline.seek(frame);
				var childTimelines:Array = masterTimeline.getChildren(true, false);
				
				for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
				{
					(childTimelines[i] as TimelineMax).seek(frame);
				}
			//}
		}
		
		/*Pauses the animation. Currently used, it's just here in case there is a time where the animation needs to be paused. 
		Might be useful when character editing facilities are better and they need a still to look at.*/
		public function StopAnimation():void
		{
			animationPaused = true;
			masterTimeline.stop();
			/*var childTimelines:Array = masterTimeline.getChildren(true, false);
			for (var i:int = 0, l:int = childTimelines.length; i < l; ++i)
			{
				(childTimelines[i] as TimelineLite).stop();
			}*/
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
		}
		
		//Adds the timelines contained in a vector to the master timeline.
		public function AddTimelines(timelinesToAdd:Vector.<TimelineMax>):void
		{
			for (var i:uint = 0, l:uint = timelinesToAdd.length; i < l; ++i)
			{
				AddTimeline(timelinesToAdd[i] as TimelineMax);
				/*if (i == 0)
				{
					var tl:TimelineMax = timelinesToAdd[i] as TimelineMax;
					tl.vars["onStart"] = start;
					tl.vars["onComplete"] = complete;
					tl.vars["onRepeat"] = repeat;
					tl.vars["onUpdate"] = update;
				}*/
				//trace(i + ": " + timelinesToAdd[i].data.targetElement.name )
			}
		}
		
		//Adds a specified Timeline to the master timeline.
		public function AddTimeline(tlToAdd:TimelineMax):void
		{
			//If the timeline to add is null, return out the function.
			if (tlToAdd == null) { return; }
			
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
		
		public function SetExpression(exprTimeline:TimelineLite):void
		{
			if (expressionTimeline)
			{
				masterTimeline.remove(expressionTimeline);
			}
			masterTimeline.add(exprTimeline, 0);
			exprTimeline.play(frameCounter, false);
			expressionTimeline = exprTimeline;
		}
		
		public function SetElementDepthLayout(layout:Object):void
		{
			
			elementDepthLayoutChangeFrames  = new Array();
			for(var index:String in layout)
			{
				elementDepthLayoutChangeFrames[elementDepthLayoutChangeFrames.length] = index;
			}
			elementDepthLayoutChangeFrames.sort(Array.NUMERIC);
			currentAnimationElementDepthLayout = layout;
			
		}
		
		public function ChangeMouthExpression(expressionName:String):void
		{
			Mouth.ChangeExpression(expressionName);
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
		
		private function Helper_SortCustomElementDepthsFunc(elementOne:AnchoredElementBase, elementTwo:AnchoredElementBase):int
		{
			var eOneDepth:Number = elementOne.GetCurrentDepthPriority(); 
			var eTwoDepth:Number = elementTwo.GetCurrentDepthPriority();
			
			if (eOneDepth < eTwoDepth){return -1;}
			else if (eOneDepth > eTwoDepth){return 1;}
			else { return 0;}
		}
		
		
		public function ToggleDebugModeText():void
		{
			var debugTextDisplayer:Sprite = this.parent.parent as Sprite;
			if (debugTextDisplayer.contains(debugTextDisplay))
			{
				debugTextDisplayer.removeChild(debugTextDisplay);
				debugTextDisplayer.removeChild(debugLineDrawer);
			}
			else
			{
				var debugTextPoint:Point = new Point(0, 0);
				debugTextPoint = globalToLocal(stage.localToGlobal(debugTextPoint));
				//debugTextDisplay;
				debugTextDisplay.x = debugTextPoint.x;
				debugTextDisplay.y = debugTextPoint.y;
				debugTextDisplayer.addChild(debugTextDisplay);
				debugTextDisplayer.addChild(debugLineDrawer);
			}
		}
		
		public function TemplateAddedToStage(e:Event):void
		{
			var displayObjBeingChecked:DisplayObjectContainer = this;
			while (displayObjBeingChecked != stage && !(displayObjBeingChecked is PPPPU_Stage))
			{
				displayObjBeingChecked = displayObjBeingChecked.parent;
				if (displayObjBeingChecked is PPPPU_Stage)
				{
					m_ppppuStage = displayObjBeingChecked as PPPPU_Stage;
				}
			}
			removeEventListener(Event.ADDED_TO_STAGE, TemplateAddedToStage);
		}
		public function GetPPPPU_Stage():PPPPU_Stage
		{
			return m_ppppuStage;
		}
		
		private function UpdateDebugDisplay():void
		{
			//Calculate the face angles. This requires an animation to have a head and a mouth.
			var animationMouth:Sprite = this.Mouth;
			var animationHead:Sprite = currentlyUsedHeadSprite;
			
			if (animationMouth && animationHead && debugTextDisplay.parent != null)
			{
				var headBounds:Rectangle = animationHead.getBounds(this);
				var headHeight:Number = animationHead.height;
				var hMat:Matrix = animationHead.transform.matrix;
				var headSkewX:Number = Math.atan2( -hMat.c, hMat.d);
				var headSkewY:Number = Math.atan2( hMat.b, hMat.a);
				var headX:Number = animationHead.x;
				var headY:Number = animationHead.y;
				//var headWidth:Number = animationMouth.width;
				
				var mouthHeight:Number = animationMouth.height;
				var mMat:Matrix = animationMouth.transform.matrix;
				var mouthX:Number = animationMouth.x;
				var mouthY:Number = animationMouth.y;
				var mouthSkewX:Number = Math.atan2( -mMat.c, mMat.d);
				var mouthSkewY:Number = Math.atan2( mMat.b, mMat.a);
				
				//debugTextDisplay.text = "Frame #" + ((parent.parent.currentFrame -2) % 120 + 1) + "\n";
				//debugTextDisplay.appendText("Head: \nHeight - " + headHeight + "\nX - " + headX + "\nY - " + headY + "\nSkewX - " + headSkewX + "\nSkewY - " + headSkewY);
				//var txt2:String = "\nMouth: \nHeight - " + mouthHeight + "\nX - " + mouthX + "\nY - " + mouthY + "\nSkewX - " + mouthSkewX + "\nSkewY - " + mouthSkewY;
				//debugTextDisplay.appendText(txt2);
				//var mouthDistanceFromFace:Number = Math.abs(mouthY - headBounds.bottom);
				//var txt3:String = "\nMouth Distance from face:\nValue: " + mouthDistanceFromFace + "\n%: " + 100.0/headHeight * mouthDistanceFromFace;
				//debugTextDisplay.appendText(txt3);
				//Hair back tracking
				/*var hairBack:Sprite = this.HairBackLayer.getChildAt(1);
				if (hairBack)
				{
					var hairPointOnStage:Point = new Point(hairBack.x, hairBack.y);
					hairPointOnStage = globalToLocal(stage.localToGlobal(hairPointOnStage));
					var hairBackText:String = "\nHair back:\nPos: " + hairPointOnStage.x + ", " + hairPointOnStage.y + "\nWidth: " + hairBack.width + "\nHeight: " + hairBack.height;
					debugTextDisplay.appendText(hairBackText);
				}*/
				//Head position and velocity stuff
				var headPosText:String = "\nLast pos: " + headLastPosition.x +", " + headLastPosition.y;
				headPosText += "\nDiff from last: " + RoundToNearest(.001, headX - headLastPosition.x) + ", " + RoundToNearest(.001, headY - headLastPosition.y);
				//debugTextDisplay.appendText(headPosText);
				//var approxFaceAngleTxt:String = "\n\nAngle: ";
				//debugTextDisplay.appendText(approxFaceAngleTxt);
				
				//draw debug lines for mouth and head Y positions
				debugLineDrawer.graphics.clear();
				//Head Y position
				debugLineDrawer.graphics.lineStyle(1, 0xFF0000);
				debugLineDrawer.graphics.moveTo(headX - 75, headY);
				debugLineDrawer.graphics.lineTo(headX + 75, headY);
				//Mouth Y position
				debugLineDrawer.graphics.lineStyle(1, 0x00FF00);
				debugLineDrawer.graphics.moveTo(mouthX - 75, mouthY);
				debugLineDrawer.graphics.lineTo(mouthX + 75, mouthY);
				//Head Bounds
				debugLineDrawer.graphics.lineStyle(1, 0x000000);
				debugLineDrawer.graphics.moveTo(headBounds.left, headBounds.top);
				debugLineDrawer.graphics.lineTo(headBounds.right, headBounds.top);
				debugLineDrawer.graphics.lineTo(headBounds.right, headBounds.bottom);
				debugLineDrawer.graphics.lineTo(headBounds.left, headBounds.bottom);
				debugLineDrawer.graphics.lineTo(headBounds.left, headBounds.top);
				
				if (debugTextDisplay.textHeight > debugTextDisplay.height)
				{
					debugTextDisplay.height = debugTextDisplay.textHeight+5;
				}
				if (debugTextDisplay.textWidth > debugTextDisplay.width)
				{
					debugTextDisplay.width = debugTextDisplay.textWidth+5;
				}
			}
			else
			{
				//faceVerticalAngle = 0; //Assume that the face is straight forward
			}
			headLastPosition.x = animationHead.x;
			headLastPosition.y = animationHead.y;
		}
		public function ToggleHairVisibility():void
		{
			debug_HairVisible = !debug_HairVisible;
			for (var i:int = 0, l:int = customHairElements.length; i < l; ++i)
			{
				customHairElements[i].visible = debug_HairVisible;
			}
		}
		
		public function DEBUG_HairBackTesting():void
		{
			debug_HairBackTest = !debug_HairBackTest;
			for (var i:int = 0, l:int = customHairElements.length; i < l; ++i)
			{
				if (customHairElements[i].name != "HairBack")
				{customHairElements[i].visible = !debug_HairBackTest; }
				else { customHairElements[i].visible = debug_HairBackTest; }	
			}
			//this.Headwear.visible = !debug_HairBackTest;
			this.removeChild(this.Headwear);
		}
		/*public function PutDebugDisplayOnTop():void
		{
			if (this.contains(debugTextDisplay))
			{
				this.setChildIndex(debugTextDisplay, this.numChildren - 1);
			}
		}*/
		function RoundToNearest(roundTo:Number, value:Number):Number{
		return Math.round(value/roundTo)*roundTo;
		}
	}

}