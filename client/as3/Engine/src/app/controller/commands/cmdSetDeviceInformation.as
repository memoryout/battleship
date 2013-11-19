package app.controller.commands
{
	import app.model.autorization.pAuth;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.command.SimpleCommand;
	
	public class cmdSetDeviceInformation extends SimpleCommand
	{		
		public override function execute(notification:INotification):void
		{
			var id:String = String( notification.getBody() )
			
			var auth:pAuth = this.facade.retrieveProxy(pAuth.NAME) as pAuth;
			auth.setDeviceInfo(id);
		}
	}
}