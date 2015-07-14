package ppppu 
{
	import com.greensock.data.TweenLiteVars;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import com.greensock.*;
	/**
	 * ...
	 * @author 
	 */
	public class EyeBase extends MovieClip implements IPartContainer
	{
		//var initialChildrenMatrices:Dictionary = new Dictionary();
		public var InnerEyeSettings:MovieClip;
		public var EyeMaskSettings:MovieClip;
		public var EyelidSettings:MovieClip;
		public var EyelashSettings:MovieClip;
		public var ScleraSettings:MovieClip;
		//InnerEye;
		public var eyeMaskMatrix:Matrix = new Matrix();
		//Eyelid;
		//public var eyelashMatrix:Matrix = new Matrix();
		//public var scleraMatrix:Matrix = new Matrix();;
		public function EyeBase() 
		{
			gotoAndStop(1);
			
			/*for (var i:int = 0, l:int = this.numChildren; i < l; ++i)
			{
				var currentChild:DisplayObject = this.getChildAt(i);
				if (currentChild.name.indexOf("instance") <= -1)
				{
					var currentChildMatrix:Matrix = new Matrix();
					currentChildMatrix.copyFrom(currentChild.transform.matrix);
					initialChildrenMatrices[currentChild.name] = currentChildMatrix;
					if (currentChild.name == "Eyelid")
					{
						//For some reason the eyelid movie clip does not like being modified despite having properties similar to the other child
						//movie clips which can have modifications like scale applied without "detaching" it from the animation's time line.
						//To get around this, modify the child of the Eyelid movieclip
						currentChildMatrix.copyFrom(Eyelid.EyelidType.transform.matrix);
						initialChildrenMatrices[currentChild.name] = currentChildMatrix;
					}
				}
			}*/
		}
		
		public function SaveInitialTransforms()
		{
			InnerEyeSettings.SaveInitialTransforms();
			//eyeMaskMatrix.copyFrom(eyeMask.transform.matrix);
			EyelidSettings.SaveInitialTransforms();
			EyelashSettings.SaveInitialTransforms();
			//scleraContainer.SaveInitialTransforms();
			//eyeTransformMatrix.copyFrom(Eye.transform.matrix);
		}
		public function ResetInitialTransforms()
		{
			//eyeMask.transform.matrix = eyeMaskMatrix;
			InnerEyeSettings.ResetInitialTransforms();
			EyelidSettings.ResetInitialTransforms();
			EyelashSettings.ResetInitialTransforms();
			//scleraContainer.ResetInitialTransforms();
			//eye.transform.matrix = eyeMatrix;
		}
		
		//public function ResetChildrenPositions()
		//{
			/*for (var i:int = 0, l:int = this.numChildren; i < l; ++i)
			{
				var currentChild:DisplayObject = this.getChildAt(i);
				if (currentChild != null)
				{
					var initialMatrix:Matrix = initialChildrenMatrices[currentChild.name] as Matrix;
					if (initialMatrix != null)
					{
						if (currentChild.name == "Eyelid")
						{
							TweenLite.set(Eyelid.EyelidType, new TweenLiteVars().transformMatrix(initialMatrix));
						}
						else
						//TweenLite.set(currentChild, {x:initialMatrix.tx, y:initialMatrix.ty } );
						TweenLite.set(currentChild, new TweenLiteVars().transformMatrix(initialMatrix) );
						//currentChild.transform.matrix.copyFrom(initialMatrix);
					}
				}
				//currentChildMatrix.copyFrom(currentChild.transform.matrix);
				//initialChildrenMatrices[currentChild.name] = currentChildMatrix;
			}*/
		//}
	}

}