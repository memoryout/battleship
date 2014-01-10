package app.view.components.game
{
	import app.model.game.Ship;

	public class ShipsLocationProcess
	{
		private var shipsArray:				Vector.<Vector.<int>>;
		private var shipsLocation:			Vector.<Ship>;
		private var shipPosition:			Vector.<Array>;
		
		private var dragedShipsOldPosition:	Array 	 				= new Array();	
		public  var dataForRotate		  :	Object 	 				=		
			{
				"column":0, "line":0, "orient":0, "deck":0
			};
		
		public function ShipsLocationProcess(){}	
		
		public function resetShipLocation(column:int, line:int, orient:int, deckNumber:int):void
		{
			var increment:Boolean, lineRanges:Array, columnRanges:Array, i:int, j:int;
			
			if(orient == 1)
			{	
				if( (10 - column - deckNumber ) >= 0 )	increment = true;
				
				lineRanges   = setRange(line, 1, increment);			
				columnRanges = setRange(column, deckNumber, increment);						
				
				for (j = lineRanges[0]; j < lineRanges[1] + 1; j++) 
				{
					for (i = columnRanges[0]; i < columnRanges[1] + 1; i++) 
					{
						shipsArray[i][j] = 0;
					}
				}					
			}else
			{
				if( (10 - line - deckNumber ) >= 0 )	increment = true;				
				
				lineRanges   = setRange(line, deckNumber, increment);			
				columnRanges = setRange(column, 1, increment);					
				
				for (j = columnRanges[0]; j < columnRanges[1] + 1; j++) 
				{
					for (i = lineRanges[0]; i < lineRanges[1] + 1; i++) 
					{
						shipsArray[j][i] = 0;					
					}
				}	
			}
		}
		
		public function updateShipsLocationWithoutDraged(column:int, line:int):void
		{
			for (var i:int = 0; i < shipsLocation.length; i++) 
			{			
				if(column == shipsLocation[i].column && line == shipsLocation[i].line){}
				else 
				{						
					putShipInBattleField(shipsLocation[i].column, shipsLocation[i].line, shipsLocation[i].direction, shipsLocation[i].deck);						
				}											
			}		
		}
		
		public function checkShipField(column:int, line:int, orient:int, deckNumber:int):Boolean
		{
			var res:Boolean, resCouter:int, i:int;
			
			if(orient == 1)
			{				
				if( (10 - column - deckNumber ) >= 0 )
				{
					for (i = column; i < column + deckNumber; i++) 
					{
						if(shipsArray[i][line] == 0)	resCouter++;
					}	
					
				}else{
					
					for (i = column; i > column - deckNumber; i--) 
					{
						if(shipsArray[i][line] == 0)	resCouter++;
					}
				}
				
			}else
			{						
				if( (10 - line - deckNumber ) >= 0 )
				{
					for (i = line; i < line + deckNumber; i++) 
					{
						if(shipsArray[column][i] == 0)	resCouter++;
					}
					
				}else{
					
					for (i = line; i > line - deckNumber; i--) 
					{
						if(shipsArray[column][i] == 0)	resCouter++;
					}					
				}				
			}
			
			if(resCouter == deckNumber) res = true;
			
			return res;
		}
		
		public function putShipInBattleField(column:int, line:int, orient:int, deckNumber:int, saveShipLocation:Boolean = false):void
		{
			var increment:Boolean, i:int, lineRanges:Array, columnRanges:Array, j:int;
			shipPosition = new Vector.<int>;
			
			if(orient == 1)
			{				
				if( (10 - column - deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = column; i < column + deckNumber; i++) 
					{
						if(shipsArray[i][line] == 0)	
						{
							shipsArray[i][line] = deckNumber;
							saveShipCoordinates(i, line, true);	
						}
					}										
					
				}else{
					
					for (i = column; i > column - deckNumber; i--) 
					{
						if(shipsArray[i][line] == 0)
						{
							shipsArray[i][line] = deckNumber;		
							saveShipCoordinates(i, line, true);	
						}
					}
				}
						
				lineRanges 		= setRange(line, 1 , increment);			
				columnRanges 	= setRange(column, deckNumber , increment);						
				
				for (j = lineRanges[0]; j < lineRanges[1] + 1; j++) 
				{
					for (i = columnRanges[0]; i < columnRanges[1] + 1; i++) 
					{
						if(shipsArray[i][j] == 0)	shipsArray[i][j] = 9;							
					}
				}	
				
			}else
			{					
				if( (10 - line - deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = line; i < line + deckNumber; i++) 
					{
						if(shipsArray[column][i] == 0)
						{
							shipsArray[column][i] = deckNumber;
							saveShipCoordinates(column, i, true);	
						}
					}
					
				}else{
					
					for (i = line; i > line - deckNumber; i--) 
					{
						if(shipsArray[column][i] == 0)
						{
							shipsArray[column][i] = deckNumber;			
							saveShipCoordinates(column, i, true);	
						}
					}					
				}	
									
				lineRanges 		= setRange(line, deckNumber , increment);			
				columnRanges 	= setRange(column, 1 , increment);						
				
				for (j = columnRanges[0]; j < columnRanges[1] + 1; j++) 
				{
					for (i = lineRanges[0]; i < lineRanges[1] + 1; i++) 
					{
						if(shipsArray[j][i] == 0)	shipsArray[j][i] = 9;										
					}
				}	
			}
			
			if(saveShipLocation) updateShipLocation(column, line, orient);
		}
		
		private function saveShipCoordinates(_column:int, _line:int, _moveToTheEnd:Boolean):void
		{		
			if(_moveToTheEnd)	shipPosition.push([_column, _line]);
			else				shipPosition.unshift([_column, _line]);
		}
		
		private function updateShipLocation(column:int, line:int, orient:int):void
		{
			for (var i:int = 0; i < shipsLocation.length; i++) 
			{
				if(shipsLocation[i].column == shipsOldPosition[0] && shipsLocation[i].line == shipsOldPosition[1]) 
				{
					shipsLocation[i].column 		= column;
					shipsLocation[i].line 			= line;
					shipsLocation[i].direction 		= orient;
					shipsLocation[i].coordinates 	= shipPosition;
					return;
				}
			}			
		}
		
		private function setRange(cell:int, deck:int, increment:Boolean):Array
		{
			var lowRange:int, highRange:int;
			var res:Array = new Array();		
			
			if(cell == 0)
			{
				lowRange = 0;
				highRange = cell + deck;
				
			}else if(cell + deck >= 9)
			{			
				if(cell + deck >= 9)	lowRange = cell - 1;				
				else					lowRange = cell - deck;
							
				highRange = 9;
				
			}else
			{
				if(increment)
				{
					lowRange = cell - 1;
					highRange = cell + deck;					
				}else{
					
					lowRange  = cell - deck;
					highRange = cell + 1;
				}
			}		
				
			res.push(lowRange);
			res.push(highRange);			
			return 	res;
		}		
		
		public function traceShipsArray(key:String = " "):void
		{
			trace("--------");			
			trace(key);			
			for (var i:int = 0; i < shipsArray.length; i++) 
			{ 				
 				trace(addSign(shipsArray[i][0]),"| |", addSign(shipsArray[i][1]),"| |", addSign(shipsArray[i][2]),"| |", addSign(shipsArray[i][3]),"| |", addSign(shipsArray[i][4]),"| |", addSign(shipsArray[i][5]),"| |", addSign(shipsArray[i][6]),"| |", addSign(shipsArray[i][7]),"| |", addSign(shipsArray[i][8]),"| |", addSign(shipsArray[i][9]));				
			}
		}
		
		private function addSign(val:Object):String
		{
			var res:String;			
			if(val == 0) 		res = " " + "-" + " ";			
			else if(val == 9)	res = "." + val.toString() + ".";
			else				res = "+" + val.toString() + "+";			
			return res;
		}
		
		public function canRotate(column:int, line:int, orient:int, deckNumber:int):Boolean
		{
			var res:Boolean;	
			if(line + deckNumber - 1 < 10 && checkShipField(column, line, orient, deckNumber))	res = true;						
			return res;
		}
		
		public function correctRange(val:int):int
		{
			var res:int;			
			if(val > 9 ) res = 9; else if(val < 0) res = 0; else res = val;			
			return res;			
		}
		
		public function correctRangeForMoving(val:int, deck:int):int
		{
			var res:int;		
			
			if(deck == 1)
			{
				if(val > 9 )		res = 9; 
				else if(val < 0) 	res = 0;
				else 				res = val;				
			
			}else{
				
				if(val + (deck - 1) > 9 )		res = 10 - deck; 
				else if(val < 0) 	res = 0;
				else 				res = val;				
			}
			return res;			
		}
		
		public function set shipsInArray(vc:Vector.<Vector.<int>>):void
		{
			shipsArray = vc;		
		}
		
		public function get shipsInArray():Vector.<Vector.<int>>
		{
			return shipsArray;
		}
		
		public function set shipsLocationArray(vc:Vector.<Ship>):void
		{
			shipsLocation = vc;		
		}
		
		public function get shipsLocationArray():Vector.<Ship>
		{
			return shipsLocation;
		}	
		
		public function set shipsOldPosition(arr:Array):void
		{
			dragedShipsOldPosition = arr;
		}
		public function get shipsOldPosition():Array
		{
			return dragedShipsOldPosition;
		}
		
		public function destroy():void
		{
			if(shipsArray)				shipsArray = null;
			if(shipsLocation)			shipsLocation = null;
			if(shipPosition)			shipPosition = null;
			if(dragedShipsOldPosition)	dragedShipsOldPosition = null;			
		}
	}
}