package ppppu 
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author 
	 */
	public class EyelashContainerBase extends MovieClip implements IPartContainer
	{
		public var eyelash:MovieClip;
		public var eyelashMatrix:Matrix = new Matrix();
		public function EyelashContainerBase() 
		{
			//super();
			eyelash.gotoAndStop(1);
			
		}
		
		public function SaveInitialTransforms()
		{
			eyelashMatrix.copyFrom(eyelash.transform.matrix);
			//eyeTransformMatrix.copyFrom(Eye.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			eyelash.transform.matrix = eyelashMatrix;
			//eye.transform.matrix = eyeMatrix;
		}
		
	}

}