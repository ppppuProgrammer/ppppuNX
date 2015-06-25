package ppppu 
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author 
	 */
	public class EyelidContainerBase extends MovieClip implements IPartContainer
	{
		public var eyelid:MovieClip;
		private var eyelidMatrix:Matrix = new Matrix();
		public function EyelidContainerBase() 
		{
			eyelid.gotoAndStop(1);
		}
		public function SaveInitialTransforms()
		{
			eyelidMatrix.copyFrom(eyelid.transform.matrix);
			//eyeTransformMatrix.copyFrom(Eye.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			eyelid.transform.matrix = eyelidMatrix;
		}
		
	}

}