package app.view.components.game
{
	import app.model.game.FullGameData;
	import app.model.game.Ship;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class GameUi extends Sprite
	{
		private const cellSize:				Number = 27;
		private const cellSizeC:			Number = 73.5;
		
		private var _model:					mGame;		
						
		private var selectedCell:			MovieClip;		
		private var viewGameWindow:			MovieClip;
		private var playerField:			MovieClip;
		private var oponentField:			MovieClip;		
		private var currentDragedElement:	MovieClip;
		private var elementForRotation:		MovieClip;
			
		private var menuButton:				SimpleButton;		
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;			
		public  var list:					Boolean;
			
		public function GameUi(med:mGame=null)
		{			
			super();
			
			_model = med as mGame;
			
			addLinks();			
		}
		
		private function addLinks():void
		{
			viewGameWindow = new viewGame();
			addChild(viewGameWindow);	
			
			playerField 	= viewGameWindow.getChildByName("player_field") 	as MovieClip;
			oponentField 	= viewGameWindow.getChildByName("oponent_field") 	as MovieClip;			
					
			menuButton		= viewGameWindow.getChildByName("btn_menu") 		as SimpleButton;	
		}
		
		public function addListeners():void
		{
			list = true;
			menuButton.addEventListener(MouseEvent.MOUSE_DOWN, 	goToMenu);				
			oponentField.addEventListener(MouseEvent.MOUSE_UP,	oponentsFieldClick);		
		}
		
		public function removeListeners():void
		{
			list = false;
			menuButton.removeEventListener(MouseEvent.MOUSE_DOWN, 	goToMenu);				
			oponentField.removeEventListener(MouseEvent.MOUSE_UP,	oponentsFieldClick);		
		}
		
		public function setPlayerShipsPosition(val:Object, showRes:Boolean = false):void
		{				
			for (var j:int = 0; j < _model._userShips[0].length; j++) 
			{
				locateShip(_model._userShips[0][j].column, _model._userShips[0][j].line, _model._userShips[0][j].direction, _model._userShips[0][j].deck, j);
			}
						
			if(_model._gameStatus != 0) restoreView();							
		}
		
		private function restoreView():void
		{
			checkForDrownedShips();
			setSelectedelements();
		}
		
		private function setSelectedelements():void
		{
			for (var i:int = 0; i < _model._userBattlefield.length; i++) 
			{
				for (var k:int = 0; k < _model._userBattlefield[i].length; k++) 
				{
					if(_model._userBattlefield[i][k] == 8) 		setSelectedPlayerCell([false, [i, k], null], true, false);
					else if(_model._userBattlefield[i][k] == 7)	setSelectedPlayerCell([true,  [i, k], null], false, false);
				}				
			}
			
			for (var j:int = 0; j < _model._oponentBattlefield.length; j++) 
			{
				for (var l:int = 0; l < _model._oponentBattlefield[j].length; l++) 
				{
					if(_model._oponentBattlefield[j][l] == 8) 		setSelectedOponentCell([false, [j, l], null], true, false);
					else if(_model._oponentBattlefield[j][l] == 7)	setSelectedOponentCell([true,  [j, l], null], false, false);
				}
			}
		}
		
		private function checkForDrownedShips():void
		{
			if(_model._userShips)
			{
				for (var i:int = 0; i < _model._userShips[0].length; i++) 
				{
					if( _model._userShips[0][i].drowned)	showDrownedShips(_model._userShips[0][i], "player");				
				}
			}
			
			if(_model._oponentShips && _model._oponentShips.length)
			{
				for (var j:int = 0; j < _model._oponentShips[0].length; j++) 
				{
					if(_model._oponentShips[0][j] && _model._oponentShips[0][j].drowned)	showDrownedShips(_model._oponentShips[0][j], "enemy");					
				}
			}						
		}
		
		private function showDrownedShips(val:Ship, str:String):void
		{
			var len:int = val.coordinates.length;			
			
			for (var i:int = 0; i < val.coordinates.length; i++)
			{
				if(i == len - 1)
				{
					if(str == "player")	setSelectedPlayerCell([true, val.coordinates[len - 1], val.coordinates], true, false);
					else				setSelectedOponentCell([true, val.coordinates[len - 1], val.coordinates], true, false);
				
				}else{
					if(str == "player")	setSelectedPlayerCell([true, val.coordinates[i], null], true, false);						
					else				setSelectedOponentCell([true, val.coordinates[i], null], true, false);
				}				
			}							
		}
		
		private function locateShip(line:int, column:int, orient:int, deck:int, count:int):void
		{		
			var _shipMC:MovieClip = playerField.getChildByName("s" + deck + "_" + count) as MovieClip;					
			_shipMC.x = column*cellSize;
			_shipMC.y = line*cellSize;
			
			if(orient == 0) _shipMC.gotoAndStop(1);		
			else			_shipMC.gotoAndStop(2);				
		}
		
		private function oponentsFieldClick(e:MouseEvent):void
		{	
			_model.sendPositionOfSelectedCell((e.localY/cellSizeC), (e.localX/cellSizeC));		
		}
		
		public function setSelectedOponentCell(val:Object, showTable:Boolean = true, turnOnAni:Boolean = true):void
		{
			setSelectedCell(val, oponentField, showTable, turnOnAni);			
		}
		
		public function setSelectedPlayerCell(val:Object, showTable:Boolean = true, turnOnAni:Boolean = true):void
		{
			setSelectedCell(val, playerField, showTable, turnOnAni);		
		}
		
		/**
		 * 
		 * @param val
		 * @param container
		 * @param showTable
		 * @param turnOnAni
		 * 
		 */		
		private function setSelectedCell(val:Object, container:MovieClip, showTable:Boolean = true, turnOnAni:Boolean = true):void
		{
			var hitElement:MovieClip, _drownedShip:MovieClip, _playerMove:Boolean = true, _curCell:Number = cellSize;
			var _x:Number = 0, _y:Number = 0, deck:int, shipCounter:int, shipOrient:int;
						
			if(container.name == "oponent_field") 
			{			
				_playerMove = false;
				_curCell    = cellSizeC;
			}
			
			
			_x = val[1][1]*_curCell;
			_y = val[1][0]*_curCell;
			
			selectedCell = new cellTable();
			
			if(val[0])
			{				
				if(_playerMove)	selectedCell.gotoAndStop(4);				
				else				selectedCell.gotoAndStop(2);		
				
					if(turnOnAni) {
					hitElement = new hitFire();
					hitElement.name = "fire";
				}	
			
			}else{
				
				if(_playerMove)	selectedCell.gotoAndStop(3);				
				else			selectedCell.gotoAndStop(1);
				
				if(turnOnAni){
					hitElement = new hitWater();
					hitElement.name = "water";
				}			
			}
			
			if(val[2] && _playerMove) 
			{
				 _drownedShip = new drownedShips();
				container.addChildAt(_drownedShip, 0);
				_drownedShip.name = "drowned";
				
				_drownedShip.x = val[2][0][1]*_curCell;
				_drownedShip.y = val[2][0][0]*_curCell;
				
				_drownedShip.gotoAndStop((val[2] as Vector.<Array>).length);
				
				for (var i:int = 0; i < _model._userShips[0].length; i++) 
				{
					if(val[2][0][0] == _model._userShips[0][i].column && val[2][0][1] == _model._userShips[0][i].line)
					{
						deck 		= _model._userShips[0][i].deck;
						shipOrient	= _model._userShips[0][i].direction;
						shipCounter = i;
						break;
					}
				}
					
				(playerField.getChildByName("s" + deck + "_" + i) as MovieClip).visible = false;	
				if(showTable) (_drownedShip.getChildByName("table") as MovieClip).gotoAndStop(shipOrient+1);						
			}
			
			container.addChild(selectedCell);
			selectedCell.name = "cell";
			selectedCell.x = _x;
			selectedCell.y = _y;
			
			if(turnOnAni)
			{
				container.addChild(hitElement);
				hitElement.x = _x;
				hitElement.y = _y;
				hitElement.gotoAndPlay(2);				
				hitElement.addEventListener("finish_hit", removeHitAnimation);		
			}		
		}
		
		private function removeHitAnimation(e:Event):void
		{
			if(oponentField.contains(e.currentTarget as MovieClip)) oponentField.removeChild(e.currentTarget as MovieClip);
			
			if(playerField.contains(e.currentTarget as MovieClip)) playerField.removeChild(e.currentTarget as MovieClip);
			
		}
		
		public function lockOponentFiled(val:Object):void
		{
			oponentField.mouseChildren = !Boolean(val);
			oponentField.mouseEnabled  = !Boolean(val);
		}
		
		private function goToMenu(e:MouseEvent):void
		{
			_model.showPopUp("game_exit");
		}
		
		public function clearContainer():void
		{
			var elToRemoveP:Array = new Array;
			var elToRemoveO:Array = new Array;
			
			for (var i:int = 0; i < playerField.numChildren; i++) 
			{
				var _el:MovieClip = playerField.getChildAt(i) as MovieClip;			
				if(_el && (_el.name == "cell" || _el.name == "drowned")){					
					elToRemoveP.push(_el);					
				}
			}
			
			removeEl(elToRemoveP, playerField);
			elToRemoveP = null;
			
			for (var j:int = 0; j < oponentField.numChildren; j++) 
			{
				var _elt:MovieClip = oponentField.getChildAt(j) as MovieClip;			
				
				if(_elt && (_elt.name == "cell" || _elt.name == "drowned"))		elToRemoveO.push(_elt);						
			}	
			
			removeEl(elToRemoveO, oponentField);
			elToRemoveO = null;
		}
		
		private function removeEl(val:Array, conainer:MovieClip):void
		{
			for (var i:int = 0; i < val.length; i++) 
			{
				conainer.removeChild(val[i]);
				val[i] = null;				
			}			
		}
		
		public function destroy():void
		{
			if(selectedCell) 			selectedCell 			= null;
			if(viewGameWindow) 			viewGameWindow 			= null;
			if(playerField)				playerField 			= null;
			if(oponentField)			oponentField 			= null;
			if(currentDragedElement)	currentDragedElement 	= null;
			if(elementForRotation)		elementForRotation 		= null;
			if(menuButton)				menuButton 				= null;
			if(_model)					_model 					= null;			
		}
	}
}