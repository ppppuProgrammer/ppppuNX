package ppppu 
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author 
	 */
	public class EyeContainerBase extends MovieClip implements IPartContainer
	{
		public var eye:Eye;
		private var eyeMatrix:Matrix = new Matrix();
		public function EyeContainerBase() 
		{
			
		}
		public function SaveInitialTransforms()
		{
			
			eyeMatrix.copyFrom(eye.transform.matrix);
			eye.SaveInitialTransforms();
		}
		public function ResetInitialTransforms()
		{
			eye.transform.matrix = eyeMatrix;
			eye.ResetInitialTransforms();
		}
		
	}

}