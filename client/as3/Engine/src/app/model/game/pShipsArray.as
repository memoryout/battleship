package app.model.game
{
	import org.puremvc.patterns.proxy.Proxy;

	public class pShipsArray extends Proxy
	{
		public static const NAME:			String = "pShipsArray";
			
		private var battleField:	Vector.<Vector.<int>>;
		private var Ships:			Vector.<Ship>;		
		private var shipPosition:	Array;
		
		private var oneDeckShip		:int = 4;
		private var twoDeckShip		:int = 3;
		private var threeDeckShip	:int = 2;
		private var forDeckShip		:int = 1;		
		
		public function pShipsArray(proxyName:String = null, data:Object=null)
		{
			super(NAME, data);				
		}	
		
		public function getShipsPosition():Vector.<Vector.<Ship>>
		{		
			initVariables();
			fillBattleField();
			
			var res:Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
			res.push(Ships);				
			return res;
		}
		
		public function getBattleField():Vector.<Vector.<int>>
		{	
			var res:Vector.<Vector.<int>> = new Vector.<Vector.<int>>;				
			res = battleField;			
			return res;
		}		
		
		private function initVariables():void
		{
			oneDeckShip 	= 4;
			twoDeckShip 	= 3;
			threeDeckShip 	= 2;
			forDeckShip		= 1;
			
			battleField		= new Vector.<Vector.<int>>;
			Ships 			= new Vector.<Ship>;	
			shipPosition	= new Array();			
		
			for (var i2:int = 0; i2 < 10; i2++) 
			{
				battleField[i2] = new Vector.<int>(10, false);
			}					
		}
		
		private function fillBattleField():void
		{
			var column:	int, line:int, orient:int;	
			
			while(forDeckShip > 0)
			{
				column = createRandomNumber(10);
				line   = createRandomNumber(10);
				orient = createRandomNumber(2);		
				
				if(	checkBattleField( column, line, orient, 4) )
				{					
					putShipInBattleField(column, line, orient, 4);					
					saveDataAboutShipLocation(orient, 4);					
					forDeckShip--;
				}
			}
			
			while(threeDeckShip > 0)
			{
				column = createRandomNumber(10);
				line   = createRandomNumber(10);
				orient = createRandomNumber(2);
				
				if(	checkBattleField( column, line, orient, 3) )
				{
					putShipInBattleField(column, line, orient, 3);
					saveDataAboutShipLocation(orient, 3);					
					threeDeckShip--;
				}
			}	
			
			while(twoDeckShip > 0)
			{
				column = createRandomNumber(10);
				line   = createRandomNumber(10);
				orient = createRandomNumber(2);
				
				if(	checkBattleField( column, line, orient, 2) )
				{
					putShipInBattleField(column, line, orient, 2);
					saveDataAboutShipLocation(orient, 2);								
					twoDeckShip--;
				}
			}
			
			while(oneDeckShip > 0)
			{
				column = createRandomNumber(10);
				line   = createRandomNumber(10);
				orient = createRandomNumber(2);
				
				if(	checkBattleField( column, line, orient, 1) )
				{
					putShipInBattleField(column, line, orient, 1);
					saveDataAboutShipLocation(orient, 1);							
					oneDeckShip--;
				}
			}
			
			traceShipsArray();
			trace("----------------------------");
		}
		
		private function saveDataAboutShipLocation(orient:int, deck:int):void
		{
			var _ship:Ship 		= new Ship();
			_ship.column 		= shipPosition[0][0];
			_ship.line 			= shipPosition[0][1];
			_ship.orient 		= orient;
			_ship.deck 			= deck;					
			_ship.coordinates 	= shipPosition;						
			
			Ships.push(_ship);
		}
		
		private function checkBattleField(column:int, line:int, orient:int, deckNumber:int):Boolean
		{
			var res:Boolean, resCouter:int, i:int;
			
			if(orient == 1)
			{				
				if( (9 - column - deckNumber ) >= 0 )
				{
					for (i = column; i < column + deckNumber; i++) 
					{
						if(battleField[i][line] == 0)		resCouter++;
					}	
					
				}else{
					
					for (i = column; i > column - deckNumber; i--) 
					{
						if(battleField[i][line] == 0)		resCouter++;
					}
				}
				
			}else
			{						
				if( (9 - line - deckNumber ) >= 0 )
				{
					for (i = line; i < line + deckNumber; i++) 
					{
						if(battleField[column][i] == 0)		resCouter++;
					}
					
				}else{
					
					for (i = line; i > line - deckNumber; i--) 
					{
						if(battleField[column][i] == 0)		resCouter++;
					}					
				}				
			}
			
			if(resCouter == deckNumber) res = true;
			
			return res;
		}
		
		private function putShipInBattleField(column:int, line:int, orient:int, deckNumber:int):void
		{
			var increment:Boolean, i:int, j:int, lineRanges:Array, columnRanges:Array;		
			shipPosition = new Array();	
						
			if(orient == 1)
			{				
				if( (9 - column - deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = column; i < column + deckNumber; i++) 
					{
						if(battleField[i][line] == 0)
						{
							battleField[i][line] = deckNumber;
							saveShipCoordinates(i, line, true);	
						}
					}											
				}else{
					
					for (i = column; i > column - deckNumber; i--) 
					{
						if(battleField[i][line] == 0)
						{
							battleField[i][line] = deckNumber;
							saveShipCoordinates(i, line, false);												
						}
					}
				}				
				
				/// fill water around ships				
				lineRanges 	 = setRange(line, 1 , increment);			
				columnRanges = setRange(column, deckNumber , increment);					
				
				for (j = lineRanges[0]; j < lineRanges[1] + 1; j++) 
				{
					for (i = columnRanges[0]; i < columnRanges[1] + 1; i++) 
					{
						if(battleField[i][j] == 0)	battleField[i][j] = 9;										
					}
				}	
				
			}else
			{						
				if( (9 - line - deckNumber ) >= 0 )
				{
					increment = true;
					
					for (i = line; i < line + deckNumber; i++) 
					{
						if(battleField[column][i] == 0)
						{
							battleField[column][i] = deckNumber;
							saveShipCoordinates(column, i, true);							
						}
					}					
				}else{
					
					for (i = line; i > line - deckNumber; i--) 
					{
						if(battleField[column][i] == 0)
						{
							battleField[column][i] = deckNumber;
							saveShipCoordinates(column, i, false);									
						}
					}					
				}					
				
				/// fill water around ships				
				lineRanges 	 = setRange(line, deckNumber , increment);			
				columnRanges = setRange(column, 1 , increment);					
				
				for (j = columnRanges[0]; j < columnRanges[1] + 1; j++) 
				{
					for (i = lineRanges[0]; i < lineRanges[1] + 1; i++) 
					{
						if(battleField[j][i] == 0)	battleField[j][i] = 9;
					}
				}	
			}			
		}
		
		private function saveShipCoordinates(column:int, line:int, d:Boolean):void
		{
			var singlePosition:Array = new Array();							
			singlePosition.push(column);
			singlePosition.push(line);				
			
			if(d)	shipPosition.push(singlePosition);
			else	shipPosition.unshift(singlePosition);
		}
		
		private function setRange(column:int, deck:int, increment:Boolean):Array
		{
			var lowRange:int, highRange:int;
			
			if(column == 0)
			{
				lowRange = 0;
				highRange = column + deck;
				
			}else if(column == 9)
			{
				lowRange = column - deck;
				highRange = 9;
				
			}else
			{
				if(increment)
				{
					lowRange = column - 1;
					highRange = column + deck;
					
				}else{
					
					lowRange  = column - deck;
					highRange = column + 1;
				}
			}
			
			var res:Array = new Array();			
			res.push(lowRange);
			res.push(highRange);			
			return 	res;
		}
		
		private function traceShipsArray():void
		{
			for (var i:int = 0; i < battleField.length; i++) 
			{ 
				trace(battleField[i][0],"| |", battleField[i][1],"| |",battleField[i][2],"| |",battleField[i][3],"| |",battleField[i][4],"| |",battleField[i][5],"| |",battleField[i][6],"| |",battleField[i][7],"| |",battleField[i][8],"| |",battleField[i][9]);				
			}			
		}
		
		private function createRandomNumber(range:int):int
		{			
			var res:int = Math.random()*range;			
			return res;
		}
		
		public function cleanData():void
		{
			if(battleField)		battleField = null;
			if(Ships) 			Ships = null;
			if(shipPosition) 	shipPosition = null;			
		}
	}
}