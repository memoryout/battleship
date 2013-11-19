package app.controller.logic
{
	import app.GlobalSettings;
	import app.controller.events.AppEvents;
	import app.controller.logic.game.ComputerLogic;
	import app.controller.logic.game.GameLogic;
	import app.controller.logic.menu.MenuLogic;
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.save.pSavedGame;
	import app.model.server.pServer;
	import app.view.events.MenuEvents;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class AppLogic extends Mediator
	{
		
		private var _serverProxy:			pServer;
		private var _gameLogic:				GameLogic;
		private var _menuLogic:				MenuLogic;
		
		private var _savedGame:				pSavedGame;
		
		public function AppLogic(viewComponent:Object=null)
		{
			super(null);
		}
		
		public override function listNotificationInterests():Array
		{
			return [
						AppEvents.START_UP_COMPLETE,
						MenuEvents.VIEW_READY
					]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{
				case AppEvents.START_UP_COMPLETE:
				{
					createGameComponents();
					initApplication();
					break;
				}
					
				case MenuEvents.VIEW_READY:
				{
					startup();
					break;
				}
			}
		}
		
		private function startup():void
		{
			var stm:StartupManager = new StartupManager()
			this.facade.registerMediator( stm );
			
			stm.startup();
		}
		
		private function createGameComponents():void
		{
			_menuLogic = new MenuLogic();
			this.facade.registerMediator( _menuLogic );
			//menu.init();
			
			_gameLogic = new GameLogic();
			this.facade.registerMediator( _gameLogic );
			
			var computer:ComputerLogic = new ComputerLogic();
			this.facade.registerMediator( computer );		
		}
		
		private function initApplication():void
		{
			_serverProxy = this.facade.retrieveProxy(pServer.NAME) as pServer;
			_savedGame 	 = this.facade.retrieveProxy(pSavedGame.NAME) as pSavedGame;
			
			loadSaveData();
			
//			FileSystem.get().open( GlobalSettings.PATH + GlobalSettings.SAVED_GAMES_FILE, onOpenSavedGameData, onErrorOpenSavedData);			
		}	
		
		private function loadSaveData():void
		{
			_savedGame.addEventListener(pSavedGame.COMPLETE, onLoadSaveFile );
			_savedGame.addEventListener(pSavedGame.ERROR_LOAD, onErrorLoadSaveFile );
			_savedGame.addEventListener(pSavedGame.ERROR_PARSING, onErrorPasingSaveFile );
			
			_savedGame.loadConfig( GlobalSettings.PATH + GlobalSettings.SAVED_GAMES_FILE );
		}
		
		private function onErrorLoadSaveFile(error:uint):void
		{		
			_savedGame.removeEventListener(pSavedGame.COMPLETE, onLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_LOAD, onErrorLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_PARSING, onErrorPasingSaveFile );
			
			_menuLogic.init();
			
			sendAuthorizationRequest();
		}
		
		private function onErrorPasingSaveFile(error:Error):void
		{
			_savedGame.removeEventListener(pSavedGame.COMPLETE, onLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_LOAD, onErrorLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_PARSING, onErrorPasingSaveFile );
			
			_menuLogic.setOffLineMode();
			_menuLogic.init();
			
			sendAuthorizationRequest();
			
			trace("onErrorPasingSavedGameFile");
		}
		
		private function onLoadSaveFile(e:Event):void
		{
			_savedGame.removeEventListener(pSavedGame.COMPLETE, onLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_LOAD, onErrorLoadSaveFile );
			_savedGame.removeEventListener(pSavedGame.ERROR_PARSING, onErrorPasingSaveFile );
			
			sendAuthorizationRequest();
		}	
		
		private function sendAuthorizationRequest():void
		{
			if(_serverProxy.status == pServer.STATUS_ON)
			{
				_serverProxy.addEventListener(pServer.RECEIVE_DATA, handlerReceiveServerData);
			}
			
			_menuLogic.init();
			_menuLogic.init();
		}	
		
		private function handlerReceiveServerData(data:Object):void
		{
			var events:Array = data.events;
			
			if(events)
			{
				var i:int;
				for(i = 0; i < events.length; i++)
				{
					parserServerEvent(events[i]);
				}
			}
		}
		
		
		private function parserServerEvent(data:Object):void
		{
			switch(data.event)
			{
				case 5:
				{
					addGameToList(data.data);
					break;
				}
			}
		}
		
		private function addGameToList(obj:Object):void
		{
			if(obj.status)
			{
				var gameData:FullGameData = GameList.Get().getCurrentGameData();
				gameData.enemyName = obj.opponent_name;
				
				_gameLogic.gameAddedToList( gameData.id );
			}
		}
	}
}