package app.view.components.windows.game
{
	import app.view.events.GameEvents;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mWaitForOponentPopUp extends Mediator
	{
		private static const NAME:			String = "app.view.components.windows.game.mWaitForOponentPopUp";
		private var _waitForOponentPopUp:	WaitForOponentPopUp;
		
		public function mWaitForOponentPopUp(viewComponent:Object=null)
		{
			super(viewComponent);
			_waitForOponentPopUp = viewComponent as WaitForOponentPopUp;
		}
		
		public function destroy():void
		{
			_waitForOponentPopUp = null;			
			this.facade.removeMediator( NAME );
		}
	}
}