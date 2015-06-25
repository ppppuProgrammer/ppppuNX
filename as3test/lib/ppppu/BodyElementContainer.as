package ppppu 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	/**
	 * Base class for any body part used in an animation movie clip. Has 2 additional layers, a body addition layer
	 * for markings, tattoos and other such features, and a costume layer (topmost layer).  
	 * @author 
	 */
	public class BodyElementContainer extends MovieClip
	{
		//public var bodyLayer:Sprite = new Sprite();
		//public var costumeLayer:Sprite = new Sprite();
		public function BodyElementContainer() 
		{
			addChild(new Sprite());
			addChild(new Sprite());
		}
		public function ChangeBodyLayer(bodyMC:Sprite)
		{
			removeChildAt(1);
			addChildAt(bodyMC, 1);
		}
		
		public function ChangeCostumeLayer(costumeMC:Sprite)
		{
			costumeMC.visible = true;
			costumeMC.y = -(costumeMC.height / 2);
			removeChildAt(2);
			addChildAt(costumeMC, 2);
			ChangeCostumeVisibility
			//removeChild(costumeLayer);
			//addChild(costumeMC);
		}
		
		public function ChangeCostumeVisibility(visibility:Boolean)
		{
			getChildAt(2).visible = visibility;
		}
	}

}