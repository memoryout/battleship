package app.view.components.windows.game
{
	import app.view.components.windows.BasePages;
	import app.view.components.menu.BaseMenuPage;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class FinishPopUp extends BasePages
	{
		private var _model:				mFinishPopUp;
		private var _finishPopUpView:	MovieClip;
		
		private var _winTxtField:	TextField;
		private var _onBtn:			SimpleButton;
		
		public function FinishPopUp()
		{
			super();
			
			addLinks();
			addListeners();
			
			_model = new mFinishPopUp(this);
		}
		
		protected override function onClose():void
		{			
			_model.destroy();			
					
			super.onClose();
		}
		
		private function addLinks():void
		{
			_finishPopUpView = new viewFinishGamePopUp();
			addChild(_finishPopUpView);
			
			_winTxtField = _finishPopUpView.getChildByName("win_txt") as TextField;
			_onBtn		 = _finishPopUpView.getChildByName("ok_btn") as SimpleButton;
		}
		
		public function setWinner(val:Object):void
		{
			_winTxtField.text = val + " win!"
		}
		
		private function addListeners():void
		{
			_onBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnClick);
		}
		
		private function btnClick(e:Event):void
		{
			_onBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnClick);	
			_model.closePopUp();
			_model.gotoMenu();			
		}
	}
}