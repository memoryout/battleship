package app.controller.logic.game
{
	import app.GlobalSettings;
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.PShipsArray;
	import app.model.save.SavedData;
	import app.model.save.pSavedGame;
	import app.model.server.pServer;
	import app.view.components.menu.MenuUi;
	import app.view.events.GameEvents;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class GameLogic extends Mediator
	{ 		
		public static const NAME:	String = "GameLogic";
		private var _shipsArray:	PShipsArray;
		private var _pServer:		pServer;
		public  var _gameData:		FullGameData;
		
		private var _timer:			Timer = new Timer(1000, 1);
		
		private var stopAllAction:		Boolean;	
		private var gameIsShowing:		Boolean;		// for nowing if game was showed
		private var currentOpenPageName:String;
		
		private var _savedGame:			SavedData;
		private var _savedProxy:		pSavedGame;
		
		public function GameLogic()
		{
			super();
			
			_shipsArray 	= this.facade.retrieveProxy(PShipsArray.NAME) as PShipsArray;		
			_pServer 		= this.facade.retrieveProxy( pServer.NAME ) as pServer;
			_savedProxy 	= this.facade.retrieveProxy(pSavedGame.NAME) as pSavedGame;
		}
		
		public function gameAddedToList(newGameId:uint = 0):void
		{
			
		}
		
		private function startGame():void
		{
			_gameData = GameList.Get().getCurrentGameData();	
						
			
			_gameData.userShips 		= _shipsArray.getShipsPosition();				
			_gameData.userBattleField 	= _shipsArray.getBattleField();
			_shipsArray.cleanData();
				
			this.sendNotification(GameEvents.PLACE_SHIPS, [_gameData.userShips, _gameData.userBattleField]);								
			
			this.sendNotification(GameEvents.GET_GAME_DATA, _gameData);
		}
		
		private function sendPosition():void
		{			
			_gameData.userShips 		= _shipsArray.getShipsPosition();
			_gameData.userBattleField 	= _shipsArray.getBattleField();
			
			this.sendNotification(GameEvents.PLACE_SHIPS,  	[_gameData.userShips, _gameData.userBattleField]);
			this.sendNotification(GameEvents.GET_GAME_DATA,	_gameData);
		}
		
		private function sendComputerShipsPosition():void
		{
			this.sendNotification(GameEvents.SET_COMPUTER_SHIPS_POSITION);
		}
		
		/** 
		 * Make action depend status, in game with player.
		 */		
		private function checkState():void
		{
			if(_gameData.opponentType == FullGameData.OPPONENT_PLAYER)
			{
				if(_gameData.status == FullGameData.STEP_OF_OPPONENT || _gameData.status == FullGameData.WAITING_FOR_START)
				{					
					this.sendNotification(GameEvents.LOCK_OPONENT_FIELD, true);
					this.sendNotification(WindowsEvents.GET_CURRENT_OPEN_WINDOW_NAME);	// for get current open page name
					
					if((gameIsShowing && !currentOpenPageName) || (gameIsShowing && currentOpenPageName != "game_wait"))	
					{
						this.sendNotification(WindowsEvents.OPEN_WINDOW,  "game_wait");
					}
				
				}else{
					
					this.sendNotification(GameEvents.LOCK_OPONENT_FIELD, false);
					this.sendNotification(WindowsEvents.CLOSE_WINDOW, "game_wait");
				}
				
				if(_gameData.status == FullGameData.INCOMING_USER_WON)
				{
					this.sendNotification(WindowsEvents.GET_CURRENT_OPEN_WINDOW_NAME);	// for get current open page name
					
					if(!currentOpenPageName || currentOpenPageName != "game_finish")	
					{					
						this.sendNotification(WindowsEvents.OPEN_WINDOW, "game_finish");						
						this.sendNotification(GameEvents.SET_WINNER, "User");						
					}
				}
				
				if(_gameData.status == FullGameData.OPPONENT_WON)
				{
					this.sendNotification(WindowsEvents.GET_CURRENT_OPEN_WINDOW_NAME);	// for get current open page name
					
					if(!currentOpenPageName || currentOpenPageName != "game_finish")	
					{
						this.sendNotification(WindowsEvents.OPEN_WINDOW, "game_finish");						
						this.sendNotification(GameEvents.SET_WINNER, "Oponent");
					}
				}						
			}
		}		
		
		/** 
		 * Make action depend status, in game with computer.
		 */	
		private function checkStateGameWithComputer():void
		{
			if(_gameData.opponentType == FullGameData.OPPONENT_COMPUTER)
			{
				if(_gameData.status == FullGameData.WAITING_FOR_START)
				{
					_gameData.status = FullGameData.STEP_OF_INCOMING_USER;
					this.sendNotification(GameEvents.LOCK_OPONENT_FIELD, false);
					saveToFileGameWithComputer();			
				}
				else if(_gameData.status == FullGameData.STEP_OF_INCOMING_USER)
				{
					this.sendNotification(GameEvents.SHOW_PLAYER_MOVE);		
					saveToFileGameWithComputer();			
					
				}else if(_gameData.status == FullGameData.STEP_OF_OPPONENT)
				{
					this.sendNotification(GameEvents.SHOW_COM_MOVE);	
					saveToFileGameWithComputer();			
					
				}else if(_gameData.status == FullGameData.INCOMING_USER_WON)
				{
					this.sendNotification(GameEvents.SHOW_FINISH_POP_UP, "Player");	
					removeFileWithSavedComputerGame();
					
				}else if(_gameData.status == FullGameData.OPPONENT_WON)
				{
					this.sendNotification(GameEvents.SHOW_FINISH_POP_UP, "Computer");
					removeFileWithSavedComputerGame();
				}
			}
		}
		
		private function updateAfterMoveEnd():void
		{
			if(_gameData.opponentType == FullGameData.OPPONENT_COMPUTER)  // when you play with computer
			{
				if(_gameData.status == FullGameData.STEP_OF_INCOMING_USER) // updating after player move
				{						
					if(_gameData.shipIsKill || _gameData.isHited)
					{						
						if(!_gameData.shipIsKill)
						{							
							this.sendNotification(GameEvents.UPDATE_OPONENT_FIELD, [_gameData.isHited, _gameData.currentSelectedCell]);									
							
						}else{
							
							this.sendNotification(GameEvents.UPDATE_OPONENT_FIELD, [_gameData.isHited, _gameData.currentSelectedCell, _gameData.lastHitShipPositionCom]);
							
							if(_gameData.killedShipsCouterCom == 10)	
							{
								_gameData.status = FullGameData.INCOMING_USER_WON;	
								checkStateGameWithComputer();
							}
						}
						
						_gameData.isHited = _gameData.shipIsKill = false;	
						
					}else{
						
						this.sendNotification(GameEvents.UPDATE_OPONENT_FIELD, [_gameData.isHited, _gameData.currentSelectedCell]);	
								
						this.sendNotification(GameEvents.LOCK_OPONENT_FIELD, true);
						
						_gameData.status = FullGameData.STEP_OF_OPPONENT;
						
						_timer.addEventListener(TimerEvent.TIMER_COMPLETE, setComputerMove);
						_timer.start();
					}
				
				}else													// updating after computer move
				{						
					if(_gameData.shipIsKill || _gameData.isHited)
					{
						if(!_gameData.shipIsKill)
						{										
							this.sendNotification(GameEvents.UPDATE_USER_FIELD, [_gameData.isHited, _gameData.currentSelectedCell]);
							
							_gameData.isHited 			= false;
							_gameData.oponentShipIsHit 	= true;			
							
						}else{
							
							this.sendNotification(GameEvents.UPDATE_USER_FIELD, [_gameData.isHited, _gameData.currentSelectedCell, _gameData.lastHitShipPositionPl]);
							
							_gameData.oponentShipIsHit 	= _gameData.shipIsKill = false;		
							_gameData.findAnotherShip 	= true;											
						}		
						
						if(_gameData.killedShipsCouterPl == 10)
						{
							_gameData.status = FullGameData.OPPONENT_WON;		
							checkStateGameWithComputer();
						
						}else{
							_timer.addEventListener(TimerEvent.TIMER_COMPLETE, setComputerMove);
							_timer.start();			
						}						
					}else{
						
						this.sendNotification(GameEvents.UPDATE_USER_FIELD, [_gameData.isHited, _gameData.currentSelectedCell]);
						
						_gameData.status = FullGameData.STEP_OF_INCOMING_USER;
						this.sendNotification(GameEvents.LOCK_OPONENT_FIELD, false);
					}			
				}		
			}
		}
		
		private function setComputerMove(e:TimerEvent = null):void
		{
			if(_timer){				
				_timer.stop();
				_timer.removeEventListener(TimeEvent.COMPLETE, setComputerMove);
			}	
			
			checkStateGameWithComputer();
		}
		
		private function saveData():void
		{
			if(_gameData) _gameData.saveGameData();
		}
		
		private function showMenu():void
		{
			this.sendNotification(MenuEvents.SHOW_PAGE_WITH_GAME_TYPE);
		}
		
		private function changeGameData(id:uint):void
		{
			_gameData = GameList.Get().getCurrentGameData();
			this.sendNotification(GameEvents.GET_GAME_DATA, _gameData);
		}
		
		private function locking(val:Boolean):void
		{
			stopAllAction = val;
		}
		
		/** 
		 * Create new game with with oponent type - "Computer".
		 * Get ships location and main battle field with ships.
		 * Save current game data.
		 * Show Game table.
		 */		
		private function createGameWithComputer():void
		{			
			if(!_gameData) _gameData = new FullGameData();
			
			_gameData.opponentType 	  = FullGameData.OPPONENT_COMPUTER;			
				
			_gameData.enemyShips 		= _shipsArray.getShipsPosition();				
			_gameData.enemyBattleField 	= _shipsArray.getBattleField();
			_shipsArray.cleanData();
				
			_gameData.setOpponent( "Computer", "0" );	
			
			GameList.Get().setCurrentGameData(_gameData);	
			GameList.Get().setComputerGameData(_gameData);
			GameList.Get().addGameWithComputerToList(_gameData);
			
			this.sendNotification(GameEvents.INIT_COMPTER_LOGIC);
			this.sendNotification(GameEvents.GET_GAME_DATA, _gameData);
			this.sendNotification(GameEvents.SHOW_GAME, [	_gameData.userShips,  _gameData.userBattleField, 
															_gameData.enemyShips, _gameData.enemyBattleField, 
															_gameData.id, 		  _gameData.status
														]);			
			
			saveToFileGameWithComputer();			
		}
		
		/** 
		 * Create new game with with oponent type - "Player".
		 */		
		private function createGameWithPlayer():void
		{		
			_gameData.opponentType 	  = FullGameData.OPPONENT_PLAYER;					
			
			GameList.Get().setCurrentGameData(_gameData);					
			
			var _ships:Array = new Array();
			
			for (var i:int = 0; i < _gameData.userShips[0].length; i++) 
			{
				var shipData:Object = _gameData.userShips[0][i];
				_ships.push([shipData.coordinates[0], shipData.coordinates[shipData.coordinates.length-1]])
			}
			
			_pServer.createGameWithPlayer(_ships);
			
			_ships = null;
		}
		
		/** 
		 * Show hit on table depend on player type.
		 */		
		private function setHit(val:Object):void
		{
			var _event:String;
			
			if(val.player == "user")	_event = GameEvents.UPDATE_OPONENT_FIELD;			
			else						_event = GameEvents.UPDATE_USER_FIELD;			
			
			if(val.ship_status == 1)  		this.sendNotification(_event, [true,  [val.column, val.line]]);
			else if(val.ship_status == 2)	this.sendNotification(_event, [true,  [val.column, val.line], val.killed_coordinates ]);	
			else							this.sendNotification(_event, [false, [val.column, val.line]]);			
		}
		
		/** 
		 * Save game with computer data to file.
		 */		
		private function saveToFileGameWithComputer():void
		{
			var fullGameData:FullGameData = GameList.Get().getCurrentGameData();
			
			_savedGame = _savedProxy.getSavedData();
			
			_savedProxy.setSavedData(fullGameData);		
						
			_savedProxy.saveConfig(GlobalSettings.PATH + GlobalSettings.SAVED_GAMES_FILE);			
		}
		
		/** 		
		 * Send message to showing game.
		 * Set _gameData.
		 * Send message to show game.
		 * If is game with computer call checkStateGameWithComputer().
		 */		
		private function startPlayGame(gameWithComputer:Boolean = false):void
		{
			gameIsShowing = true;
			
			if(!gameWithComputer)			_gameData = GameList.Get().getCurrentGameData();		
			else							
			{
				_gameData = GameList.Get().getComputerGameData();		// get data to start game with computer
				GameList.Get().setCurrentGameData(_gameData);
				this.sendNotification(GameEvents.GET_GAME_DATA, _gameData);
			}		
			
			this.sendNotification(GameEvents.SHOW_GAME, [	_gameData.userShips,  _gameData.userBattleField, 
															_gameData.enemyShips, _gameData.enemyBattleField, 
															_gameData.id, 		  _gameData.status]);	
			
			if(gameWithComputer)	checkStateGameWithComputer();	
		}
		
		/** 
		 * Remove computer game data from game list.
		 * Reset _gameData.
		 */		
		private function removeFileWithSavedComputerGame():void
		{
			_savedProxy.removeSavedFiel(GlobalSettings.PATH + GlobalSettings.SAVED_GAMES_FILE);
			
			if(_gameData)
			{
				GameList.Get().deleteGameData(_gameData.id);
				_gameData = new FullGameData();
				GameList.Get().setComputerGameData(_gameData);		
				GameList.Get().setCurrentGameData(_gameData);		
			}			
		}
		
		public override function listNotificationInterests():Array
		{
			return [				
				GameEvents.SEND_POSITION_OF_SELECTED_CELL_TO_VERIFYING,
				GameEvents.GET_COMPUTER_SHIPS_POSITION,
				GameEvents.SHUFFLE_SHIPS_POSITION,
				GameEvents.SAVE_GAME_DATA,
				GameEvents.SHOW_MENU_PAGE,
				GameEvents.MOVE_END,
				GameEvents.SWITCH_GAME_DATA,
				GameEvents.STOP_GAME,
				GameEvents.GET_GAME_STATUS,
				GameEvents.UPDATE_GAME,				
				ModelEvents.START_GAME,
				ModelEvents.CREATE_GAME,
				WindowsEvents.CURRENT_OPEN_WINDOW_NAME,
				ModelEvents.REMOVE_GAME_ON_SERVER,
				GameEvents.IS_POSSIBLE_TO_SHOW_GAME
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{				
				case GameEvents.GET_COMPUTER_SHIPS_POSITION:
				{
					sendComputerShipsPosition();					
					break;
				}
				case GameEvents.SHUFFLE_SHIPS_POSITION:
				{
					sendPosition();					
					break;
				}

				case ModelEvents.CREATE_GAME:
				{
					if(_gameData.opponentType == FullGameData.OPPONENT_PLAYER)
					{
						createGameWithPlayer();
						
					}else if(_gameData.opponentType == FullGameData.OPPONENT_COMPUTER)
					{
						createGameWithComputer();
						checkStateGameWithComputer();
					}
					
					break;
				}
					
				case ModelEvents.START_GAME:
				{				
					startGame();		
					
					if(notification.getBody() == "User")	_gameData.opponentType = FullGameData.OPPONENT_PLAYER;						
					else									_gameData.opponentType = FullGameData.OPPONENT_COMPUTER;					
					
					break;
				}			
					
				case GameEvents.SEND_POSITION_OF_SELECTED_CELL_TO_VERIFYING:
				{												
					if(GameList.Get().getCurrentGameData().opponentType == FullGameData.OPPONENT_PLAYER)
					{
						GameList.Get().getCurrentGameData().currentSelectedCell = notification.getBody() as Array;
												
						checkState();
						_pServer.setSelectedCell(_gameData.currentSelectedCell, GameList.Get().getCurrentGameData().id);	
					}else{
						
						GameList.Get().getCurrentGameData().currentSelectedCell = notification.getBody() as Array;
						checkStateGameWithComputer();
					}					
					
					break;
				}
				
				case GameEvents.GET_GAME_STATUS:
				{
					if(notification.getBody() != 0)	_pServer.getGameStatus(notification.getBody() as int);
					else							startPlayGame(true);
				}
			
				case GameEvents.SAVE_GAME_DATA:
				{
					saveData();
					break;
				}
				
				case GameEvents.SHOW_MENU_PAGE:
				{
					showMenu();
					break;
				}
				
				case GameEvents.MOVE_END:
				{
					if(!stopAllAction) updateAfterMoveEnd();
					break;
				}
				
				case GameEvents.SWITCH_GAME_DATA:
				{
					changeGameData(notification.getBody() as uint);
					break;
				}
				
				case GameEvents.STOP_GAME:
				{
					locking( notification.getBody() as Boolean );
					break;
				}
					
				case GameEvents.IS_POSSIBLE_TO_SHOW_GAME:
				{	
					startPlayGame();
					checkState();
					
					break;
				}
					
				case GameEvents.UPDATE_GAME:  // update game view after get "active_games" server request
				{
					_gameData = GameList.Get().getCurrentGameData();
					
					if(_gameData.id != 0) // don't make updating when is playing game with computer
					{
						checkState();						
						if(notification.getBody()) setHit(notification.getBody());  // if was hit					
					}	
					break;
				}
					
				case WindowsEvents.CURRENT_OPEN_WINDOW_NAME:
				{
					if(notification.getBody()) currentOpenPageName = notification.getBody().toString();
					break;
				}	
					
				case ModelEvents.REMOVE_GAME_ON_SERVER:
				{	
					if(notification.getBody() as int != 0)	_pServer.removeGameFromList(notification.getBody() as int);
					else									removeFileWithSavedComputerGame();					
					
					break;
				}
				
				case GameEvents.STOP_COMPUTER_LOGIC:
				{
					if(_timer){				
						_timer.stop();
						_timer.removeEventListener(TimeEvent.COMPLETE, setComputerMove);
					}
					break;
				}
			}
		}
	}
}