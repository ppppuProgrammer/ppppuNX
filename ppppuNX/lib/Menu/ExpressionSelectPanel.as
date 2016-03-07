package Menu
{
	import com.bit101.components.*;
	import com.greensock.TimelineMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ppppu.TemplateBase;
	import ppppu.TimelineLibrary;
	import ui.PopupButton;

	//[SWF(backgroundColor=0xeeeeee, width=420, height=300)]
	public class ExpressionSelectPanel extends Component
	{
		private var animSelectList:List;
		private var charSelectList:List;
		private var exprSelectList:List;
		private var animLabel:Label;
		private var charLabel:Label;
		private var exprLabel:Label;
		private var btn_NewExpr:PopupButton;
		private var btn_EditExpr:PopupButton;
		private var btn_DeleteExpr:PushButton;
		private var btn_renameExpr:PopupButton;
		
		private var p_expressionEditorPanel:ExpressionAnimationPanel;
		private var templateInUse:MasterTemplate
		
		
		private var timelineLib:TimelineLibrary;

		public function ExpressionSelectPanel(template:MasterTemplate)
		{
			_width = 420; _height = 300;
			templateInUse = template;
			timelineLib = template.timelineLib;
			
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

			btn_NewExpr = new PopupButton(this, 10, 260, "New Expression"/*, NewExpressionHandler*/);
btn_NewExpr.width = 90;
			
			btn_EditExpr = new PopupButton(this, 110, 260, "Edit Expression"/*, EditExpressionHandler*/);
btn_EditExpr.width = 90;

			btn_DeleteExpr = new PushButton(this, 320, 260, "Delete Expression", DeleteExpressionHandler);
btn_DeleteExpr.width = 90;

			btn_renameExpr = new PopupButton(this, 220, 260, "Rename Expression"/*, RenameExpressionHandler*/);
btn_renameExpr.width = 90;
			
			var expressionNameWindow:ExpressionNamingPanel = new ExpressionNamingPanel();
			btn_NewExpr.bindPopup(expressionNameWindow, "middle", "bottomInner");
			var expressionRenameWindow:ExpressionNamingPanel = new ExpressionNamingPanel();
			btn_renameExpr.bindPopup(expressionRenameWindow, "middle", "bottomInner");
			
			p_expressionEditorPanel = new ExpressionAnimationPanel(templateInUse);
			btn_EditExpr.bindPopup(p_expressionEditorPanel, "middle", "bottomInner");
			btn_EditExpr.addEventListener(MouseEvent.CLICK, EditExpressionHandler);
			
			expressionNameWindow.addEventListener("MenuAccept", NewExpressionHandler);
			expressionRenameWindow.addEventListener("MenuAccept", RenameExpressionHandler);
			
			//Add the select listeners to the char and anim lists
			charSelectList.addEventListener(Event.SELECT, CharOrAnimListSelected);
			animSelectList.addEventListener(Event.SELECT, CharOrAnimListSelected);
			exprSelectList.addEventListener(Event.SELECT, ExprListSelected);
			
			
		}
		
		public function UpdateLists(animationNames:Vector.<String>, characterNames:Vector.<String>):void
		{
			charSelectList.selectedIndex = -1;
			animSelectList.selectedIndex = -1;
			btn_NewExpr.enabled = false;
			PopulateAnimationList(animationNames);
			PopulateCharacterList(characterNames);
			exprSelectList.removeAll(); //Since the character and animation lists have no selection, remove the expression list's items
			btn_renameExpr.enabled = false;
		}
		
		public function UpdateExpressionsList():void
		{
			var expressionTimelines:Vector.<TimelineMax> = timelineLib.GetAllSupplementTimelinesOfTypeFromLibrary(animSelectList.selectedIndex, 
				charSelectList.selectedIndex, timelineLib.TYPE_EXPRESSION);
			
			PopulateExpressionList(expressionTimelines);
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
			exprSelectList.removeAll();
			if (expressions)
			{
				for (var i:int = 0, l:int = expressions.length; i < l;++i)
				{
					if (expressions[i] != null)
					{
						exprSelectList.addItem( { label:expressions[i].data, timeline:expressions[i] } );
					}
				}
			}
			else{btn_renameExpr.enabled = false;}
		}
		
		protected function CharOrAnimListSelected(event:Event):void
		{
			if (charSelectList.selectedIndex == -1 || animSelectList.selectedIndex == -1) {btn_renameExpr.enabled = btn_NewExpr.enabled = false; return; } //Both lists must have an item selected
			btn_NewExpr.enabled = true;
			UpdateExpressionsList();
		}
		
		protected function ExprListSelected(event:Event):void
		{
			if (exprSelectList.selectedItem != null)
			{
				btn_renameExpr.enabled = true;
			}
		}
		
		protected function NewExpressionHandler(event:Event):void
		{
			if (charSelectList.selectedIndex == -1 || animSelectList.selectedIndex == -1) {btn_renameExpr.enabled = btn_NewExpr.enabled = false; return; }
			var name:String = (event.target as ExpressionNamingPanel).GetInputText();
			if (name && name.length > 0)
			{
			var timeline:TimelineMax = new TimelineMax({useFrames:true,paused:true,repeat: -1});
				timelineLib.AddSupplementTimelineToLibrary(animSelectList.selectedIndex, charSelectList.selectedIndex, timelineLib.TYPE_EXPRESSION, name, timeline);
				UpdateExpressionsList();
			}
			//trace("NewExpressionHandler");
		}

		protected function EditExpressionHandler(e:MouseEvent):void
		{
			p_expressionEditorPanel.SetupPanel(exprSelectList.selectedItem.timeline);
			//trace("EditExpressionHandler");
		}

		protected function DeleteExpressionHandler(event:Event):void
		{
			trace("DeleteExpressionHandler");
		}

		protected function RenameExpressionHandler(event:Event):void
		{
			var name:String = (event.target as ExpressionNamingPanel).GetInputText();
			if (exprSelectList.selectedItem != null && name.length > 0) //Make sure something is selected
			{
				
				var vector:Vector.<TimelineMax> = timelineLib.GetAllSupplementTimelinesOfTypeFromLibrary(animSelectList.selectedIndex, 
					charSelectList.selectedIndex, timelineLib.TYPE_EXPRESSION);
				vector[exprSelectList.selectedIndex].data = name;
				exprSelectList.selectedItem.label = name;
				exprSelectList.selectedIndex = exprSelectList.selectedIndex; //Dumb thing to force a redraw asap
			}
			//trace("RenameExpressionHandler");
		}
		
		private function SetupEditor(e:MouseEvent):void
		{
			//templateInUse.StopAnimation();
			//templateInUse.JumpToFrameAnimation(1);
			p_expressionEditorPanel.SetupPanel(exprSelectList.selectedItem.timeline);
		}
	}
}
