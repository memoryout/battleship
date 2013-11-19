package app.view.components.game
{
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.Ship;
	import app.view.components.menu.BaseMenuPage;
	import app.view.components.windows.BasePages;
	import app.view.components.windows.game.ExitPopUp;
	import app.view.components.windows.game.FinishPopUp;
	import app.view.events.GameEvents;
	import app.view.events.WindowsEvents;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mGame extends Mediator
	{
		private static const NAME:			String = "app.view.components.game.mGame";
		
		private var _rootSprite:			Sprite;
		
		private var _gameList:				Dictionary;
	
		private var mainGame:				GameUi;	
		private var userInfo:				UserInfo;	
			
		public var showingGameId:			int;			
		private var oldXNex:				Number;
		
		private var _tween_t:				TweenLite;
		
		private var allActionLock:			Boolean;	
//		private var userInfoIsShowing:		Boolean;
		private var isFullOpen:				Boolean;
			
		public var _gameStatus:int;		
		
		public var _userShips:				Vector.<Vector.<Ship>>;
		public var _oponentShips:			Vector.<Vector.<Ship>>;
		
		public var _userBattlefield:		Vector.<Vector.<int>>;
		public var _oponentBattlefield:		Vector.<Vector.<int>>;
				
		private var initPosition:			Number;
				
		public function mGame(viewComponent:Object=null)
		{
			_rootSprite = viewComponent as Sprite;	
							
			super(viewComponent);
		}	
			
		private function showGame(val:Object):void
		{
//			lockOponentField(true);
			
			if(!mainGame)	mainGame = new GameUi(this);		
			if(!userInfo)	userInfo = new UserInfo(this);
			
			if(!_rootSprite.contains(mainGame))	_rootSprite.addChild(mainGame);						
					
			_gameList = GameList.Get().getList(); 						
			
			addListeners();				
					
			setPlayerShips(val);
			
			mainGame.addListeners();
		}	
		
		private function addListeners():void
		{						
			_rootSprite.addEventListener(MouseEvent.MOUSE_DOWN, 		mouseDown);								
		}
		
		private function removeListeners():void
		{
			_rootSprite.removeEventListener(MouseEvent.MOUSE_DOWN, 		mouseDown);
			_rootSprite.removeEventListener(MouseEvent.MOUSE_UP, 		mouseUp);	
		}
		
		private function mouseDown(e:MouseEvent):void		
		{			
			initPosition = e.stageX;	
			
			if(initPosition < 164 || isFullOpen)
			{
				_rootSprite.addEventListener(MouseEvent.MOUSE_UP, 	 	mouseUp);			
				_rootSprite.addEventListener(MouseEvent.MOUSE_MOVE,  	mouseMove);			
			
			}else{
				
				_rootSprite.removeEventListener(MouseEvent.MOUSE_UP, 	mouseUp);			
				_rootSprite.removeEventListener(MouseEvent.MOUSE_MOVE,  mouseMove);			
			}
		}	
		
		private function mouseUp(e:MouseEvent = null):void		
		{	
			allActionLock = false;
			
			this.sendNotification(GameEvents.STOP_GAME, false);		
			
			_rootSprite.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);		
			
			finalMove(e.stageX);
		}
		
		private function finalMove(_x:Number):void
		{
			_rootSprite.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);		
			
			if(_x > userInfo.width/2)		
			{				
				_tween_t = TweenLite.to(userInfo, 0.2, {x:0});	
				isFullOpen = true;					
			}
			else
			{
				_tween_t = TweenLite.to(userInfo, 0.2, {x:-userInfo.width});	
				isFullOpen = false;	
				allActionLock = false;
				mainGame.addListeners();
			}			
		}
		
		private function mouseMove(e:MouseEvent):void		
		{	
			if(e.stageX < 0 ||  e.stageY < 0 )						finalMove(0);	
			else if(e.stageX > 768 || e.stageX > 1280)				finalMove(768);				
			else if(isFullOpen && initPosition > e.stageX)
			{			
				var _x:Number = 0;
				
				if(e.stageX < 0)									finalMove(0);
				else if(e.stageX < userInfo.width && e.stageX > 0)  _x = (initPosition - e.stageX)*(-1);
				else												_x = e.stageX - userInfo.width;			
									
				userInfo.x = _x;
				
			}else if(!isFullOpen){
											
				if(e.stageX - initPosition > 100 && e.stageX < userInfo.width)
				{	
					if(!allActionLock)
					{
						allActionLock = true;
						mainGame.removeListeners();
						this.sendNotification(GameEvents.STOP_GAME, true);		
					}							
					
					if(!_rootSprite.contains(userInfo)){
						
						_rootSprite.addChild(userInfo);
						userInfo.x = -442;				
						userInfo.y = 0;						
					}
					
					userInfo.x = e.stageX - userInfo.width;								
				
				}else if(e.stageX > userInfo.width)	finalMove(e.stageX);
			}		
		}
			
		private function removeTween():void
		{		
			if(_tween_t) _tween_t.kill();					
		}			
		
		public function sendPositionOfSelectedCell(c:int, l:int):void
		{
			this.sendNotification(GameEvents.SEND_POSITION_OF_SELECTED_CELL_TO_VERIFYING, [c, l]);
		}
		
		private function setPlayerShips(val:Object):void
		{
			_userShips 			= val[0];
			_userBattlefield	= val[1];
			_oponentShips	 	= val[2];
			_oponentBattlefield = val[3];
			showingGameId 		= val[4];
			_gameStatus			= val[5]
			
			mainGame.setPlayerShipsPosition(val);		
		}
		
		private function updateSelectedOponentCell(val:Object):void
		{
			mainGame.setSelectedOponentCell(val);
		}
		
		private function updateSelectedPlayerCell(val:Object):void
		{
			mainGame.setSelectedPlayerCell(val);
		}
		
		private function lockOponentField(val:Object):void
		{
			if(mainGame) mainGame.lockOponentFiled(val);
		}
		
		public function showPopUp(str:String):void
		{
			this.sendNotification(WindowsEvents.OPEN_WINDOW, str);
		}
		
		private function showFinishGamePopUp(val:Object):void
		{
			mainGame.lockOponentFiled(true);
			
			this.sendNotification(WindowsEvents.OPEN_WINDOW, "game_finish");
			
			this.sendNotification(GameEvents.SET_WINNER, val);
		}
		
		private function closeGame():void
		{
			this.sendNotification(GameEvents.SAVE_GAME_DATA);
			this.sendNotification(GameEvents.SHOW_MENU_PAGE);
			
			this.sendNotification(ModelEvents.REMOVE_GAME_ON_SERVER, GameList.Get().getCurrentGameData().id);
			
			if( mainGame ) mainGame.clearContainer();
			destroy();
			
			this.sendNotification(GameEvents.STOP_COMPUTER_LOGIC);
		}
		
		public function destroy():void
		{	
			if(mainGame)
			{
				if(_rootSprite.contains(mainGame))
				{
					_rootSprite.removeChild(mainGame);		
					mainGame.destroy();
					mainGame = null;
				}	
			}		
			
			if(_gameList)	_gameList = null;			
		}
		
		public override function getMediatorName():String
		{
			return NAME;
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				GameEvents.SHOW_GAME,
				GameEvents.SET_SHIPS_POSITION_IN_GAME,
				GameEvents.UPDATE_OPONENT_FIELD,
				GameEvents.UPDATE_USER_FIELD,
				GameEvents.LOCK_OPONENT_FIELD,
				GameEvents.SHOW_FINISH_POP_UP,
				GameEvents.DESTROY_GAME,
				GameEvents.EXIT_TO_MENU
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{			
			var eventName:String = notification.getName();		
			
			switch(eventName)
			{
				case GameEvents.SHOW_GAME:
				{
					showGame(notification.getBody());
					break;
				}
					
				case GameEvents.SET_SHIPS_POSITION_IN_GAME:
				{
					setPlayerShips(notification.getBody());
					break;
				}
					
				case GameEvents.UPDATE_OPONENT_FIELD:
				{
					updateSelectedOponentCell(notification.getBody());
					break;
				}
					
				case GameEvents.UPDATE_USER_FIELD:
				{
					updateSelectedPlayerCell(notification.getBody());
					break;
				}
					
				case GameEvents.LOCK_OPONENT_FIELD:
				{
					lockOponentField(notification.getBody());
					break;
				}	
					
				case GameEvents.SHOW_FINISH_POP_UP:
				{
					showFinishGamePopUp(notification.getBody());
					break;
				}
					
				case GameEvents.DESTROY_GAME:
				{
					destroy();
					break;
				}
				
				case GameEvents.EXIT_TO_MENU:
				{
					closeGame();
					break;
				}
			}
		}
	}
}