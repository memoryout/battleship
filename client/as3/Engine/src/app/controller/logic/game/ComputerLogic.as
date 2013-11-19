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
		private function checkForHitComputerField():void
		{		
			var column:int 	= correctRange(_gameData.currentSelectedCell[0]);
			var line:int 	= correctRange(_gameData.currentSelectedCell[1]);
		
			var comShipsPositions:Vector.<Vector.<int>> = _gameData.enemyBattleField;
			
			var cellAlreadySelected:Boolean;
			
			var currentCellValue:int = comShipsPositions[column][line] as int;
			
			if(currentCellValue == 4 || currentCellValue == 3 || currentCellValue == 2 || currentCellValue == 1)
			{
				_gameData.isHited = true;
				comShipsPositions[column][line] = 7;
				
				checkIfShipIskill(column, line, currentCellValue, "computer");
				
			}else if(currentCellValue == 9 || currentCellValue == 0)
			{
				_gameData.isHited = false;
				comShipsPositions[column][line] = 8;
				
			}else if(currentCellValue == 8 || currentCellValue == 7)
			{
				cellAlreadySelected = true;
			}
			
			if(_gameData.shipIsKill)	setWaterAroundFullHitedShip(comShipsPositions, "computer", _gameData.lastHitShipPositionCom);				
						
			if(!cellAlreadySelected) 	this.sendNotification(GameEvents.MOVE_END);				
		}	
		
		/** 
		 * Cheking player battlefield if is hit.
		 * 
		 * Call checkIfShipIskill() for determinating if ship is kill.
		 * If ship is kill call setWaterAroundFullHitedShip().
		 * If selected cell is not already selected, send message about end of the step.
		 */		
		private function checkForHitPlayerField(e:TimerEvent = null):void
		{				
			var toSelect:Array = new Array();			
			var plShipsPositions:Vector.<Vector.<int>> = _gameData.userBattleField;
			
			if(!_gameData.oponentShipIsHit || _gameData.findAnotherShip)
			{
				if(_gameData.findAnotherShip)	_gameData.findAnotherShip = false;
				
				toSelect = elementToSelect(plShipsPositions);				
			
			}else{
								
				toSelect = setNextPositionAfterHit(plShipsPositions);
			}
					
			var cellAlreadySelected:Boolean;			
			
			var column:	int			 = _gameData.currentSelectedCell[0] = toSelect[0];
			var line:	int 		 = _gameData.currentSelectedCell[1] = toSelect[1];				
			
			var currentCellValue:int = plShipsPositions[column][line] as int;
						
			if(currentCellValue == 4 || currentCellValue == 3 || currentCellValue == 2 || currentCellValue == 1)
			{
				_gameData.isHited = true;
				plShipsPositions[column][line] = 7;
				checkIfShipIskill(column, line, currentCellValue, "Player");
				
			}else if(currentCellValue == 9 || currentCellValue == 0)
			{
				_gameData.isHited = false;
				plShipsPositions[column][line] = 8;
				
			}else if(currentCellValue == 8 || currentCellValue == 7)
			{
				cellAlreadySelected = true;
			}			
			
			if(_gameData.shipIsKill)	setWaterAroundFullHitedShip(plShipsPositions, "player", _gameData.lastHitShipPositionPl);
									
			if(!cellAlreadySelected)	this.sendNotification(GameEvents.MOVE_END);			
		}
		
		/**
		 * Determinate if ship is kill. 
		 * @param column - position on y.
		 * @param line	 - position on x.
		 * @param deck	 - ship deck number.
		 * @param side	 - whose step is.
		 * 
		 */		
		private function checkIfShipIskill(column:int, line:int, deck:int, side:String):void
		{
			if(side == "computer")
			{			
				var allShipsPosition:Vector.<Ship> = _gameData.enemyShips[0];
				
				for (var j:int = 0; j < allShipsPosition.length; j++) 
				{
					var arr:Array = allShipsPosition[j].coordinates as Array;
					
					for (var i:int = 0; i < arr.length; i++) 
					{
						if(arr[i][0] == column && arr[i][1] == line)
						{
							setShipHitDeck(j, _gameData.infoAboutShipsDecksCom, side);													
							
							if(!_gameData.lastHitShipPositionCom) _gameData.lastHitShipPositionCom = new Array();
							
							_gameData.lastHitShipPositionCom = arr;						
							return;
						}
					}	
				}						
				
			}else{
				
				var allShipsPositionP:Vector.<Ship> = _gameData.userShips[0];
				
				for (var n:int = 0; n < allShipsPositionP.length; n++) 
				{
					var arrP:Array = allShipsPositionP[n].coordinates as Array;
					
					for (var t:int = 0; t < arrP.length; t++) 
					{
						if(arrP[t][0] == column && arrP[t][1] == line)
						{						
							setShipHitDeck(n, _gameData.infoAboutShipsDecksPl, side);
							
							if(!_gameData.lastHitShipPositionPl) _gameData.lastHitShipPositionPl = new Array();
							_gameData.lastHitShipPositionPl = arrP;
																				
							var _arr:Array = new Array();
							_arr.push(column);
							_arr.push(line);
							
							_gameData.hitedPlayerShipPosition.push(_arr);
							
							if(_gameData.shipIsKill)	_gameData.hitedPlayerShipPosition = new Array();			
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
				_gameData.shipIsKill = true;						
				changeShipsCounter(side);
				
				if(side == "computer")	_gameData.enemyShips[0][ship].drowned = true;					
				else					_gameData.userShips[0][ship].drowned  = true;				
			}
		}
		
		private function changeShipsCounter(side:String):void
		{
			if(side == "computer")	_gameData.killedShipsCouterCom++; 
			else 					_gameData.killedShipsCouterPl++;
		}	
		
		/**
		 * Set empty cells eround killed ship. 
		 * @param vc	- player battle field.
		 * @param side	- whose step is.
		 * @param arr_t - killed ship position.
		 * 
		 */		
		private function setWaterAroundFullHitedShip(vc:Vector.<Vector.<int>>, side:String, arr_t:Array = null):void
		{
			var low_column:int, high_column:int, low_line:int, high_line:int;
			
			if(arr_t[0][0] - 1 >= 0) 				low_column  = arr_t[0][0] - 1; 					else low_column  = 0;
						
			if(arr_t[arr_t.length - 1][0] + 1 <= 9)	high_column = arr_t[arr_t.length - 1][0] + 1;	else high_column = 9;
			
			if(arr_t[0][1] - 1 >= 0)				low_line 	= arr_t[0][1] - 1;					else low_line 	 = 0;			
			
			if(arr_t[arr_t.length - 1][1] + 1 <= 9)	high_line 	= arr_t[arr_t.length - 1][1] + 1;	else high_line   = 9;
						
			for (var i:int = low_column; i < high_column + 1; i++) 
			{
				for (var j:int = low_line; j < high_line + 1; j++) 
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
				
				if(side == "computer")
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
			if(_gameData.strategyArrayOne.length > 0)
			{
				for (var i:int = 0; i < _gameData.strategyArrayOne.length; i++) 
				{
					if(_gameData.strategyArrayOne[i][0] == column && 
					   _gameData.strategyArrayOne[i][1] == line)
					{
						_gameData.strategyArrayOne.splice(i,1);						
						return;
					}
				}				
			}
			
			if(_gameData.strategyArrayTwo.length > 0)
			{
				for (var k:int = 0; k < _gameData.strategyArrayTwo.length; k++) 
				{
					if(_gameData.strategyArrayTwo[k][0] == column && 
					   _gameData.strategyArrayTwo[k][1] == line)
					{
						_gameData.strategyArrayTwo.splice(k,1);		
						return;
					}
				}		
			}
			
			if(_gameData.strategyArrayThree.length > 0)
			{
				for (var p:int = 0; p < _gameData.strategyArrayThree.length; p++) 
				{
					if(_gameData.strategyArrayThree[p][0] == column && 
					   _gameData.strategyArrayThree[p][1] == line)
					{
						_gameData.strategyArrayThree.splice(p,1);
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
			
			var arrayOfHitedCells:Array = _gameData.hitedPlayerShipPosition;
			var numberOfHitedCells:int = arrayOfHitedCells.length;				
			
			if(numberOfHitedCells > 1)
			{
				if(arrayOfHitedCells[1][1] 		> arrayOfHitedCells[0][1])		way = "right";
				else if(arrayOfHitedCells[1][1] < arrayOfHitedCells[0][1])		way = "left";		
				if(arrayOfHitedCells[1][0] 		> arrayOfHitedCells[0][0])		way = "down";			
				else if(arrayOfHitedCells[1][0] < arrayOfHitedCells[0][0])		way = "up";
			}		
			
			var arrWithPossibleNextPosition:Array = checkCellOnException(arrayOfHitedCells[0][0], arrayOfHitedCells[0][1], numberOfHitedCells, way);	
		
			/// check all possible position if they are not selected
			for (var i:int = 0; i < arrWithPossibleNextPosition.length; i++) 
			{
				var singleElement:Array = arrWithPossibleNextPosition[i];
				
				if(vc[singleElement[0]][singleElement[1]] != 8 && vc[singleElement[0]][singleElement[1]] != 7)
				{
					res = singleElement;
					break;
				}
			}				
			return res;		
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
		private function checkCellOnException(culumn:int, line:int, hited_cells:int, way:String):Array
		{
			var res:Boolean;
			var arr:Array = new Array();
			
			if(culumn == 0 && line == 0)		//1
			{
				if(hited_cells > 1)
				{					
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
				}
							
				arr.push([culumn + 1, 	line]);
				arr.push([culumn, 	 	line + 1]);
				
			}else if(culumn == 0 && line > 0)	//2
			{
				if(hited_cells == 1)
				{	
					if(way == "right")		arr.push([culumn, line + hited_cells]);					
					else if(way == "left")	arr.push([culumn, line - hited_cells]);		
					else if(way == "down")	arr.push([culumn + hited_cells, line]);		
				}
				
				arr.push([culumn,	 	line - 1]);
				arr.push([culumn + 1,	line]);
				arr.push([culumn, 	 	line + 1]);
				
			}else if(culumn == 0 && line == 9)	//3
			{
				if(hited_cells == 1)
				{	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
				}
				
				arr.push([culumn, 	 line - 1]);
				arr.push([culumn + 1,line]);
				
			}else if(culumn == 9 && line == 0)	//4
			{
				if(hited_cells == 1)
				{	
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);					
					else if(way == "up")	arr.push([culumn - hited_cells, line]);	
				}
				
				arr.push([culumn - 1, line]);
				arr.push([culumn, 	  line + 1]);
				
			}else if(culumn == 9 && line > 0)	//5
			{
				if(hited_cells > 1)
				{		
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);					
					else if(way == "left")	arr.push([culumn, 				line - hited_cells]);	
					else if(way == "up")	arr.push([culumn - hited_cells, line]);		
				}
				
				arr.push([culumn - 1, line]);
				arr.push([culumn, 	  line + 1]);		
				arr.push([culumn, 	  line - 1]);	
				
			}else if(culumn == 9 && line == 9)	//6
			{				
				if(hited_cells == 1)
				{	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);					
					else if(way == "down")	arr.push([culumn - hited_cells, line]);	
				}
				
				arr.push([culumn - 1, line]);				
				arr.push([culumn, 	  line - 1]);	
				
			}else if(culumn > 0 && line == 0)	//7
			{
				if(hited_cells == 1)
				{
					if(way == "up")			arr.push([culumn - hited_cells, line]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
					if(way == "right")		arr.push([culumn, 				line + hited_cells]);	
				}
				
				arr.push([culumn, 		line + 1]);	
				arr.push([culumn - 1, 	line]);			
				arr.push([culumn + 1, 	line]);	
				
			}else if(culumn > 0 && line == 9)	//8
			{
				if(hited_cells == 1)
				{
					if(way == "up")			arr.push([culumn - hited_cells, line]);					
					else if(way == "down")	arr.push([culumn + hited_cells, line]);	
					if(way == "left")		arr.push([culumn, 				line - hited_cells]);	
				}
				
				arr.push([culumn, 		line - 1]);	
				arr.push([culumn - 1, 	line]);			
				arr.push([culumn + 1,	line]);	
				
			}else{								//9	
				
				if(hited_cells == 1)
				{					
					arr.push([culumn + 1, line]);
					arr.push([culumn - 1, line]);
					arr.push([culumn, 	  line + 1]);
					arr.push([culumn, 	  line - 1]);					
				
				}else{
					
					if(way == "up")			
					{						
						arr.push([culumn - hited_cells, line]);		
						arr.push([culumn + 1,		 	line]);
					}
					else if(way == "down")	
					{						
						arr.push([culumn + hited_cells, line]);	
						arr.push([culumn - 1,		 	line]);
					}
					else if(way == "left")	
					{						
						arr.push([culumn, 				line - hited_cells]);	
						arr.push([culumn,			 	line + 1]);
					}
					else if(way == "right")	
					{						
						arr.push([culumn,			 	line + hited_cells]);
						arr.push([culumn,			 	line - 1]);
					}				
				}
			}
			
			return arr;
		}						
		
		private function elementToSelect(vc:Vector.<Vector.<int>>):Array
		{			
			var res:Array 			= new Array(), wasRemove:Boolean;		
			var strategyArray:Array = getStrategyArray();			
			var randomNumber:int    = randomElementsFromArrayWithStrategy(strategyArray);		
			
			res = strategyArray[randomNumber];
					
			while(vc[res[0]][res[1]] as int == 8 || vc[res[0]][res[1]] as int == 7)
			{
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
			
			if(_gameData.strategyArrayOne.length > 0)			res = _gameData.strategyArrayOne;				
			else if(_gameData.strategyArrayTwo.length > 0)		res = _gameData.strategyArrayTwo;				
			else if(_gameData.strategyArrayThree.length > 0)	res = _gameData.strategyArrayThree;
					
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
					checkForHitComputerField();
					break;
				}
					
				case GameEvents.SHOW_COM_MOVE:
				{
					checkForHitPlayerField();
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