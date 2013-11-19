package app.controller.logic.menu
{
	import app.model.device.DeviceInfo;
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.profiles.pUserProfileManager;
	import app.model.server.pServer;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class MenuLogic extends Mediator
	{
		private var _server:		pServer;
		private var _profile:		pUserProfileManager;	
		
		private var _currentPage:	String = "";
		
		private var ON_LINE:		Boolean;
		
		public function MenuLogic()
		{
			super();
			
			ON_LINE = true;
			
			_server  = this.facade.retrieveProxy(pServer.NAME) as pServer;
			_profile = this.facade.retrieveProxy(pUserProfileManager.NAME) as pUserProfileManager;
		}
		
		public function init():void
		{
			showSelectGameTypePage();
		}
		
		public function setOffLineMode():void
		{
			ON_LINE = false;
			
			if(_currentPage != "")
			{
				// switch menu to offline mode
			}
		}	
			
		//------------------------- show pages --------------
		private function showLoginPage():void
		{
			this.sendNotification(MenuEvents.SHOW_MENU);
			this.sendNotification(MenuEvents.SHOW_LOGIN);
		}
		
		private function showSelectGameTypePage():void
		{
			var _gameData:FullGameData = GameList.Get().getCurrentGameData();
			this.sendNotification(MenuEvents.SHOW_MENU);
						
			showGameTypePage();
			GameList.Get().setCurrentGameData(_gameData);
		}
		
		private function showGameTypePage():void
		{
			this.sendNotification( MenuEvents.SHOW_PAGE_WITH_GAME_TYPE );		
			
			if( !ON_LINE ) this.sendNotification(MenuEvents.SWITCH_TO_OFF_LINE);
			else
			{
				var _timer_e:Timer = new Timer(1000);
				_timer_e.addEventListener(TimerEvent.TIMER, getListGame);
				_timer_e.start();
			}
		}
		
		private function getListGame(e:TimerEvent=null):void
		{
			_server.getActiveGameList();
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				ModelEvents.S_NEW_USER_LOGED_SUCCSESS,
				ModelEvents.S_USER_LOGED_SUCCSESS,
				WindowsEvents.SEND_NAME						
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{				
				case ModelEvents.S_USER_LOGED_SUCCSESS: 
				{
					showSelectGameTypePage(); 
					break;				
				}
			}
		} 
	}
}