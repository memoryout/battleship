package app.view.components.windows.game
{
	import app.view.events.GameEvents;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mFinishPopUp extends Mediator
	{
		private static const NAME:			String = "app.view.components.game.pages.mFinishPopUp";
		private var _finishPopUp:	FinishPopUp;
		
		public function mFinishPopUp(viewComponent:Object=null)
		{
			_finishPopUp = viewComponent as FinishPopUp;
			
			this.facade.registerMediator( this );
		}
		
		public function destroy():void
		{
			_finishPopUp = null;
			
			this.facade.removeMediator( NAME );
		}
		
		public function setWinner(val:Object):void
		{
			_finishPopUp.setWinner(val);
		}
		
		public function closePopUp():void
		{
			this.sendNotification(WindowsEvents.CLOSE_WINDOW, "game_finish");
		}
		
		public function gotoMenu():void
		{
			this.sendNotification(GameEvents.SHOW_MENU_PAGE);
			this.sendNotification(GameEvents.DESTROY_GAME);
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				GameEvents.SET_WINNER			
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{			
			var eventName:String = notification.getName();		
			
			switch(eventName)
			{
				case GameEvents.SET_WINNER:
				{
					setWinner(notification.getBody());
					break;
				}								
			}
		}
	}
}