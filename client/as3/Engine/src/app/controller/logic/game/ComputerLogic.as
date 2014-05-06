package app.controller.logic.game
{
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.Ship;
	import app.view.events.GameEvents;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.dns.ARecord;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class ComputerLogic extends Mediator
	{		
		private static const COMPUTER_SIDE:	String = "computer";
		private static const PLAYER_SIDE:	String = "player";
		
		private static const UP_WAY:		String = "up";
		private static const DOWN_WAY:		String = "down";
		private static const LEFT_WAY:		String = "left";
		private static const RIGHT_WAY:		String = "right";
		
		private static const ONE_DECK:		int = 1;
		private static const TWO_DECK:		int = 2;
		private static const THREE_DECK:	int = 3;
		private static const FOUR_DECK:		int = 4;
		
		private static const HITED_DECK:	int = 7;
		private static const SELECTED_CELL:	int = 8;
		
		private static const WATER_CELL:	int = 9;
		private static const EMPTY_CELL:	int = 0;
		
		private var _gameData:	FullGameData;	
									
		private var _timer:		Timer = new Timer(1000, 1);
				
		public function ComputerLogic(viewComponent:Object=null)
		{
			super(viewComponent);					
		}
		
		private function initiaization():void
		{
			this.sendNotification(GameEvents.GET_COMPUTER_SHIPS_POSITION);
		}
		
		/** 
		 * Cheking computer battlefield if is hit.
		 * 
		 * Call checkIfShipIskill() for determinating if ship is kill.
		 * If ship is kill call setWaterAroundFullHitedShip().
		 * If selected cell is not already selected, send message about end of the step.
		 */		
		private function checkOponentField():void
		{		
			var column:int 	= correctRange(_gameData.currentSelectedCell[0]);
			var line:int 	= correctRange(_gameData.currentSelectedCell[1]);
		
			var oponentShipsPositions:Vector.<Vector.<int>> = _gameData.oponentBattleField;
			
			var currentCellValue:int = oponentShipsPositions[column][line] as int, cellAlreadySelected:Boolean;
			
			if(currentCellValue == FOUR_DECK || currentCellValue == THREE_DECK || currentCellValue == TWO_DECK || currentCellValue == ONE_DECK)
			{
				_gameData.isHited = true;
				oponentShipsPositions[column][line] = HITED_DECK;
				
				checkingWhetherTheShipKilled(column, line, currentCellValue, COMPUTER_SIDE);
				
			}else if(currentCellValue == WATER_CELL || currentCellValue == EMPTY_CELL)
			{
				_gameData.isHited = false;
				oponentShipsPositions[column][line] = SELECTED_CELL;
				
			}else if(currentCellValue == SELECTED_CELL || currentCellValue == HITED_DECK)
				cellAlreadySelected = true;			
			
			if(_gameData.shipIsKilled)	
				setWaterAroundFullHitedShip(oponentShipsPositions, COMPUTER_SIDE, _gameData.lastHitedOponentShipPosition);				
						
			if(!cellAlreadySelected) 	
				this.sendNotification(GameEvents.MOVE_END);				
		}	
		
		/** 
		 * Cheking player battlefield if is hit.
		 * 
		 * Call checkIfShipIskill() for determinating if ship is kill.
		 * If ship is kill call setWaterAroundFullHitedShip().
		 * If selected cell is not already selected, send message about end of the step.
		 */		
		private function checkUserField():void
		{			
			trace("checkUserField");
			var toSelect:Array = new Array();			
			var userShipsPositions:Vector.<Vector.<int>> = _gameData.userBattleField;
			
			if(!_gameData.oponentShipIsHited || _gameData.findAnotherShip)
			{
				if(_gameData.findAnotherShip)	
					_gameData.findAnotherShip = false;
				
				toSelect = elementToSelect(userShipsPositions);				
			}else								
				toSelect = setNextPositionAfterHit(userShipsPositions);			
						
			var column:	int			 = _gameData.currentSelectedCell[0] = toSelect[0];
			var line:	int 		 = _gameData.currentSelectedCell[1] = toSelect[1];				
			
			var currentCellValue:int = userShipsPositions[column][line] as int, cellAlreadySelected:Boolean;	
						
			if(currentCellValue == FOUR_DECK || currentCellValue == THREE_DECK || currentCellValue == TWO_DECK || currentCellValue == ONE_DECK)
			{
				_gameData.isHited = true;
				userShipsPositions[column][line] = HITED_DECK;
				checkingWhetherTheShipKilled(column, line, currentCellValue, PLAYER_SIDE);
				
			}else if(currentCellValue == WATER_CELL || currentCellValue == EMPTY_CELL)
			{
				_gameData.isHited = false;
				userShipsPositions[column][line] = SELECTED_CELL;
				
			}else if(currentCellValue == SELECTED_CELL || currentCellValue == HITED_DECK)			
				cellAlreadySelected = true;						
			
			if(_gameData.shipIsKilled)	
				setWaterAroundFullHitedShip(userShipsPositions, PLAYER_SIDE, _gameData.lastHitedUserShipPosition);
									
			if(!cellAlreadySelected)	
				this.sendNotification(GameEvents.MOVE_END);			
		}
		
		/**
		 * Determinate if ship is kill. 
		 * @param column - position on y.
		 * @param line	 - position on x.
		 * @param deck	 - ship deck number.
		 * @param side	 - whose step is.
		 * 
		 */		
		private function checkingWhetherTheShipKilled(column:int, line:int, deck:int, side:String):void
		{
			var i:int, j:int, allShipsPosition:Vector.<Ship>, shipPosition:Vector.<Array>;
			
			if(side == COMPUTER_SIDE)
			{			
				allShipsPosition = _gameData.oponentShips[0];
				
				for (j = 0; j < allShipsPosition.length; j++) 
				{
					shipPosition = allShipsPosition[j].coordinates as Vector.<Array>;
					
					for (i = 0; i < shipPosition.length; i++) 
					{
						if(shipPosition[i][0] == column && shipPosition[i][1] == line)
						{
							setShipHitDeck(j, _gameData.infoAboutShipsDecksCom, side);													
							
							if(!_gameData.lastHitedOponentShipPosition) 
								_gameData.lastHitedOponentShipPosition = new Vector.<Array>();
							
							_gameData.lastHitedOponentShipPosition = shipPosition as Vector.<Array>;						
							return;
						}
					}	
				}						
				
			}else{
				
				allShipsPosition = _gameData.userShips[0];
				
				for (j = 0; j < allShipsPosition.length; j++) 
				{
					shipPosition = allShipsPosition[j].coordinates as Vector.<Array>;
					
					for (i = 0; i < shipPosition.length; i++) 
					{
						if(shipPosition[i][0] == column && shipPosition[i][1] == line)
						{						
							setShipHitDeck(j, _gameData.infoAboutShipsDecksPl, side);
							
							if(!_gameData.lastHitedUserShipPosition) 
								_gameData.lastHitedUserShipPosition = new Vector.<Array>();
						
							_gameData.lastHitedUserShipPosition = shipPosition;
														
							_gameData.hitedUserShipPosition.push([column, line]);
							
							if(_gameData.shipIsKilled)	
								_gameData.hitedUserShipPosition = new Array();			
						
							return;
						}
					}	
				}		
			}
		}
		
		private function setShipHitDeck(ship:int, dataShips:Array, side:String):void
		{			
			dataShips[ship]--;					
			setFullHit(dataShips[ship], side, ship);		
		}
		
		private function setFullHit(elementVal:int, side:String, ship:int):void
		{
			if(elementVal == 0)
			{
				_gameData.shipIsKilled = true;						
				changeShipsCounter(side);
				
				if(side == COMPUTER_SIDE)	_gameData.oponentShips[0][ship].drowned = true;					
				else						_gameData.userShips[0][ship].drowned  = true;				
			}
		}
		
		private function changeShipsCounter(side:String):void
		{
			if(side == COMPUTER_SIDE)	_gameData.killedOponentShipsCouter++; 
			else 						_gameData.killedUserShipsCouter++;
		}	
		
		/**
		 * Set empty cells eround killed ship. 
		 * @param vc	- player battle field.
		 * @param side	- whose step is.
		 * @param arr_t - killed ship position.
		 * 
		 */		
		private function setWaterAroundFullHitedShip(vc:Vector.<Vector.<int>>, side:String, arr_t:Vector.<Array> = null):void
		{
			var lowColumn:int, highColumn:int, lowLine:int, highLine:int;
			
			if(arr_t[0][0] - 1 >= 0) 				
				lowColumn   = arr_t[0][0] - 1; 					
			else 
				lowColumn   = 0;
						
			if(arr_t[arr_t.length - 1][0] + 1 <= 9)	
				highColumn  = arr_t[arr_t.length - 1][0] + 1;	
			else 
				highColumn  = 9;
			
			if(arr_t[0][1] - 1 >= 0)				
				lowLine 	= arr_t[0][1] - 1;					
			else 
				lowLine 	= 0;			
			
			if(arr_t[arr_t.length - 1][1] + 1 <= 9)	
				highLine 	= arr_t[arr_t.length - 1][1] + 1;	
			else 
				highLine    = 9;
						
			for (var i:int = lowColumn; i < highColumn + 1; i++) 
			{
				for (var j:int = lowLine; j < highLine + 1; j++) 
				{
					setAndSendSelectedCell(vc, side, i, j);
				}
			}				
		}	
		
		/**
		 * Send empty water position.
		 */		
		private function setAndSendSelectedCell(vc:Vector.<Vector.<int>>, side:String, column:int, line:int):void
		{
			if(vc[column][line] as int != 8 && vc[column][line] as int != 7)
			{
				vc[column][line] = 8;
				
				if(side == COMPUTER_SIDE)
				{
					this.sendNotification(GameEvents.UPDATE_OPONENT_FIELD, [false, [column, line] ]);		
					
				}else{
					
					removeFromStrategyHitedCell(column, line);
					_gameData.findAnotherShip = true;
					this.sendNotification(GameEvents.UPDATE_USER_FIELD, [false, [column, line] ]);		
				}							
			}
		}
		
		/**
		 * Remove cells of arrays with the strategy of movement. 		
		 */		
		private function removeFromStrategyHitedCell(column:int, line:int):void
		{
			if(_gameData.strategyOne.length > 0)
			{
				for (var i:int = 0; i < _gameData.strategyOne.length; i++) 
				{
					if(_gameData.strategyOne[i][0] == column && 
					   _gameData.strategyOne[i][1] == line)
					{
						_gameData.strategyOne.splice(i,1);						
						return;
					}
				}				
			}
			
			if(_gameData.strategyTwo.length > 0)
			{
				for (var k:int = 0; k < _gameData.strategyTwo.length; k++) 
				{
					if(_gameData.strategyTwo[k][0] == column && 
					   _gameData.strategyTwo[k][1] == line)
					{
						_gameData.strategyTwo.splice(k,1);		
						return;
					}
				}		
			}
			
			if(_gameData.strategyThree.length > 0)
			{
				for (var p:int = 0; p < _gameData.strategyThree.length; p++) 
				{
					if(_gameData.strategyThree[p][0] == column && 
					   _gameData.strategyThree[p][1] == line)
					{
						_gameData.strategyThree.splice(p,1);
						return;
					}
				}		
			}
		}
		
		/**
		 * Set position of cell to next hit.
		 * @param vc - player battlefield.
		 */		
		private function setNextPositionAfterHit(vc:Vector.<Vector.<int>>):Array
		{			
			var res:Array = new Array(), way:String;
			
			var arrayOfHitedCells:Array = _gameData.hitedUserShipPosition;
			var numberOfHitedCells:int = arrayOfHitedCells.length;				
			
			if(numberOfHitedCells == 3) /// sort elements in array						
				sortArray(arrayOfHitedCells);					
			
			if(numberOfHitedCells > 1)
			{
				if(arrayOfHitedCells[1][1] 		> arrayOfHitedCells[0][1])		way = RIGHT_WAY;
				else if(arrayOfHitedCells[1][1] < arrayOfHitedCells[0][1])		way = LEFT_WAY;		
				if(arrayOfHitedCells[1][0] 		> arrayOfHitedCells[0][0])		way = DOWN_WAY;			
				else if(arrayOfHitedCells[1][0] < arrayOfHitedCells[0][0])		way = UP_WAY;
			}		
			
			var arrWithPossibleNextPosition:Array = checkCellOnException(arrayOfHitedCells[0][0], arrayOfHitedCells[0][1], numberOfHitedCells, way);	
			
			/// check all possible position if they are not selected
			for (var i:int = 0; i < arrWithPossibleNextPosition.length; i++) 
			{
				var singleElement:Array = arrWithPossibleNextPosition[i];
							
				if(vc[singleElement[0]][singleElement[1]] != HITED_DECK && vc[singleElement[0]][singleElement[1]] != SELECTED_CELL)
				{
					res = singleElement;										
						
					break;						
				}
			}
			
			if(res.length == 0)
			{
				trace("!!");	
			}					
			
			trace("next: ", res);
			return res;		
		}		
		
		private function sortArray(arr:Array):void
		{			
			if(arr[0][0] == arr[1][0])			
				arr.sortOn([1], [Array.NUMERIC]);
				
			else if(arr[0][1] == arr[1][1])			
				arr.sortOn([0], [Array.NUMERIC]);				
		}
		
		/**
		 * Set combination to hit ship.
		 * @param culumn - cell on y
		 * @param line	 - cell on x
		 * @param hited_cells - number of hited cells
		 * @param way	 - direction of locating ship
		 * @return - combination of cell wich computer can select to hitn next deck on ship
		 * -------------
		 * |1|  |2|  |3|
		 * |           |
		 * |7|  |9|  |8|
		 * |		   |
		 * |4|  |5|  |6|
		 * -------------
		 */		
		private function checkCellOnException(culumn:int, line:int, hitedCells:int, way:String):Array
		{
			var res:Boolean;
			var cell:Array = new Array();
			
			if(culumn == 0 && line == 0)		//1
			{
				if(hitedCells > 1 && way)
				{					
					if(     way == RIGHT_WAY)	cell.push([culumn, 				line + hitedCells]);					
					else if(way == DOWN_WAY)	cell.push([culumn + hitedCells, line]);	
					
				}else
				{
					cell.push([culumn + 1, 	line]);
					cell.push([culumn, 	 	line + 1]);
				}				
				
			}else if(culumn == 0 && line > 0)	//2
			{
				if(hitedCells > 1 && way)
				{
					cell = usualCalculation(line, culumn, hitedCells, way);	
					
				}else if(hitedCells == 1 && way)
				{	
					if(way == RIGHT_WAY)		cell.push([culumn, line + hitedCells]);					
					else if(way == LEFT_WAY)	cell.push([culumn, line - hitedCells]);		
					else if(way == DOWN_WAY)	cell.push([culumn + hitedCells, line]);		
					
				}else
				{
					cell.push([culumn,	 	line - 1]);
					cell.push([culumn + 1,	line]);
					cell.push([culumn, 	 	line + 1]);
				}
				
			}else if(culumn == 0 && line == 9)	//3
			{
				if(hitedCells > 1 && way)
				{	
					if(way == LEFT_WAY)			cell.push([culumn, 				line - hitedCells]);					
					else if(way == DOWN_WAY)	cell.push([culumn + hitedCells, line]);	
					
				}else
				{
					cell.push([culumn, 	 line - 1]);
					cell.push([culumn + 1,line]);
				}			
				
			}else if(culumn == 9 && line == 0)	//4
			{
				if(hitedCells > 1 && way)
				{	
					if(way == RIGHT_WAY)		cell.push([culumn, 				line + hitedCells]);					
					else if(way == UP_WAY)		cell.push([culumn - hitedCells, line]);	
					
				}else
				{
					cell.push([culumn - 1, line]);
					cell.push([culumn, 	  line + 1]);
				}			
				
			}else if(culumn == 9 && line > 0)	//5
			{
				if(hitedCells > 1 && way)
				{
					cell = usualCalculation(line, culumn, hitedCells, way);	
					
				}else if(hitedCells == 1 && way)
				{		
					if(way == RIGHT_WAY)		cell.push([culumn, 				line + hitedCells]);					
					else if(way == LEFT_WAY)	cell.push([culumn, 				line - hitedCells]);	
					else if(way == UP_WAY)		cell.push([culumn - hitedCells, line]);		
					
				}else
				{						
					cell.push([culumn - 1, line]);
					cell.push([culumn, 	  line + 1]);		
					cell.push([culumn, 	  line - 1]);						
				}
				
			}else if(culumn == 9 && line == 9)	//6
			{				
				if(hitedCells > 1 && way)
				{	
					if(way == LEFT_WAY)			cell.push([culumn, 				line - hitedCells]);					
					else if(way == DOWN_WAY)	cell.push([culumn - hitedCells, line]);	
					
				}else{					
					cell.push([culumn - 1, line]);				
					cell.push([culumn, 	  line - 1]);	
				}
				
				
			}else if(culumn > 0 && line == 0)	//7
			{
				if(hitedCells > 1 && way)
				{
					cell = usualCalculation(line, culumn, hitedCells, way);	
					
				}else if(hitedCells == 1 && way)
				{
					if(way == UP_WAY)			cell.push([culumn - hitedCells, line]);					
					else if(way == DOWN_WAY)	cell.push([culumn + hitedCells, line]);	
					if(way == RIGHT_WAY)		cell.push([culumn, 				line + hitedCells]);	
					
				}else{
					
					cell.push([culumn, 		line + 1]);	
					cell.push([culumn - 1, 	line]);			
					cell.push([culumn + 1, 	line]);	
				}
				
			}else if(culumn > 0 && line == 9)	//8
			{
				if(hitedCells > 1 && way)
				{
					cell = usualCalculation(line, culumn, hitedCells, way);	
					
				}else if(hitedCells == 1 && way)
				{
					if(way == UP_WAY)			cell.push([culumn - hitedCells, line]);					
					else if(way == DOWN_WAY)	cell.push([culumn + hitedCells, line]);	
					if(way == LEFT_WAY)		cell.push([culumn, 				line - hitedCells]);	
					
				}else
				{
					cell.push([culumn, 		line - 1]);	
					cell.push([culumn - 1, 	line]);			
					cell.push([culumn + 1,	line]);	
				}			
				
				
			}else{								//9	
				
				if(hitedCells == 1)
				{					
					cell.push([culumn + 1, line]);
					cell.push([culumn - 1, line]);
					cell.push([culumn, 	  line + 1]);
					cell.push([culumn, 	  line - 1]);					
					
				}else{
					cell = usualCalculation(line, culumn, hitedCells, way);	
				}
			}
			
			if(cell[0][0] > 9)
			{
				trace("> 9");
				cell[0][0] = 9;
			}
			
			if(cell[0][1] > 9)
			{
				trace("> 9");
				cell[0][1] = 9;
			}
			
			if(cell[0][0] < 0)
			{
				trace("< 0");
				cell[0][0] = 0;
			}
			
			if(cell[0][1] < 0)
			{
				trace("< 0");
				cell[0][1] = 0;
			}
			
			return cell;
		}	
		
		private function usualCalculation(line:int, culumn:int, hitedCells:int, way:String):Array
		{
			var arr:Array = new Array();			
			
			if(way == UP_WAY)			
			{						
				arr.push([culumn - hitedCells, line]);		
				arr.push([culumn + 1,		 	line]);
			}
			else if(way == DOWN_WAY)	
			{						
				arr.push([culumn + hitedCells, line]);	
				arr.push([culumn - 1,		 	line]);
			}
			else if(way == LEFT_WAY)	
			{						
				arr.push([culumn, 				line - hitedCells]);	
				arr.push([culumn,			 	line + 1]);
			}
			else if(way == RIGHT_WAY)	
			{						
				arr.push([culumn,			 	line + hitedCells]);
				arr.push([culumn,			 	line - 1]);			
			}
			
			return arr;
		}
		
		private function elementToSelect(vc:Vector.<Vector.<int>>):Array
		{			
			var res:Array 			= new Array(), wasRemove:Boolean;		
			var strategyArray:Array = getStrategyArray();			
			var randomNumber:int    = randomElementsFromArrayWithStrategy(strategyArray);
			
			res = strategyArray[randomNumber];
			
			while(vc[res[0]][res[1]] as int == SELECTED_CELL || vc[res[0]][res[1]] as int == HITED_DECK)
			{
				if(!res)	trace("!!!");					
					
				strategyArray = getStrategyArray();				
				randomNumber  = randomElementsFromArrayWithStrategy(strategyArray);
					
				res = strategyArray[randomNumber];
					
				if(strategyArray.length > 0)
				{			
					wasRemove = true;
					strategyArray.splice(randomNumber, 1);			
				}
			}	
						
			
			if(strategyArray.length > 0 && !wasRemove)	strategyArray.splice(randomNumber, 1);	
			
			if(!res)
			{
				trace("!!!");
			}
			
			return res;
		}
		
		private function randomElementsFromArrayWithStrategy(arr:Array):int
		{
			var res:int = Math.random()*arr.length;	
			return res;
		}
		
		private function getStrategyArray():Array
		{
			var res:Array = new Array();
			
			if(_gameData.strategyOne.length > 0)			res = _gameData.strategyOne;				
			else if(_gameData.strategyTwo.length > 0)		res = _gameData.strategyTwo;				
			else if(_gameData.strategyThree.length > 0)	res = _gameData.strategyThree;
					
			return res;
		}
		
		/**
		 * Correct field range for array 10x10. 		
		 */		
		private function correctRange(val:int):int
		{
			var res:int;			
			if(val > 9 ) res = 9; else if(val < 0)	res = 0; else res = val;			
			return res;			
		}
		
		private function saveGameData(val:Object):void
		{
			_gameData = val as FullGameData;			
		}
		
		private function removeGameData():void
		{
			_gameData = null;			
		}
		
		public override function listNotificationInterests():Array
		{
			return [
				GameEvents.INIT_COMPTER_LOGIC,				
				GameEvents.GET_GAME_DATA,
				GameEvents.SHOW_PLAYER_MOVE,
				GameEvents.SHOW_COM_MOVE,
				GameEvents.SHOW_MENU_PAGE
			];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{				
				case GameEvents.INIT_COMPTER_LOGIC:
				{
					initiaization();			
					break;
				}
					
				case GameEvents.SHOW_PLAYER_MOVE:
				{
					checkOponentField();
					break;
				}
					
				case GameEvents.SHOW_COM_MOVE:
				{
					checkUserField();
					break;
				}
					
				case GameEvents.GET_GAME_DATA:
				{
					saveGameData(notification.getBody());
					break;
				}
			
				case GameEvents.SHOW_MENU_PAGE:
				{
					removeGameData();
				}
			}
		}
	}
}