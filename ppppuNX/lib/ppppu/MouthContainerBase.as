package ppppu {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class MouthContainerBase extends MovieClip {
		
		public var LipsColor : MovieClip;
		public var LipsHighlight : MovieClip;
		public var MouthBase : MovieClip;
		
		/*TODO Move animationOrders Vector to ppppuAnimation. Its current position will create problems when multiple characters use the same template.
		 * From there, the ppppuAnimation will send the animation order to the mouthContainer*/
		//private var animationOrders:Vector.<MouthAnimationOrder> = new Vector.<MouthAnimationOrder>(120, true);
		public function MouthContainerBase() {
			ChangeMouth("Closed");
			//AddAnimationOrder(1, "Closed");
			// constructor code
			//this.addEventListener(Event.ENTER_FRAME, this.FrameCheck);
		}
		
		public function ChangeMouth(mouthType:String)
		{
			MouthBase.gotoAndStop(mouthType);
			LipsColor.gotoAndStop(MouthBase.currentFrame);
			LipsHighlight.gotoAndStop(MouthBase.currentFrame);
			
		}
		
		/*public function FrameCheck(currentFrameNumber:int)
		{
			var currentOrder:MouthAnimationOrder = animationOrders[currentFrameNumber - 1];
			if (currentOrder != null)
			{
				ChangeMouth(currentOrder);
			}
		}*/
		
		/*public function AddAnimationOrder(frameNumber:int, mouthType:String, scaleX:Number=-1.0, scaleY:Number=-1.0)
		{
			if (frameNumber > 0 && frameNumber <= 120)
			{
				var order:MouthAnimationOrder;
				//if (animationOrders[frameNumber - 1] == null) //Need to create 
				//{
					animationOrders[frameNumber - 1] = new MouthAnimationOrder(mouthType, scaleX, scaleY);
				//}
			}
		}
		
		public function AddAnimationOrders(startFrame:int, endFrame:int, endScaleX:Number=NaN, endScaleY:Number=NaN, mouthType:String=null, startScaleX:Number=NaN, startScaleY:Number=NaN)
		{
			if (endFrame <= startFrame) { endFrame = startFrame + 1; }
			if (endFrame > 120) { endFrame = 120;}
			//Check if there's a preceding order to get an idea of what the mouth looks like
			var latestOrder:MouthAnimationOrder = GetLatestOrder(startFrame);
			if (mouthType == null){mouthType = latestOrder.MouthToUse;} //Don't change the mouth, just use the one used by the latest order
			if (isNaN(endScaleX)){endScaleX = latestOrder.ScaleX;}
			if (isNaN(endScaleY)){endScaleY = latestOrder.ScaleY;}
			if (isNaN(startScaleX)){startScaleX = latestOrder.ScaleX;}
			if (isNaN(startScaleY)){startScaleY = latestOrder.ScaleY;}
			
			var duration = endFrame - startFrame + 1; //ie start = 1, end = 10. 10-1 = 9 but that's not enough, 10 frames should be affected. So add 1.
			var scaleXDifference:Number = (endScaleX - startScaleX) / duration;
			var scaleYDifference:Number = (endScaleY - startScaleY) / duration;
			for (var i:int = 1; i <= duration; ++i)
			{
				AddAnimationOrder(startFrame+i-1, mouthType, startScaleX + scaleXDifference * i, startScaleY + scaleYDifference * i);
			}
		}*/
		/*public function ChangeMouth(order:MouthAnimationOrder)
		{
			this.MouthBase.gotoAndStop(order.MouthToUse);
			this.LipsHighlight.gotoAndStop(this.MouthBase.currentFrame);
			this.LipsColor.gotoAndStop(this.MouthBase.currentFrame);
			if (order.ScaleX < 0)
			{
				this.MouthBase.scaleX = 1;
				this.LipsHighlight.scaleX = 1;
				this.LipsColor.scaleX = 1;
			}
			else
			{
				this.MouthBase.scaleX = order.ScaleX/this.scaleX;
				this.LipsHighlight.scaleX = order.ScaleX/this.scaleX;
				this.LipsColor.scaleX = order.ScaleX/this.scaleX;
			}
			if (order.ScaleY < 0)
			{
				this.MouthBase.scaleY = 1;
				this.LipsHighlight.scaleY = 1;
				this.LipsColor.scaleY = 1;
			}
			else
			{
				this.MouthBase.scaleY = order.ScaleY/this.scaleY;
				this.LipsHighlight.scaleY = order.ScaleY/this.scaleY;
				this.LipsColor.scaleY = order.ScaleY / this.scaleY;
			}
		}
		public function ChangeToLatestOrder(currentFrameNumber:int)
		{
			var order:MouthAnimationOrder = GetLatestOrder(currentFrameNumber);
			if (order != null)
			{
				ChangeMouth(order);
			}
			
		}*/
		/*public function GetLatestOrder(currentFrameNumber:int):MouthAnimationOrder
		{
			//var foundOrder:Boolean = false;
			if (currentFrameNumber > 0 && currentFrameNumber <= 120)
			{
				for (var i:int = currentFrameNumber; i > 0 && !foundOrder; --i)
				{
					if (animationOrders[i-1] != null)
					{
						return animationOrders[i-1];
					}
				}
			}
			return null; //Didn't find it.
		}*/
		/*private function GetMouthFrameByType(type:String)
		{
			this.MouthBase.gotoAndStop(type);
		}*/
		/*public function ChangeMouthByFrame(frameNumber:int)
		{
			//this.
		}
		
		public function ChangeMouthByName(frameName:String)
		{
			
		}*/
	}
	
}
