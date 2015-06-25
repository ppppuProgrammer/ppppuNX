package ppppu 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author 
	 */
	public class InnerEyeContainerBase extends MovieClip implements IPartContainer
	{
		public var pupil:MovieClip;
		public var iris:MovieClip;
		public var highlight:MovieClip;
		private var pupilTransformMatrix:Matrix = new Matrix();
		private var irisTransformMatrix:Matrix = new Matrix();
		private var highlightTransformMatrix:Matrix = new Matrix();
		public function InnerEyeContainerBase() 
		{
			pupil.addEventListener(Event.ENTER_FRAME, OnPupilChange);
			pupil.gotoAndStop(1);
			//Iris.gotoAndStop(1);
			//Highlight.gotoAndStop(1);
			
		}
		private function OnPupilChange(e:Event)
		{
			var pupilFrame:int = pupil.currentFrame;
			iris.gotoAndStop(pupilFrame);
			highlight.gotoAndStop(pupilFrame);
		}
		
		//Used to essentially move the inner eye container without moving the actual instance of the container.
		//This prevents the container for being "detached" for the ide timeline 
		public function MoveChildren(x:Number, y:Number)
		{
			pupil.x = x;
			pupil.y = y;
			iris.x = x;
			iris.y = y;
			highlight.x = x;
			highlight.y = y;
		}
		public function SaveInitialTransforms()
		{
			pupilTransformMatrix.copyFrom(pupil.transform.matrix);
			irisTransformMatrix.copyFrom(iris.transform.matrix);
			highlightTransformMatrix.copyFrom(highlight.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			pupil.transform.matrix = pupilTransformMatrix;
			iris.transform.matrix = irisTransformMatrix;
			highlight.transform.matrix = highlightTransformMatrix;
		}
	}

}