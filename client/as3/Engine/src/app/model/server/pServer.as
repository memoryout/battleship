package app.model.server
{
	import app.ApplicationFacade;
	import app.GlobalSettings;
	import app.model.events.ModelEvents;
		
	import flash.utils.Dictionary;
	
	import org.puremvc.patterns.facade.Facade;
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pServer extends Proxy
	{
		public static const STATUS_ON:		uint = 1;
		public static const STATUS_OFF:		uint = 0;
		
		public static const NAME:			String = "pServer";
		
		private static const NEW_USER:			uint = 0;
		private static const GET_GAME_LIST:		uint = 1;
		private static const ADD_PLAYER:		uint = 5;
		private static const GAME_PLAY:			uint = 2;
		private static const REMOVE_GAME:		uint = 3;
		
		private static const SEND_EVENTS_ID:	Dictionary = new Dictionary();
		
		SEND_EVENTS_ID[NEW_USER] 	= "authorize.php";
		SEND_EVENTS_ID[ADD_PLAYER] 	= "game/startGame.php";
		
		
		private static const EVENTS_ID:			Dictionary = new Dictionary();
		EVENTS_ID["loginInfo"] = 1;
		EVENTS_ID["gameInfo"]  = 5;
		EVENTS_ID["errorInfo"] = 100;
		
		
		public static const RECEIVE_DATA:		uint = 0;
		public static const ERROR_CONNECTION:	uint = 1;
		public static const ERROR_PARSING:		uint = 2;
		
		private var _server:				IServerConnection;
		
		private var _serverParser:			ServerParser;	
		
		private var _status:				uint;
		
		private var _key:					String;
		
		public function pServer(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
			
			_serverParser = new ServerParser(this);
			this.facade.registerMediator( _serverParser );
			
			_server = new ServerHTTPConnection();
			
			_key = "";
			_status = STATUS_OFF;
			
			_server.setServerURl( GlobalSettings.SERVER_URL );
			_server.registerCallback( handlerReciveData, handlerErrorData);
		}
		
		public function get status():uint
		{
			return _status;
		}
		
		public function setKey(str:String):void
		{
			_key = str;
		}
		
		public function makeAuthorization(login:String, pass:String):void
		{
			_server.sendRequest( createEvent( NEW_USER, {login:login, pass:pass, cmd:"authorize"} ) );
		}
		
		public function newUser(id:String, name:String):void
		{
			_server.sendRequest( createEvent( NEW_USER, {name:name, id:id, cmd:"authorize"} ) );
		}
		
		public function createGameWithPlayer(val:Array):void
		{
			_server.sendRequest( createEvent( ADD_PLAYER, {cmd:"start_game", session:_key, ships:JSON.stringify(val) } ) );
		}
		
		public function setSelectedCell(val:Array, id:int):void
		{
			_server.sendRequest( createEvent( ADD_PLAYER, {cmd:"game_play", session:_key, game_id:id, target:JSON.stringify(val) } ) );
		}
		
		public function getGameStatus(id:int):void
		{
			_server.sendRequest( createEvent( ADD_PLAYER, {cmd:"game_status", session:_key, game_id:id } ) );
		}
		
		public function getActiveGameList():void	
		{
			_server.sendRequest( createEvent( GET_GAME_LIST, {session:_key, cmd:"active_games"} ) );
		}
		
		public function makeTypeOfTheGame(gameType:String):void
		{
			_server.sendGameType( gameType );
		}
		
		public function removeGameFromList(id:int):void
		{
			_server.sendRequest( createEvent( REMOVE_GAME, {session:_key, cmd:"remove_game", game_id:id} ) );			
		}
		
		public function addPlayerToList():void
		{
			_server.addPlayerToList();
		}	
		
		public function addComputerToList():void
		{
			_server.addComputerToList();
		}	
		
		public function makeSelectedGame(gameKey:String):void
		{
			_server.sendSelectedGameKey( gameKey );
		}	
		
		private function createEvent(id:uint, data:Object):Object
		{
			var event:Object = new Object();
			event.data = data;
			
			return event;
		}
		
		
		private function convertResponceToEvents(data:Object):Object
		{
			var res:Object = new Object();
			
			res.events = [];
			
			var par:String, eventData:Object;
			for(par in data)
			{
				if( EVENTS_ID[ par ] != null )
				{
					eventData = new Object();
					eventData.event = EVENTS_ID[ par ];
					eventData.data = data[par];
					res.events.push( eventData );
				}
			}			
			
			return res;
		}
		
		
		private function handlerErrorData(error:String):void
		{
			_status = STATUS_OFF;
			this.dispatch(ERROR_CONNECTION, error);
			//this.sendNotification(ModelEvents.SERVER_CONNECTION_ERROR);
		}
		
		private function handlerReciveData(data:String):void
		{
			var js:Object; 
			
			trace("handlerReciveData", data);
			
			try
			{
				js = JSON.parse( data );
			}
			catch(error:Error)
			{
				_status = STATUS_OFF;
				this.dispatch( ERROR_PARSING, data );
				return;
			}
			
			_status = STATUS_ON;
			
			js = convertResponceToEvents(js);
			
			this.dispatch(RECEIVE_DATA, js);
			
			//------------
			_serverParser.parseServerAnswer( data );
			//-------------
		}
	}
}