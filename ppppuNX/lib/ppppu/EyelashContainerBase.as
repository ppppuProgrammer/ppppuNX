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
		public var EyelashTypes:MovieClip;
		public var eyelashMatrix:Matrix = new Matrix();
		public function EyelashContainerBase() 
		{
			//super();
			EyelashTypes.gotoAndStop(1);
			
		}
		
		public function SaveInitialTransforms()
		{
			eyelashMatrix.copyFrom(EyelashTypes.transform.matrix);
			//eyeTransformMatrix.copyFrom(Eye.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			EyelashTypes.transform.matrix = eyelashMatrix;
			//eye.transform.matrix = eyeMatrix;
		}
		
	}

}