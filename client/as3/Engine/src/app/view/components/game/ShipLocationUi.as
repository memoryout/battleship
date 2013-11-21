package app.view.components.game
{
	import app.model.game.FullGameData;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class ShipLocationUi extends Sprite
	{
		private var _model:					mShipLocation;
		private var _gameData:				FullGameData;
		
		private const cellSize:				Number = 31.5;
		
		private const RED:					uint = 0xFF0000;
		private const WHITE:				uint = 0xFFFFFF;
		private const BLACK:				uint = 0x000000;
		private const GREEN:				uint = 0x66FF66;
		
		private var _viewShipLocation:		MovieClip;
		private var playerField:			MovieClip;
		
		private var shuffleButton:			SimpleButton;	
		private var rotateButton:			SimpleButton;
		private var nextButton:				SimpleButton;			
		private var menuButton:				SimpleButton;	
		
		private var currentDragedElement:	MovieClip;
		private var elementForRotation:		MovieClip;
		
		private var shipsLocationLogic:		ShipsLocationProcess = new ShipsLocationProcess();	
		private var oldPoint:				Point = new Point();		
		
		private var hideTimer:				Timer = new Timer(300, 1);
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;	
		
		public function ShipLocationUi(med:mShipLocation = null)
		{
			TweenPlugin.activate([TintPlugin]);
			
			super();
			
			_model = med as mShipLocation;
			addLinks();
			addListenersForPlayerField();
		}
		
		private function addLinks():void
		{
			_viewShipLocation = new viewShipLocation();
			addChild(_viewShipLocation);	
			
			playerField 	= _viewShipLocation.getChildByName("player_field") 	as MovieClip;			
			
			shuffleButton	= _viewShipLocation.getChildByName("btn_shuffle") 	as SimpleButton;
			rotateButton	= _viewShipLocation.getChildByName("btn_rotate") 	as SimpleButton;
			nextButton		= _viewShipLocation.getChildByName("btn_next") 		as SimpleButton;		
			menuButton		= _viewShipLocation.getChildByName("btn_menu") 		as SimpleButton;	
		}
		
		private function addListenersForPlayerField():void
		{
			shuffleButton.addEventListener(MouseEvent.MOUSE_DOWN, 	shuffleShips);
			rotateButton.addEventListener(MouseEvent.MOUSE_DOWN, 	rotateShip);
			nextButton.addEventListener(MouseEvent.MOUSE_DOWN, 		startGame);
			menuButton.addEventListener(MouseEvent.MOUSE_DOWN, 		goToMenu);
			
			for (var j:int = 0; j < playerField.numChildren; j++) 
			{
				playerField.getChildAt(j).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);			
				(playerField.getChildAt(j) as MovieClip).buttonMode = true;
			}			
		}
		
		private function mouseMoveActivate(e:MouseEvent):void
		{
			currentDragedElement  = e.currentTarget as MovieClip;
			oldPoint.x = currentDragedElement.x;
			oldPoint.y = currentDragedElement.y;		
			
			currentDragedElement.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);	
			currentDragedElement.addEventListener(MouseEvent.MOUSE_UP, 	 mouseMoveDeactivate);	
			currentDragedElement.startDrag();			
		}
		
		private function mouseMove(e:MouseEvent):void
		{	
			var lining:MovieClip, level:int, hitMc:MovieClip = e.currentTarget as MovieClip, old_x:int, old_y:int;		
			
			var x_coef:int = shipsLocationLogic.correctRange((hitMc.x + 12)/cellSize);
			var y_coef:int = shipsLocationLogic.correctRange((hitMc.y + 12)/cellSize);
			
			var a:Array 			= hitMc.name.split("s");
			var deckNArray:Array	= a[1].split("_");
			var shipsDeck:int  		= int(deckNArray[0]);			
			var shipOrient:int 		= hitMc.currentFrame - 1;								
			
			playerField.setChildIndex(hitMc, playerField.numChildren - 1);		
			
			if(!tableIsAdd)
			{
				tableIsAdd = true;
				if(playerField.getChildIndex(hitMc) - 1 >= 0) level = playerField.getChildIndex(hitMc) - 1;
				addTable(lining, shipsDeck, shipOrient+1, level);
			}				
			
			lining = (playerField.getChildByName("table_element") as MovieClip);
			
			if(!isCleared)
			{					
				old_x = shipsLocationLogic.shipsLocationArray[int(deckNArray[1])].column;
				old_y = shipsLocationLogic.shipsLocationArray[int(deckNArray[1])].line;
				
				isCleared = true;
				
				shipsLocationLogic.shipsOldPosition = [old_x, old_y];					
				
				shipsLocationLogic.resetShipLocation(old_x, old_y, shipOrient, shipsDeck);				
				shipsLocationLogic.traceShipsArray("reset");			
				
				shipsLocationLogic.updateShipsLocationWithoutDraged(old_x, old_y);				
				shipsLocationLogic.traceShipsArray("update");
			}
			
			shipsLocationLogic.dataForRotate.column = x_coef;
			shipsLocationLogic.dataForRotate.line	= y_coef;
			shipsLocationLogic.dataForRotate.orient	= shipOrient;
			shipsLocationLogic.dataForRotate.deck	= shipsDeck;	
			
			if(shipsLocationLogic.checkShipField(y_coef, x_coef, shipOrient, shipsDeck))
			{			
				canLocate = true;				
				setTint(lining, GREEN, 0, 1);
				
			}else{
				
				canLocate = false;				
				setTint(lining, RED, 0, 1);
			}
			
			if(shipOrient == 0)
			{
				lining.x = shipsLocationLogic.correctRangeForMoving(x_coef, shipsDeck)*cellSize;
				lining.y = y_coef*cellSize;						
				
			}else if(shipOrient == 1)
			{				
				lining.x = x_coef*cellSize;
				lining.y = shipsLocationLogic.correctRangeForMoving(y_coef, shipsDeck)*cellSize;
			}			
		}
		
		private function mouseMoveDeactivate(e:MouseEvent):void
		{	
			currentDragedElement.stopDrag();
			removeMoveListeners();		
			
			isCleared = tableIsAdd = false;
			currentDragedElement = elementForRotation = e.currentTarget as MovieClip;					
			
			var a:Array 		 = currentDragedElement.name.split("s");
			var deckNArray:Array = a[1].split("_");
			var shipsDeck:int  	 = int(deckNArray[0]);	
			var shipOrient:int 	 = (currentDragedElement.currentFrame - 1);	
			var lining:MovieClip = (playerField.getChildByName("table_element") as MovieClip);			
			
			if(canLocate)
			{
				currentDragedElement.x = lining.x;
				currentDragedElement.y = lining.y; 
				
			}else{
				
				currentDragedElement.x = lining.x = oldPoint.x;
				currentDragedElement.y = lining.y = oldPoint.y; 	
			}	
			
			removeTable();			
			
			var x_coef:int = shipsLocationLogic.correctRange((currentDragedElement.x + 20)/cellSize);
			var y_coef:int = shipsLocationLogic.correctRange((currentDragedElement.y + 5)/cellSize);
			
			if(shipsLocationLogic.checkShipField(x_coef, y_coef, shipOrient, shipsDeck))
			{
				shipsLocationLogic.putShipInBattleField(x_coef, y_coef, shipOrient, shipsDeck, true);	
				shipsLocationLogic.traceShipsArray("drag stop");
			}			
		}
		
		private function removeMoveListeners():void
		{				
			for (var j:int = 0; j < playerField.numChildren; j++) 
			{
				playerField.getChildAt(j).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}			
		}
		
		private function shuffleShips(e:MouseEvent):void
		{		
			_model.shuffleShips();			
		}
		
		/**
		 * Reset rotating ships position.
		 * Update all ships position without ship wich will rotate.
		 * If can rotate, change position. Else show "red table" on unposible position, set timer for hide this red table. 
		 */		
		private function rotateShip(e:MouseEvent):void
		{
			if(elementForRotation)
			{	
				var lining:MovieClip, level:int, orientForRotate:int, rotateData:Object = shipsLocationLogic.dataForRotate, shipOrient:int = rotateData.orient;			
				
				shipsLocationLogic.resetShipLocation(				rotateData.column, rotateData.line, rotateData.orient, rotateData.deck);
				shipsLocationLogic.updateShipsLocationWithoutDraged(rotateData.column, rotateData.line);
				shipsLocationLogic.traceShipsArray("without draged");
				
				if(rotateData.orient == 1)  orientForRotate = 0; else orientForRotate = 1;
				
				if( shipsLocationLogic.canRotate( rotateData.column, rotateData.line, orientForRotate, rotateData.deck) ) 
				{					
					if(orientForRotate == 0)	rotateData.orient = orientForRotate; else rotateData.orient = orientForRotate;
					
					elementForRotation.gotoAndStop(orientForRotate + 1);
					shipsLocationLogic.shipsOldPosition = [rotateData.column, rotateData.line];	
					
					shipsLocationLogic.resetShipLocation(	 rotateData.column, rotateData.line, rotateData.orient, rotateData.deck);	
					shipsLocationLogic.putShipInBattleField( rotateData.column, rotateData.line, rotateData.orient, rotateData.deck, true);				
					
					shipsLocationLogic.traceShipsArray("rotate");
					
				}else
				{					
					if(playerField.getChildIndex(elementForRotation) - 1 >= 0) level = playerField.getChildIndex(elementForRotation) - 1;
					
					addTable(lining, rotateData.deck, orientForRotate+1, level);
					
					lining   = (playerField.getChildByName("table_element") as MovieClip);
					lining.x = rotateData.column*cellSize;
					lining.y = rotateData.line*cellSize;					
					
					setTint(lining, RED, 0, 1);
					
					hideTimer.addEventListener(TimerEvent.TIMER, hideTable);
					hideTimer.start();
					
					shipsLocationLogic.traceShipsArray("can't rotate");
				}
			}
		}
		
		/**
		 * Adding and showing lining under ship.
		 * @param lining  - lining under ship.
		 * @param deck	  - ship deck number.
		 * @param orient  - ship orientation.
		 * @param level   - child index.
		 */		
		private function addTable(lining:MovieClip, deck:int, orient:int, level:int):void
		{
			lining 	 = new movingTable();
			lining.name = "table_element";
			playerField.addChildAt(lining, level);
			lining.gotoAndStop(deck);
			lining.table.gotoAndStop(orient);
		}
		
		private function hideTable(e:TimerEvent):void
		{
			hideTimer.stop();
			hideTimer.removeEventListener(TimerEvent.TIMER, hideTable);			
			removeTable();
		}
		
		private function setTint(_element:MovieClip, _color:uint, _time:int = 0, _alpha:Number = 1):void
		{
			TweenLite.to(_element, _time, {tint:_color,  alpha:_alpha});	
		}
		
		/**
		 *  Adding and showing lining under ship.
		 */		
		private function removeTable():void
		{	
			if(playerField.contains(playerField.getChildByName("table_element") as MovieClip))
				playerField.removeChild(playerField.getChildByName("table_element") as MovieClip);		
		}
		
		private function startGame(e:MouseEvent):void
		{			
			removeListenersForPlayerField();
			
			shuffleButton.visible = rotateButton.visible = nextButton.visible = false;	
			
			_model.createGame(_gameData);			
		}
		
		private function removeListenersForPlayerField():void
		{
			nextButton.removeEventListener(MouseEvent.MOUSE_DOWN, 		startGame);			
			
			for (var j:int = 0; j < playerField.numChildren; j++) 
			{
				playerField.getChildAt(j).removeEventListener(MouseEvent.MOUSE_DOWN, mouseMove);
				playerField.getChildAt(j).removeEventListener(MouseEvent.MOUSE_UP, mouseMove);
				(playerField.getChildAt(j) as MovieClip).buttonMode = false;
			}
		}
		
		private function goToMenu(e:MouseEvent):void
		{
			_model.showPopUp("game_exit");
		}
		
		public function setPlayerShipsPosition(obj:Object):void
		{	
			shipsLocationLogic.shipsInArray 		= obj[1];
			shipsLocationLogic.shipsLocationArray 	= obj[0][0];			
			
			for (var j:int = 0; j < shipsLocationLogic.shipsLocationArray.length; j++) 
			{
				locateShip(shipsLocationLogic.shipsLocationArray[j].column, shipsLocationLogic.shipsLocationArray[j].line, shipsLocationLogic.shipsLocationArray[j].orient, shipsLocationLogic.shipsLocationArray[j].deck, j);
			}					
		}
		
		private function locateShip(x_coef:int, y_coef:int, orient:int, deck:int, count:int):void
		{		
			var _shipMC:MovieClip = playerField.getChildByName("s" + deck + "_" + count) as MovieClip;					
			_shipMC.x = y_coef*cellSize;
			_shipMC.y = x_coef*cellSize;
			
			if(orient == 0) _shipMC.gotoAndStop(1);		
			else			_shipMC.gotoAndStop(2);			
		}
		
		public function destroy():void
		{		
			if(hideTimer)
			{
				hideTimer.stop();
				hideTimer.removeEventListener(TimerEvent.TIMER, hideTable);			
				hideTimer = null;
			}
			
			if(shipsLocationLogic)
			{
				shipsLocationLogic.destroy();
				shipsLocationLogic = null;
			}
			
			if(oldPoint) 				oldPoint 				= null;
			if(elementForRotation) 		elementForRotation 		= null;
			if(currentDragedElement) 	currentDragedElement	= null;
			if(menuButton) 				menuButton 				= null;
			if(nextButton) 				nextButton 				= null;
			if(rotateButton) 			rotateButton 			= null;
			if(shuffleButton) 			shuffleButton 			= null;
			if(playerField) 			playerField 			= null;
			if(_viewShipLocation) 		_viewShipLocation 		= null;
			if(_gameData) 				_gameData 				= null;
			if(_model) 					_model 			 		= null;			
		}
	}
}