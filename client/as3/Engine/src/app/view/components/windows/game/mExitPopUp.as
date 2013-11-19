package app.view.components.windows.game
{
	import app.view.events.GameEvents;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mExitPopUp extends Mediator
	{
		private static const NAME:			String = "app.view.components.game.pages.mExitPopUp";
		private var _finishPopUp:	FinishPopUp;
		
		public function mExitPopUp(viewComponent:Object=null)
		{
			_finishPopUp = viewComponent as FinishPopUp;
			
			this.facade.registerMediator( this );
		}
		
		public function destroy():void
		{
			_finishPopUp = null;
			
			this.facade.removeMediator( NAME );
		}		
		
		public function gotoMenu():void
		{
			this.sendNotification(GameEvents.EXIT_TO_MENU);
		}
		
		public function closePopUp():void
		{
			this.sendNotification(WindowsEvents.CLOSE_WINDOW, "game_exit");
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}		
	}
}