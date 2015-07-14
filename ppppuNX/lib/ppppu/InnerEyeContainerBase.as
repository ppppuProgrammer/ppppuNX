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
		public var Pupil:MovieClip;
		public var Iris:MovieClip;
		public var Highlight:MovieClip;
		private var pupilTransformMatrix:Matrix = new Matrix();
		private var irisTransformMatrix:Matrix = new Matrix();
		private var highlightTransformMatrix:Matrix = new Matrix();
		public function InnerEyeContainerBase() 
		{
			Pupil.addEventListener(Event.ENTER_FRAME, OnPupilChange);
			Pupil.gotoAndStop(1);
			//Iris.gotoAndStop(1);
			//Highlight.gotoAndStop(1);
			
		}
		private function OnPupilChange(e:Event)
		{
			var pupilFrame:int = Pupil.currentFrame;
			Iris.gotoAndStop(pupilFrame);
			Highlight.gotoAndStop(pupilFrame);
		}
		
		//Used to essentially move the inner eye container without moving the actual instance of the container.
		//This prevents the container for being "detached" for the ide timeline 
		public function MoveChildren(x:Number, y:Number)
		{
			Pupil.x = x;
			Pupil.y = y;
			Iris.x = x;
			Iris.y = y;
			Highlight.x = x;
			Highlight.y = y;
		}
		public function SaveInitialTransforms()
		{
			pupilTransformMatrix.copyFrom(Pupil.transform.matrix);
			irisTransformMatrix.copyFrom(Iris.transform.matrix);
			highlightTransformMatrix.copyFrom(Highlight.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			Pupil.transform.matrix = pupilTransformMatrix;
			Iris.transform.matrix = irisTransformMatrix;
			Highlight.transform.matrix = highlightTransformMatrix;
		}
	}

}