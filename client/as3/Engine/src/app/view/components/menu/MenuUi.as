package app.view.components.menu
{
	import app.view.components.menu.pages.game_type.GameTypePageUi;		
	import app.view.components.menu.pages.login.LoginPage;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class MenuUi extends Sprite
	{
		private var _currentPage:			BaseMenuPage;
		
		private var _registeredPages:		Dictionary;
		
		public function MenuUi()
		{
			_registeredPages = new Dictionary();
			
			_registeredPages["login"] 		= LoginPage;			
			_registeredPages["game_type"] 	= GameTypePageUi;				
		}
		
		public function openPage(pageName:String):void
		{
			if(_currentPage)
			{
				if(_currentPage.pageName == pageName) 
				{
					_currentPage.reOpen();
					return;
				}
				
				_currentPage.close();
				_currentPage = null;
			}
			
			if(_registeredPages[pageName])
			{
				_currentPage = new _registeredPages[pageName]();
				_currentPage.name = pageName;
				_currentPage.open();
				
				this.addChild(_currentPage);	
			}
		}
		
		public function closePage(pageName:String):void
		{
			if(_currentPage && _currentPage.pageName == pageName) 
			{
				_currentPage.close();
				_currentPage = null;
			}
		}
		
		public function closeCurrentPage():void
		{
			if(_currentPage) 
			{
				_currentPage.close();
				_currentPage = null;
			}
		}
		
		
		public function switchToOffline():void
		{
			if(_currentPage) _currentPage.switchToOffline();
		}
	}
}