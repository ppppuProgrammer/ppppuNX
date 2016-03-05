package Menu
{
	import com.bit101.components.*;
	import com.greensock.TimelineMax;
	import flash.display.Sprite;
	import flash.events.Event;

	//[SWF(backgroundColor=0xeeeeee, width=420, height=300)]
	public class ExpressionSelectPanel extends Component
	{
		private var animSelectList:List;
		private var charSelectList:List;
		private var exprSelectList:List;
		private var animLabel:Label;
		private var charLabel:Label;
		private var exprLabel:Label;
		private var btn_NewExpr:PushButton;
		private var btn_EditExpr:PushButton;
		private var btn_DeleteExpr:PushButton;
		private var btn_renameExpr:PushButton;

		public function ExpressionSelectPanel()
		{
			_width = 420; _height = 300;
			
			animSelectList = new List(this, 10, 40);
animSelectList.width = 120;
animSelectList.height = 200;

			charSelectList = new List(this, 150, 40);
charSelectList.width = 120;
charSelectList.height = 200;

			exprSelectList = new List(this, 290, 40);
exprSelectList.width = 120;
exprSelectList.height = 200;

			animLabel = new Label(this, 30, 20, "Animation Select");

			charLabel = new Label(this, 170, 20, "Character Select");

			exprLabel = new Label(this, 290, 20, "Expression Animation Select");

			btn_NewExpr = new PushButton(this, 10, 260, "New Expression", NewExpressionHandler);
btn_NewExpr.width = 90;

			btn_EditExpr = new PushButton(this, 110, 260, "Edit Expression", EditExpressionHandler);
btn_EditExpr.width = 90;

			btn_DeleteExpr = new PushButton(this, 320, 260, "Delete Expression", DeleteExpressionHandler);
btn_DeleteExpr.width = 90;

			btn_renameExpr = new PushButton(this, 220, 260, "Rename Expression", RenameExpressionHandler);
btn_renameExpr.width = 90;


			//Add the select listeners to the char and anim lists
			charSelectList.addEventListener(Event.SELECT, CharOrAnimListSelected);
			animSelectList.addEventListener(Event.SELECT, CharOrAnimListSelected);
		}
		
		public function UpdateLists(animationNames:Vector.<String>, characterNames:Vector.<String>):void
		{
			charSelectList.selectedIndex = -1;
			animSelectList.selectedIndex = -1;
			PopulateAnimationList(animationNames);
			PopulateCharacterList(characterNames);
		}
		
		public function PopulateAnimationList(animationNames:Vector.<String>):void
		{
			animSelectList.removeAll(); //Clear the list
			for (var i:int = 0, l:int = animationNames.length; i < l;++i)
			{
				animSelectList.addItem( { label:animationNames[i] } );
			}
		}
		
		public function PopulateCharacterList(characterNames:Vector.<String>):void
		{
			charSelectList.removeAll();
			for (var i:int = 0, l:int = characterNames.length; i < l;++i)
			{
				charSelectList.addItem( { label:characterNames[i] } );
			}
		}
		
		public function PopulateExpressionList(expressions:Vector.<TimelineMax>):void
		{
			
		}
		
		protected function CharOrAnimListSelected(event:Event):void
		{
			if (charSelectList.selectedIndex == -1 && animSelectList.selectedIndex == -1) { return; } //Both lists must have an item selected
			
			
		}
		
		protected function NewExpressionHandler(event:Event):void
		{
			trace("NewExpressionHandler");
		}

		protected function EditExpressionHandler(event:Event):void
		{
			trace("EditExpressionHandler");
		}

		protected function DeleteExpressionHandler(event:Event):void
		{
			trace("DeleteExpressionHandler");
		}

		protected function RenameExpressionHandler(event:Event):void
		{
			trace("RenameExpressionHandler");
		}
	}
}
