package app.view.components.windows
{
	import app.ApplicationFacade;	
	import app.view.components.windows.game.ExitPopUp;
	import app.view.components.windows.game.FinishPopUp;
	import app.view.components.windows.game.WaitForOponentPopUp;
	
	import app.view.components.windows.loader.LoaderWindow;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mWindows extends Mediator
	{
		private var _view:				WindowsView;
		
		private var _registeredWindows:	Dictionary;
		
		private var _openedWindows:		Dictionary;
		
		private var _currentPage:		BasePages;
		
		public function mWindows(viewComponent:Object=null)
		{
			var spr:Sprite = viewComponent as Sprite;
			
			_view = new WindowsView();
			spr.addChild( _view );
			
			registerWindows();
			
			super(null);
		}
		
		public function openWindow(pageName:String):void
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
			
			if(_registeredWindows[pageName])
			{
				_currentPage = new _registeredWindows[pageName]();
				_currentPage.name = pageName;
				_currentPage.open();
				
				_view.addChild(_currentPage);	
			}
		}
		
		public function closeWindow(pageName:String):void
		{
			if(_currentPage && _currentPage.name == pageName) 
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
		
		public override function listNotificationInterests():Array
		{
			return [
						WindowsEvents.OPEN_WINDOW,
						WindowsEvents.CLOSE_WINDOW,
						MenuEvents.SHOW_MENU,
						WindowsEvents.GET_CURRENT_OPEN_WINDOW_NAME
						//MenuEvents.HIDE_LOGIN
					]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{	
				case ApplicationFacade.CMD_STARTUP:
				{
					//showLoaderWindow();
				}
					break;
				
				/*case MenuEvents.HIDE_LOGIN:
				{
					hideLoaderWindow();
				}
					break;*/
				
				case WindowsEvents.CLOSE_WINDOW:
				{
					closeWindow( notification.getBody() as String ); 
				}
					break;	
				
				case WindowsEvents.OPEN_WINDOW:
				{
					openWindow( notification.getBody() as String ); 
				}
					break;	
				
				case WindowsEvents.GET_CURRENT_OPEN_WINDOW_NAME:
				{
					if(_currentPage) {
						this.sendNotification(WindowsEvents.CURRENT_OPEN_WINDOW_NAME, _currentPage.name);
					}
				}
					break;		
			}
		}		
		
		private function registerWindows():void
		{
			_registeredWindows = new Dictionary();
			
//			_registeredWindows["game_debug"] 	= WindowDebugPopUp;
			
			_registeredWindows["game_finish"] 	= FinishPopUp;		
			_registeredWindows["game_exit"] 	= ExitPopUp;
			_registeredWindows["game_wait"] 	= WaitForOponentPopUp;
			
			
		}		
	}
}