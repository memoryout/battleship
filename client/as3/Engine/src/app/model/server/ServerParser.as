package app.model.server
{
	import app.model.events.ModelEvents;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.Ship;
	import app.view.events.GameEvents;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.patterns.mediator.Mediator;
	
	public class ServerParser extends Mediator
	{
		public static const NAME:String = "ServerParser";	
		
		private var _pServerLink:pServer;
		private var _gameData:FullGameData
		
		public function ServerParser(viewComponent:Object=null)
		{
			super(viewComponent);
			
			_pServerLink = viewComponent as pServer;
		}
		
		public function parseServerAnswer( str:String ):void
		{
			var data:Object = JSON.parse( str );
			var cmd:String = data.cmd;
					
			if(cmd)
			{		
				this.sendNotification(ModelEvents.S_EVENTS_START);
				
				checkEvent(data);				
				
				this.sendNotification(ModelEvents.S_EVENTS_FINISH);
			}
		}
		
		/**
		 * Conver data from server to client format. Save received data.
		 * @param val - request from serer.
		 * 
		 */		
		private function converRequest(val:Object):void
		{				
			_gameData 			= new FullGameData();
			
			_gameData.opponentType 	= FullGameData.OPPONENT_PLAYER;
			_gameData.id 			= val.fullGameInfo.game_id;
			_gameData.status 		= val.fullGameInfo.status;
			
			convertShipsAndBattleField(val.fullGameInfo.ships_field, val.fullGameInfo.ships, "user");
			if(val.fullGameInfo.opponent)
			convertShipsAndBattleField(val.fullGameInfo.opponent.ships_field, val.fullGameInfo.opponent.ships, "oponent");
							
			GameList.Get().setCurrentGameData(_gameData);	
		}	
		
		private function convertShipsAndBattleField( _battle_field:Array, _ships:Array, player:String):void
		{
			var allShipsLocation:Vector.<Ship> 			= new Vector.<Ship>;
			var shipsBattleField:Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
			
			var battleField:Array =  checkOnHit(_battle_field);
			
			for (var i2:int = 0; i2 < 10; i2++) 
			{
				shipsBattleField[i2] = new Vector.<int>(10, false);
			}	
			
			for (var i:int = 0; i < _ships.length; i++) 
			{
				var ship:Ship = new Ship(), orient:int, coordinates:Array =  new Array();
				
				ship.column = _ships[i].coordinates[0][1];
				ship.line 	= _ships[i].coordinates[0][0];				
				ship.deck 	= _ships[i].decks;
				
				if(_ships[i].status == 2 ) ship.drowned = true;
				
				if(		_ships[i].coordinates[1][0] > _ships[i].coordinates[0][0])	orient = 0;	 // ship is on line			
				else if(_ships[i].coordinates[1][1] > _ships[i].coordinates[0][1])	orient = 1;	 // ship is on column
				
				if(orient == 1)
				{
					for (var j:int = 0; j < _ships[i].decks; j++) 
					{						
						coordinates.push([ship.column + j, ship.line]);  // set full position for current ship						
						
						if(battleField[ship.column + j][ship.line] != 8 && battleField[ship.column + j][ship.column] != 7)
						   battleField[ship.column + j][ship.line] = ship.deck;	  // set this ship on battle field with old marks (1,2,3,4 depend on ship decks)
					}	
					
				}else{
					for (var k:int = 0; k < _ships[i].decks; k++) 
					{
						coordinates.push([ship.column, ship.line + k]);	// set full position for current ship
						
						if(battleField[ship.column][ship.line + k] != 8 && battleField[ship.column][ship.line + k] != 7)
						   battleField[ship.column][ship.line + k]  = ship.deck;  // set this ship on battle field with old marks (1,2,3,4 depend on ship decks)
					}	
				}					
				
				ship.coordinates = coordinates;
				ship.orient = orient;		
				
				allShipsLocation.push(ship);
			}	
			
			for (var i3:int = 0; i3 < battleField.length; i3++) 
			{
				for (var i4:int = 0; i4 < battleField[i3].length; i4++) 
				{
					shipsBattleField[i3][i4] = battleField[i3][i4];
				}				
			}			
			
			if(player == "user")
			{
				_gameData.userShips.push(sortByDeck(allShipsLocation));  
				_gameData.userBattleField = shipsBattleField;
				
			}else{
				
				_gameData.enemyShips.push(sortByDeck(allShipsLocation));  
				_gameData.enemyBattleField = shipsBattleField;
			}
		}
		
		private function checkOnHit(val:Array):Array
		{
			var res:Array = val;
			
			for (var i:int = 0; i < res.length; i++) 
			{
				for (var j:int = 0; j < res[i].length; j++) 
				{
					if(		res[i][j] == 2)	res[i][j] = 8;	// empty hit
					else if(res[i][j] == 3) res[i][j] = 7;  // ship hit
				}				
			}			
			
			return res;
		}
		
		/**
		 * Set elements in array depend on ships deck, from higher to lower 
		 */		
		private function sortByDeck(ships:Vector.<Ship>):Vector.<Ship>
		{
			var res:Vector.<Ship> = new Vector.<Ship>(10, false);
			var t_decks_counter:int, two_decks_counter:int, one_decks_counter:int;
			
			for (var i:int = 0; i < ships.length; i++) 
			{
				switch(ships[i].deck)
				{
					case 4:
					{
						res[0] = ships[i];
						break;
					}
					case 3:
					{
						res[1 + t_decks_counter] = ships[i];
						t_decks_counter++;						
						break;
					}
					case 2:
					{
						res[3 + two_decks_counter] = ships[i];
						two_decks_counter++;						
						break;
					}
					case 1:
					{
						res[6 + one_decks_counter] = ships[i];
						one_decks_counter++;						
						break;
					}
				}	
			}			
			
			return res;
		}
		
		private function updateActiveGameData(val:Object):void
		{
			_gameData = GameList.Get().getCurrentGameData();
			var hitData:Object;
			
			for (var i:int = 0; i < val.gamesList.length; i++) 
			{
				if(!GameList.Get().findGameInList( val.gamesList[i].game_id))
				{					
					GameList.Get().addGameToList(val.gamesList[i]);					
				
				}else if(val.gamesList[i].game_id == _gameData.id)
				{			
					GameList.Get().addGameToList(val.gamesList[i]);
					_gameData.status = val.gamesList[i].status;
				}
				
				if(val.gamesList[i].notifications.length > 0 && val.gamesList[i].game_id == _gameData.id)
				{				
					hitData = {ship_status:"0", line:"0", column:"0", player:"oponent", killed_coordinates:""};
					
					hitData.ship_status = val.gamesList[i].notifications[0].data.status;
					
					hitData.line  = val.gamesList[i].notifications[0].data.target[1];
					hitData.column = val.gamesList[i].notifications[0].data.target[0];	
					
					if(hitData.ship_status == 2)
					{
						hitData.killed_coordinates = getFullPosiotionKilledShip(val.gamesList[i].notifications[0].data.ship.coordinates[0], val.gamesList[i].notifications[0].data.ship.coordinates[1], val.gamesList[i].notifications[0].data.ship.decks);
					}
				}
			}
			
			this.sendNotification(GameEvents.UPDATE_GAME, hitData);	
		}
		
		private function determinateActionAfterMove(val:Object):void
		{
			_gameData = GameList.Get().getCurrentGameData();
			
			var hitData:Object;
			
			if(val.hitInfo)
			{
				hitData = {ship_status:"0", line:"0", column:"0", player:"user", killed_coordinates:""};
				
				hitData.ship_status = val.hitInfo.status;
				
				hitData.line  = val.hitInfo.target[1];
				hitData.column = val.hitInfo.target[0];
				
				if(hitData.ship_status == 2)
				{
					hitData.killed_coordinates = getFullPosiotionKilledShip(val.hitInfo.ship.coordinates[0], val.hitInfo.ship.coordinates[1], val.hitInfo.ship.decks);
				}	
			}	
			
			_gameData.status = val.briefGameInfo.status;
			GameList.Get().setCurrentGameData(_gameData);	
			
			this.sendNotification(GameEvents.UPDATE_GAME, hitData);	
		}	
		
		private function getFullPosiotionKilledShip(start_point:Array, end_point:Array, decks_number:int):Array
		{
			var orient:int, res:Array =  new Array();
			
			if(		end_point[0] > start_point[0])	orient = 0;	 // ship is on line			
			else if(end_point[1] > start_point[1])	orient = 1;	 // ship is on column
			
			if(orient == 1)
			{
				for (var j:int = 0; j < decks_number; j++) 
				{						
					res.push([start_point[0] + j, start_point[1]]);  // set full position for current ship							
				}	
				
			}else{
				for (var k:int = 0; k < decks_number; k++) 
				{
					res.push([start_point[0], start_point[1] + k]);  // set full position for current ship	
				}	
			}
			
			return res;
		}
		
		private function checkEvent(obj:Object):void
		{
			switch(obj.cmd)
			{
				case "authorize":												// user authorization in system
				{
					if(obj.error)
					{
						this.sendNotification(ModelEvents.S_NEW_USER_LOGIN_FAIL, obj.data);
					}
					else
					{
						_pServerLink.setKey(obj.loginInfo.session);
						this.sendNotification(ModelEvents.S_NEW_USER_LOGED_SUCCSESS, obj);
					}
					
					break;
				}
				
				case "active_games": 											 // get request with active game list
				{						
					updateActiveGameData(obj);											
					break;
				}
				
				case "start_game":												// when added new player after whereupon is starting new game
				{				
					GameList.Get().addCurrentGameToList(obj.briefGameInfo);
					this.sendNotification(GameEvents.IS_POSSIBLE_TO_SHOW_GAME);		
					break;
				}
					
				case "game_status":												// when selected game from active game list
				{						
					converRequest(obj);							
					this.sendNotification(GameEvents.IS_POSSIBLE_TO_SHOW_GAME);					
					break;
				}
					
				case "game_play": 											 // get request with active game list
				{						
					determinateActionAfterMove(obj);											
					break;
				}	
					
				case "remove_game": 											 // after request for remove game from list
				{						
					
					break;
				}
					
					
				case "error":
				{
					break;
				}
			}
		}
	}
}