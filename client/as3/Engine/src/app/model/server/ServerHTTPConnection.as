package app.model.server
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class ServerHTTPConnection implements IServerConnection
	{
		private var _serverURL:			String;
		
		private var _callback:			Dictionary;
		
		public function ServerHTTPConnection()
		{
			_callback = new Dictionary();
		}
		
		public function setServerURl(url:String):void
		{
			_serverURL = url;
		}
		
		public function registerCallback(onComplete:Function, onError:Function):void
		{
			_callback["onComplete"] = onComplete;
			_callback["onError"] = onError;
		}
		
		
		public function sendRequest( data:Object ):void
		{
			var req:URLRequest = createRequest( data );
			
			trace(req.url)
			
			var loader:URLLoader = new URLLoader();
//			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE, handlerReceiveData);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorConnection);
			loader.load( req );
		}
		
		
		private function handlerReceiveData(e:Event):void
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener(Event.COMPLETE, handlerReceiveData);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorConnection);
			
			_callback["onComplete"](e.currentTarget.data)
		}
		
		
		private function handlerErrorConnection(e:IOErrorEvent):void
		{
			trace(e)
			_callback["onError"]( e.toString() );
		}
		
		public function sendAuthorization(data:Object):void
		{
			
			//var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":"null"}] }';
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":{"session":"swertgdsasdftrgsdfgs"}}] }';
			_callback["onComplete"](fakeAnswer);
			
			//_callback["onError"]()
		}
		
		public function sendNewUser(data:Object):void
		{
			//var req:URLRequest = createRequest( data, "authorization" );
			
			
			
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"3", "data":{"login":"123123", "pass":"333333", "session":"swertgdsasdftrgsdfgs"}}] }';
			_callback["onComplete"](fakeAnswer);
		}
		
		public function sendGameType(data:Object):void
		{
			//var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":"null"}] }';
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"4", "data": [{"key":"af5asf7", "first_name":"Vasja", "move":"0"}, {"key":"af5asf7", "first_name":"Valera", "move":"1"}] }] }';
			_callback["onComplete"](fakeAnswer);
			
			//_callback["onError"]()
		} 
		
		public function addPlayerToList():void
		{
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"5", "data": {"key":"af5asf7", "first_name":"Roma", "move":"0", "uid":"1233212332"} }] }';
			/*
			if(data == "players")
			{
				

			}else{
				
				var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"5", "data": {"key":"af5asf7", "first_name":"Computer", "move":"0"} }] }';
			}*/
			//var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":"null"}] }';
			_callback["onComplete"](fakeAnswer);
			
			//_callback["onError"]()
		}
		
		public function addComputerToList():void
		{
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Computer"} }, {"event":"5", "data": {"key":"af5asf7", "first_name":"Computer", "move":"0"} }] }';
			/*
			if(data == "players")
			{
			
			
			}else{
			
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"5", "data": {"key":"af5asf7", "first_name":"Computer", "move":"0"} }] }';
			}*/
			//var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":"null"}] }';
			_callback["onComplete"](fakeAnswer);
			
			//_callback["onError"]()
		}
		
		public function sendSelectedGameKey(data:Object):void
		{			
			var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"6", "data": {"key":"af5asf7", "first_name":"Roma", "move":"0"} }] }';
			
			//var fakeAnswer:String = '{"events":[{"event":"1", "data":{"uid":"1", "first_name":"Uasja"} }, {"event":"2", "data":"null"}] }';
			_callback["onComplete"](fakeAnswer);
			
			//_callback["onError"]()
		}
		
		
		private function createRequest(data:Object):URLRequest
		{
			var req:URLRequest = new URLRequest(_serverURL);
//			req.url += data.id;
			
			var vars:URLVariables = new URLVariables();
			var par:String;
			
			
			for(par in data.data)
			{
				vars[par] = data.data[par].toString();
				trace("par", par, data.data[par])
			}
			
			req.data = vars;
			req.method = URLRequestMethod.GET;
			
			return req;
		}
	}
}

// event 1 - user profile data (uid, firstName)
// event 2 - login success
// event 3 - login success new user data
// event 4 - list of users
// event 5 - 