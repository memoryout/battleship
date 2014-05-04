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
		public static const STATUS_ON:				uint = 1;
		public static const STATUS_OFF:				uint = 0;
		
		public static const NAME				   :String = "pServer";
		
		private static const AUTHORIZE:				uint = 0;
		private static const USER_SETTINGS:			uint = 1;
		private static const START_GAME:			uint = 2;
		private static const GAME_PLAY_DEFINE:		uint = 3;
		private static const GET_UPDATES:			uint = 4;
		private static const REMOVE_GAME:			uint = 5;
		
		private static const AUTHORIZE_CMD:			String = "authorize";
		private static const USER_SETTINGS_CMD:		String = "user_settings";
		private static const START_GAME_CMD:		String = "start_game";
		private static const GAME_PLAY_CMD:			String = "game_play";
		private static const GET_UPDATES_CMD:		String = "get_updates";
		private static const REMOVE_GAME_CMD:		String = "remove_game";
		
		private static const SEND_EVENTS_ID:	Dictionary = new Dictionary();
		
		SEND_EVENTS_ID[AUTHORIZE] 			= "authorize.php";
		SEND_EVENTS_ID[USER_SETTINGS] 		= "user_settings.php";
		SEND_EVENTS_ID[START_GAME] 			= "start_game.php";
		SEND_EVENTS_ID[GAME_PLAY_DEFINE] 	= "game_play_define.php";
		SEND_EVENTS_ID[GET_UPDATES] 		= "get_updates.php";
		SEND_EVENTS_ID[REMOVE_GAME] 		= "remove_game.php";
		
		
		private static const EVENTS_ID:			Dictionary = new Dictionary();
		
		EVENTS_ID["loginInfo"] = 1;
		EVENTS_ID["gameInfo"]  = 5;
		EVENTS_ID["errorInfo"] = 100;		
		
		public static const RECEIVE_DATA:		uint = 0;
		public static const ERROR_CONNECTION:	uint = 1;
		public static const ERROR_PARSING:		uint = 2;
		
		public  var _server:				 IServerConnection;		
		private var _serverParser:			 ServerParser;	
		
		private var _status:				 uint;		
		private var _key:					 String;		
		
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
		
		public function newUser(id:String, name:String):void
		{			
			_server.sendRequest( createEvent( AUTHORIZE, {name:name, id:id, cmd:AUTHORIZE_CMD} ) );
		}
		
		public function createGameWithPlayer(val:Array):void
		{
			_server.sendRequest( createEvent( START_GAME, {cmd:START_GAME_CMD, session:_key, ships:JSON.stringify(val) } ) );
		}
		
		public function setSelectedCell(val:Array, id:int):void
		{
			if(val.length == 0)
			{
				trace("!!!!");
			}
						
			_server.sendRequest( createEvent( GAME_PLAY_DEFINE, {cmd:GAME_PLAY_CMD, session:_key, target:JSON.stringify(val) } ) );
			
		}
		
		public function getGameUpdate():void	
		{				
			_server.sendRequest( createEvent( GET_UPDATES, {session:_key, cmd:GET_UPDATES_CMD} ) );
		}
		
		public function removeGameFromList(id:int):void
		{
			_server.sendRequest( createEvent( REMOVE_GAME, {session:_key, cmd:GET_UPDATES_CMD, game_id:id} ) );			
		}	
		
		public function makeSelectedGame(gameKey:String):void
		{
			_server.sendGameKey( gameKey );
		}	
		
		private function createEvent(id:uint, data:Object):Object
		{
			var event:Object = new Object();
			event.data = data;
			
			return event;
		}
		
		public function getGameStatus(id:int):void
		{
			_server.sendRequest( createEvent( GAME_PLAY_DEFINE, {cmd:"game_status", session:_key, game_id:id } ) );
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
		}
		
		private function handlerReciveData(data:String):void
		{
			var js:Object; 
			
			try
			{
				js = JSON.parse( data );
			}
			catch(error:Error)
			{
				_status = STATUS_OFF;			
				return;
			}
			
			_status = STATUS_ON;
			
			js = convertResponceToEvents(js);			
			
			//------------
			_serverParser.parseServerAnswer( data );
			//-------------
		}
	}
}