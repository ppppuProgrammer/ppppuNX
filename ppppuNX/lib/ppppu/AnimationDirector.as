package ppppu 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.greensock.*;
	//import com.greensock.plugins.*;
	//import com.greensock.data.TweenLiteVars;
	//import com.greensock.easing.*;
	/**
	 * ...
	 * @author 
	 */
	public class AnimationDirector 
	{
		public var templateAnimation:TemplateBase; //The base animation to work off of
		//public var templateAnimation:MovieClip; //The base animation to work off of
		public var flippedAnimation:Boolean = false;
		
		//public var firstFrameTweenOrders:Vector.<TweenOrder> = new Vector.<TweenOrder>();
		public var firstFrameObjectSettings:Vector.<TweenOrder> = new Vector.<TweenOrder>();
		public var animationTweens:Vector.<TweenOrder> = new Vector.<TweenOrder>();
		private var lastFrameApplied:int = -1;
		
		//private var animationMasterTimeline:TimelineMax = new TimelineMax({useFrames:true});
		
		public function AnimationDirector(baseAnimation:DisplayObject /*baseAnimation:TemplateBase*/) 
		{
			templateAnimation = baseAnimation as TemplateBase;
		}
		
		public function AddAnimationModification(target:Object, properties:Object, frameToStart:int, framesToTween:int)
		{
			//Lazy implementation
			animationTweens[animationTweens.length] = new TweenOrder(target, properties, frameToStart, framesToTween);
		}
		
		public function AddFirstFrameModification(modifyTarget:Object, properties:Object)
		{
			firstFrameObjectSettings[firstFrameObjectSettings.length] = new TweenOrder(modifyTarget, properties, 1,0);
		}
		
		public function ApplyFirstFrameModifications()
		{
			if (lastFrameApplied != 1)
			{
				var order:TweenOrder;
				for (var i:int = 0, l:int = firstFrameObjectSettings.length; i < l; ++i )
				{
					order = firstFrameObjectSettings[i];
					if (order)
					{
						TweenLite.set(order.TargetObject, order.TweenVars);
					}
				}
				lastFrameApplied = 1;
			}
		}
		
		public function ApplyModificationsForFrame(/*frame:int*/)
		{
			var currFrame:int = this.templateAnimation.currentFrame;
			if (lastFrameApplied != currFrame)
			{
				for (var i:int = 0, l:int = animationTweens.length; i < l; ++i)
				{
					var order:TweenOrder = animationTweens[i];
					if (order)
					{
						if (order.StartFrame == currFrame)
						{
							TweenLite.to(order.TargetObject, order.DurationFrames, order.TweenVars);
						}
					}
				}
				lastFrameApplied = currFrame;
			}
		}
		
		public function AddAnimationToDisplay(parentClip:Sprite)
		{
			//Check if already on parent
			if (templateAnimation.parent) 
			{ 
				//RemoveMotionClipsFromTemplateAnimation();
				
				//this.RemoveAnimationFromDisplay(); 
			}
			//AddMotionClipsToTemplateAnimation();
			parentClip.addChild(this.templateAnimation);
			if (flippedAnimation)
			{
				templateAnimation.scaleX = -1;
				templateAnimation.x = 480;
			}
			else
			{
				templateAnimation.scaleX = 1;
				templateAnimation.x = 0;
			}
		}
		public function RemoveAnimationFromDisplay()
		{
			if (templateAnimation.parent)
			{
				templateAnimation.parent.removeChild(templateAnimation);
				//RemoveMotionClipsFromTemplateAnimation();
			}
		}
		public function AddMotionXmlOrders(motionOrders:Vector.<TweenOrder>)
		{
			firstFrameObjectSettings[firstFrameObjectSettings.length] = motionOrders[0];
			for (var i:int = 1, l:int = motionOrders.length; i < l; ++i)
			{
				animationTweens[animationTweens.length] = motionOrders[i];
			}
		}
		public function RemoveMotionXmlOrders(targetPart:DisplayObject)
		{
			for (var i:int = 0, l:int = firstFrameObjectSettings.length; i < l; ++i)
			{
				if (firstFrameObjectSettings[i].TargetObject == targetPart)
				{
					firstFrameObjectSettings[i] = null;
				}
			}
			for (var ii:int = 0, ll:int = animationTweens.length; ii < ll; ++ii)
			{
				if (animationTweens[ii].TargetObject == targetPart)
				{
					animationTweens[ii] = null;
				}
			}
		}
	}

}