package app.view.components.windows.game
{
	import app.view.components.windows.BasePages;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ExitPopUp extends BasePages
	{
		private var _model:			mExitPopUp;
		private var _exitPopUpView:	MovieClip;
		
		private var _yesBtn:		SimpleButton;
		private var _noBtn:			SimpleButton;
		
		public function ExitPopUp()
		{
			super();
			
			addLinks();
			addListeners();
			
			_model = new mExitPopUp(this);
		}
		
		private function addLinks():void
		{
			_exitPopUpView = new viewExitPopUp();
			addChild(_exitPopUpView);		
			
			_yesBtn		 = _exitPopUpView.getChildByName("yesBtn") as SimpleButton;
			_noBtn		 = _exitPopUpView.getChildByName("noBtn") as SimpleButton;
		}	
		
		private function addListeners():void
		{
			_yesBtn.addEventListener(MouseEvent.MOUSE_DOWN, yesBtnClick);
			_noBtn.addEventListener(MouseEvent.MOUSE_DOWN, 	noBtnClick);
		}
		
		private function yesBtnClick(e:Event):void
		{
			_yesBtn.removeEventListener(MouseEvent.MOUSE_DOWN, yesBtnClick);	
			_model.gotoMenu();
			_model.closePopUp();
		}
		
		private function noBtnClick(e:Event):void
		{
			_noBtn.removeEventListener(MouseEvent.MOUSE_DOWN, 	noBtnClick);			
			_model.closePopUp();
		}
	}
}