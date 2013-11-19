package app.view.components.game
{
	import app.model.events.ModelEvents;
	import app.view.events.GameEvents;
	import app.view.events.WindowsEvents;
	
	import flash.display.Sprite;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mShipLocation extends Mediator
	{
		private static const NAME:		String = "app.view.components.game.mShipLocation";
		private var _rootSprite:		Sprite;
		private var _shipLocation:		ShipLocation;	
		
		public function mShipLocation(viewComponent:Object=null)
		{
			_rootSprite = viewComponent as Sprite;	
			super(viewComponent);
		}
		
		private function showLocation():void
		{
			if(!_shipLocation)
			{	
				_shipLocation = new ShipLocation(this);
				_rootSprite.addChild(_shipLocation);
			}		
		}
		
		private function setPlayerShips(obj:Object):void
		{
			_shipLocation.setPlayerShipsPosition(obj);
		}
		
		public function shuffleShips():void
		{
			this.sendNotification(GameEvents.SHUFFLE_SHIPS_POSITION);
		}
		
		public function createGame(val:Object):void
		{	
			this.sendNotification(ModelEvents.CREATE_GAME);
			
			if(_shipLocation)
			{	
				_rootSprite.removeChild(_shipLocation);
				_shipLocation = null;
			}						
		}
		
		public function showPopUp(str:String):void
		{
			this.sendNotification(WindowsEvents.OPEN_WINDOW, str);
		}
		
		public function destroy():void
		{	
			if(_shipLocation)
			{
				if(_rootSprite.contains(_shipLocation))
				{
					_rootSprite.removeChild(_shipLocation);
					_shipLocation.destroy();
					_shipLocation = null;
				}	
			}					
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				GameEvents.SHOW_SHIP_LOCATION,
				GameEvents.PLACE_SHIPS,
				GameEvents.SET_SHIPS_POSITION_IN_GAME
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{			
			var eventName:String = notification.getName();		
						
			switch(eventName)
			{
				case GameEvents.SHOW_SHIP_LOCATION:
				{
					showLocation();
					break;
				}
					
				case GameEvents.PLACE_SHIPS:
				{
					setPlayerShips(notification.getBody());
					break;
				}
			}
		}
	}
}