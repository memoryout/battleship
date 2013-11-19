package app.view.components.menu.pages.login
{
	import app.ApplicationFacade;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mLoginPage extends Mediator
	{
		private static const NAME:			String = "view.menu.mLoginPage";
		
		private var _loginPage:		LoginPage;
		
		public function mLoginPage(viewComponent:Object=null)
		{
			_loginPage = viewComponent as LoginPage;
			
			this.facade.registerMediator( this );
		}
		
		public function destroy():void
		{
			_loginPage = null;
			
			this.facade.removeMediator( NAME );
		}
		
		public function setName(name:String):void
		{
			this.sendNotification(MenuEvents.USER_SET_NAME, name );
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}
	}
}