package app.model.server
{
	public interface IServerConnection
	{
		function setServerURl(url:String):void
		function registerCallback(onComplete:Function, onError:Function):void
		function sendRequest( data:Object):void
		function sendAuthorization(data:Object):void
		function sendNewUser(data:Object):void	
		function sendGameKey(data:Object):void
	}
}