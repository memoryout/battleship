package app.view.components.menu
{
	import app.ApplicationFacade;
	import app.model.events.ModelEvents;
	import app.view.components.menu.pages.login.LoginPage;
	import app.view.components.windows.loader.LoaderWindow;
	import app.view.events.MenuEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mMenu extends Mediator
	{
		private var _rootSprite: Sprite;		
		private var _menuView:	 MenuUi;	
		
		public function mMenu(viewComponent:Object=null)
		{
			_rootSprite = viewComponent as Sprite;		
			
			_menuView = new MenuUi();
			_rootSprite.addChild(_menuView);
			
			super(null);		
		}
		
		public override function listNotificationInterests():Array
		{
			return [ 
						MenuEvents.SHOW_MENU,
						MenuEvents.HIDE_MENU,
						MenuEvents.SHOW_LOGIN,
						MenuEvents.SHOW_PAGE_WITH_GAME_TYPE,
						MenuEvents.SWITCH_TO_OFF_LINE
					];
		}
		
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();		
			
			switch(eventName)
			{	
				case MenuEvents.SHOW_LOGIN:
				{
					showMenuPage("login");
					break;
				}
				
				case MenuEvents.SHOW_PAGE_WITH_GAME_TYPE:
				{
					showMenuPage("game_type");
					break;
				}
					
				case MenuEvents.SHOW_MENU:
				{
//					showMenu();
					break;
				}
					
				case MenuEvents.HIDE_MENU:
				{
					hideCurrentPage();
					break;
				}			
					
				case MenuEvents.SWITCH_TO_OFF_LINE:
				{
					_menuView.switchToOffline();
					break;
				}
			}
		}
		
		private function showMenuPage(pageName:String):void
		{
			_menuView.openPage(pageName);
		}
		
		private function hideCurrentPage():void
		{
			_menuView.closeCurrentPage();
		}
	}	
}