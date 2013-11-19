package app.view.components
{
	import app.GlobalSettings;
	import app.view.components.game.mGame;
	import app.view.components.game.mShipLocation;
	import app.view.components.menu.mMenu;
	import app.view.components.menu.pages.game_type.GameTypePage;
	import app.view.components.menu.pages.login.mLoginPage;
	import app.view.components.windows.mWindows;
	import app.view.events.MenuEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mMainView extends Mediator
	{
		private static const GET_STAGE_ACCESS_TIME:			uint = 50;
		
		private var _view:				MainView;
		private var _stage:				Stage;
		
		private var _timer:				Timer;
		
		public function mMainView(viewComponent:Object)
		{
			super();
			
			_stage = viewComponent as Stage;
			
			_timer = new Timer(GET_STAGE_ACCESS_TIME);
			_timer.addEventListener(TimerEvent.TIMER, handlerTimer);
			_timer.start();
		}
		
		public override function listNotificationInterests():Array
		{
			return [
					
					]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			/*var eventName:String = notification.getName();
			
			switch(eventName)
			{
				case MenuEvents.SHOW_STARTUP_PAGE:
				{
					_view.showStartupPage();
					break;
				}
					
				case MenuEvents.HIDE_STARTUP_PAGE:
				{
					_view.removeStartupPage();
					break;
				}
			}*/
		}
		
		
		private function getStageDataAccess():Boolean
		{
			if(_stage && _stage.stageWidth && _stage.stageHeight && _stage.fullScreenWidth && _stage.fullScreenHeight) return true;
			return false;
		}
		
		private function handlerTimer(e:TimerEvent):void
		{
			if( getStageDataAccess() )
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, handlerTimer);
				_timer = null;
				
				createView();
				
				initMediators();
				
				this.sendNotification(MenuEvents.VIEW_READY);
			}
		}
		
		
		private function createView():void
		{
			_view = new MainView();
			_view.setDefaultContentSize(GlobalSettings.DEFAULT_WIDTH, GlobalSettings.DEFAULT_HEIGHT);
			_stage.addChild( _view );
		}
		
		private function initMediators():void
		{
			this.facade.registerMediator( new mShipLocation( _view.gameLayer) );
			this.facade.registerMediator( new mGame( _view.gameLayer) );
			this.facade.registerMediator( new mMenu( _view.menuLayer) );
			this.facade.registerMediator( new mWindows( _view.windowsLayer) );
		}
	}
}