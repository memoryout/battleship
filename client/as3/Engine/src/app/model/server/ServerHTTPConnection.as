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
			
			var loader:URLLoader = new URLLoader();
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
			loader = null;
		}
		
		
		private function handlerErrorConnection(e:IOErrorEvent):void
		{
			_callback["onError"]( e.toString() );
		}
		
		private function createRequest(data:Object):URLRequest
		{
			var req:URLRequest = new URLRequest(_serverURL), vars:URLVariables = new URLVariables(), par:String;			
			
			for(par in data.data)	vars[par] = data.data[par].toString();
			
			vars["rand"] = Math.random();
			
			req.data 	= vars;
			req.method 	= URLRequestMethod.GET;
			
			return req;
		}
		
		public function sendAuthorization(data:Object):void{}		
		public function sendNewUser(data:Object):void{}				
		public function sendGameKey(data:Object):void{}
	}
}