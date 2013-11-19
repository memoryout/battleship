package app.view.components.menu.pages.game_type
{
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.MainGameData;
	import app.view.events.GameEvents;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class GameTypePage extends Mediator
	{
		private static const NAME:	String = "app.view.components.menu.pages.game_type.GameTypePage";
		
		private var activeGameUi:	GameTypePageUi;		
	
		public function GameTypePage(viewComponent:Object=null)
		{
			super(null);
			
			activeGameUi = viewComponent as GameTypePageUi;
			this.facade.registerMediator( this );		
		}
		
		public function addPlayerClick():void
		{		
			this.sendNotification(MenuEvents.HIDE_MENU);
			this.sendNotification(GameEvents.SHOW_SHIP_LOCATION);
			this.sendNotification(ModelEvents.START_GAME, "User" );				
		}
		
		public function computerPullClick():void
		{
			this.sendNotification(MenuEvents.HIDE_MENU);
			this.sendNotification(GameEvents.SHOW_SHIP_LOCATION);			
			this.sendNotification(ModelEvents.START_GAME, "Computer" );	
		}
		
		private function blockButton(val:Object):void
		{
			activeGameUi.blockButton(val);				
		}
		
		public function destroy():void
		{
			activeGameUi = null;
			this.facade.removeMediator( NAME );
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}
	}
}