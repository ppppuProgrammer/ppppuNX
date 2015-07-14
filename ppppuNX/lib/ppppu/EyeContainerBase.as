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
		//public var eye:Eye;
		private var eyeMatrix:Matrix = new Matrix();
		public function EyeContainerBase() 
		{
			/*eye.EyebrowSettings.gotoAndStop(1);
			eye.EyebrowSettings.Eyebrow.gotoAndStop(1);
			eye.EyelashSettings.gotoAndStop(1);
			eye.EyelashSettings.Eyelash.gotoAndStop(1);
			eye.EyeMaskSettings.EyeMask.gotoAndStop(1);
			eye.EyelidSettings.gotoAndStop(1);
			eye.EyelidSettings.Eyelid.gotoAndStop(1);
			eye.InnerEyeSettings.InnerEye.Highlight.gotoAndStop(1);
			eye.InnerEyeSettings.InnerEye.Pupil.gotoAndStop(1);
			eye.InnerEyeSettings.InnerEye.Iris.gotoAndStop(1);*/
		}
		public function SaveInitialTransforms()
		{
			
			//eyeMatrix.copyFrom(eye.transform.matrix);
			//eye.SaveInitialTransforms();
		}
		public function ResetInitialTransforms()
		{
			//eye.transform.matrix = eyeMatrix;
			//eye.ResetInitialTransforms();
		}
		
	}

}