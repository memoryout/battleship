package app.view.components.menu.pages.login
{
	import app.view.components.menu.BaseMenuPage;
	import app.view.events.WindowsEvents;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	
	public class LoginPage extends BaseMenuPage
	{
		private var _model:			mLoginPage;
		private var _loginView:		MovieClip;
		
		private var _nameTxtField:	TextField;
		private var _onBtn:			SimpleButton;
		private var _nameStr:		String;
		private var _userName:		String;
		
		private const DEFAULT_TEXT:			String = "Set your name";
		
		public function LoginPage()
		{
			super();
			
			addLinks();
			addListeners();
			
			_model = new mLoginPage(this);
		}
		
		public function getUserName():String
		{
			return _userName;
		}
		
		protected override function onClose():void
		{
			_model.destroy();
			
			_loginView = null;
			_model = null;
			_nameTxtField = null;
			_onBtn = null;
			
			super.onClose();
		}
	
		private function addLinks():void
		{
			_loginView = new viewLoginPage();
			addChild(_loginView);
			
			_nameTxtField = _loginView.getChildByName("nameTxt") as TextField;
			_onBtn		  = _loginView.getChildByName("ok_btn") as SimpleButton;
			
			_nameTxtField.text = DEFAULT_TEXT;
		}
		
		private function addListeners():void
		{
			_onBtn.addEventListener(MouseEvent.MOUSE_DOWN, btnClick);
			
			_nameTxtField.addEventListener(FocusEvent.FOCUS_IN, handlerFocusIn);
		}
		
		private function handlerFocusIn(e:FocusEvent):void
		{
			if( _nameTxtField.text == DEFAULT_TEXT ) _nameTxtField.text = "";
		}
		
		private function btnClick(e:Event):void
		{
			_onBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnClick);
			_nameTxtField.removeEventListener(FocusEvent.FOCUS_IN, handlerFocusIn);
			
			_userName = _nameTxtField.text;
			_model.setName(_userName)
		}
	}
}