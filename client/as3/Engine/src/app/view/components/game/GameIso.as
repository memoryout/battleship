package app.view.components.game
{
	import app.model.game.Ship;
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import org.osmf.events.TimeEvent;
	
	public class GameIso extends Sprite
	{
		private const cellSize:Number = 31.5;
		
		private const RED	:uint = 0xFF0000;
		private const WHITE	:uint = 0xFFFFFF;
		private const BLACK	:uint = 0x000000;
		private const GREEN	:uint = 0x66FF66;
		
		private var viewGameWindow:			MovieClip		
		private var playerField:			MovieClip;
		private var oponentField:			MovieClip;		
		private var currentDragedElement:	MovieClip;
		private var elementForRotation:		MovieClip;
		
		private var shuffleButton:			SimpleButton;	
		private var rotateButton:			SimpleButton;
		private var nextButton:				SimpleButton;	
		
		private var elementForRotationPosition:Object = {"column":0, "line":0,  "orient":0,  "deck":0};
		
		private var _timer:					Timer = new Timer(1000, 1);
		private var hideTimer:				Timer = new Timer(300, 1);
		
		private var _model:					mGame;
		private var oldPoint:				Point = new Point();;
		
		private var coordTransistor:		ISOCoordsProcess 	 = new ISOCoordsProcess();
		private var shipsLocationLogic:		ShipsLocationProcess = new ShipsLocationProcess();	
		
		private var isCleared:				Boolean;	
		private var canLocate:				Boolean;	
		private var tableIsAdd:				Boolean;	
				
		private var cellCounterPlayer:		int;
		private var cellCounterComp:		int;
		
		public function GameIso(med:mGame=null)
		{
			TweenPlugin.activate([TintPlugin]);
			
			super();
		
			_model = med as mGame;
			
			addLinks();
			addListenersForPlayerField();
			
			_timer.addEventListener(TimerEvent.TIMER, initState);
			_timer.start();			
		}
		
		private function addLinks():void
		{
			viewGameWindow = new viewGame();
			addChild(viewGameWindow);	
			
			playerField 	= viewGameWindow.getChildByName("player_field") 	as MovieClip;
			oponentField 	= viewGameWindow.getChildByName("oponent_field") 	as MovieClip;			
			
			shuffleButton	= viewGameWindow.getChildByName("btn_shuffle") 		as SimpleButton;
			rotateButton	= viewGameWindow.getChildByName("btn_rotate") 		as SimpleButton;
			nextButton		= viewGameWindow.getChildByName("btn_next") 		as SimpleButton;				
		}
		
		private function addListenersForPlayerField():void
		{
			shuffleButton.addEventListener(MouseEvent.MOUSE_DOWN, shuffleButtonClick);
			rotateButton.addEventListener(MouseEvent.MOUSE_DOWN, rotateButtonClick);
			nextButton.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
			
			for (var i:int = 0; i < 10; i++) 
			{
				if(i < 10 && i > 5)
				{
					(playerField.getChildByName("s1_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s1_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s1_" + i) as MovieClip).buttonMode = true;
				}
				
				if(i < 6 && i > 2)
				{
					(playerField.getChildByName("s2_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s2_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s2_" + i) as MovieClip).buttonMode = true;
				}
				
				if(i < 3 && i > 0)
				{
					(playerField.getChildByName("s3_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s3_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s3_" + i) as MovieClip).buttonMode = true;
				}
				
				if(i < 1)
				{
					(playerField.getChildByName("s4_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s4_" + i) as MovieClip).addEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s4_" + i) as MovieClip).buttonMode = true;
				}
			}
			
		}
		private function removeListenersForPlayerField():void
		{
			shuffleButton.removeEventListener(MouseEvent.MOUSE_DOWN, shuffleButtonClick);
			rotateButton.removeEventListener(MouseEvent.MOUSE_DOWN, rotateButtonClick);
			nextButton.removeEventListener(MouseEvent.MOUSE_DOWN, startGame);
			
			for (var i:int = 0; i < 10; i++) 
			{
				if(i < 10 && i > 5)
				{
					(playerField.getChildByName("s1_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s1_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s1_" + i) as MovieClip).buttonMode = false;
				}
				
				if(i < 6 && i > 2)
				{
					(playerField.getChildByName("s2_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s2_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s2_" + i) as MovieClip).buttonMode = false;
				}
				
				if(i < 3 && i > 0)
				{
					(playerField.getChildByName("s3_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s3_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s3_" + i) as MovieClip).buttonMode = false;
				}
				
				if(i < 1)
				{
					(playerField.getChildByName("s4_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, mouseMoveActivate);
					(playerField.getChildByName("s4_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, mouseMoveDeactivate);
					(playerField.getChildByName("s4_" + i) as MovieClip).buttonMode = false;
				}
			}
		}
		
		private function mouseMoveActivate(e:MouseEvent):void
		{
			currentDragedElement  = e.currentTarget as MovieClip;
			oldPoint.x = currentDragedElement.x;
			oldPoint.y = currentDragedElement.y;		
			
			currentDragedElement.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);						
			currentDragedElement.startDrag();			
		}
		
		private function mouseMoveDeactivate(e:MouseEvent):void
		{				
			isCleared 	= false;
			tableIsAdd = false;
			currentDragedElement = e.currentTarget as MovieClip;
			currentDragedElement.stopDrag();
			removeMoveListeners();
						
			var a:Array = currentDragedElement.name.split("s");
			var cell:MovieClip = (playerField.getChildByName("table_element") as MovieClip);
			
			if(canLocate)
			{
				currentDragedElement.x = cell.x;
				currentDragedElement.y = cell.y; 
			
			}else{
				
				currentDragedElement.x = oldPoint.x;
				currentDragedElement.y = oldPoint.y; 
			
				if(cell)
				{
					cell.x	= oldPoint.x;
					cell.y	= oldPoint.y;		
				}		
			}	
			 
		    removeTable();
			 
			var deckNumber:Array = a[1].split("_");			
			var deckOrient:int = (currentDragedElement.currentFrame - 1);		
			
			var deckOrientNew:int;
			
			if(deckOrient != 1)	deckOrientNew = 1;
			
			elementForRotation = currentDragedElement;		
			
			var curPoint:Point = coordTransistor.toIso(currentDragedElement.x, currentDragedElement.y);			
			
			var x_coef:int = Math.abs((curPoint.x+20)/cellSize);
			var y_coef:int = Math.abs((curPoint.y+5)/cellSize);
			
			if(shipsLocationLogic.checkShipField(x_coef, y_coef, deckOrientNew, int(deckNumber[0])))
			{
				shipsLocationLogic.putShipInField(x_coef, y_coef, deckOrientNew, int(deckNumber[0]));
				shipsLocationLogic.changeShipLocation(x_coef, y_coef, deckOrientNew);
			
			}else{
				trace("not_put");
			}
			
			trace("--------");			
			shipsLocationLogic.traceShipsArray("drag stop");
		}
		
		private function mouseMove(e:MouseEvent):void
		{			
			var hitMc:MovieClip   = e.currentTarget as MovieClip;		
			
			var curPoint:Point = coordTransistor.toIso(hitMc.x, hitMc.y);			
			
			var x_coef:int = (curPoint.x + 20)/cellSize;
			var y_coef:int = (curPoint.y + 5)/cellSize;
						
			var a:Array = hitMc.name.split("s"); // part of name without s
			var deckNumber:Array = a[1].split("_");
			
			var deckOrient:int = (hitMc.currentFrame - 1);		
			
			var deckOrientNew:int, cell:MovieClip;		
			
			if(deckOrient != 1)	deckOrientNew = 1;
						
			if(!tableIsAdd)
			{
				tableIsAdd = true;
				addTable(cell, int(deckNumber[0]), deckOrientNew+1, playerField.getChildIndex(hitMc) - 1);
			}				
			
			cell = (playerField.getChildByName("table_element") as MovieClip);
			
			if(x_coef > 9 )
			{
				x_coef = 9;
			
			}else if(x_coef < 0){
				
				x_coef = 0;
			}
			
			if(y_coef > 9 )
			{
				y_coef = 9;
			
			}else if(y_coef < 0)
			{				
				y_coef = 0;
			}
						
			if(!isCleared)
			{
				shipsLocationLogic.shipsOldPosition = [x_coef, y_coef];				
				
				isCleared = true;
				shipsLocationLogic.resetShipLocation(x_coef, y_coef, deckOrientNew, int(deckNumber[0]));				
				shipsLocationLogic.traceShipsArray("reset");
				
				trace("--------");		
				shipsLocationLogic.updateShipsLocationWithoutDraged(x_coef, y_coef, deckOrientNew, int(deckNumber[0]));				
				shipsLocationLogic.traceShipsArray("update");
			}
			
			elementForRotationPosition.column 	= x_coef;
			elementForRotationPosition.line		= y_coef;
			elementForRotationPosition.orient	= deckOrientNew;
			elementForRotationPosition.deck		= int(deckNumber[0]);	
			
			if(shipsLocationLogic.checkShipField(x_coef, y_coef, deckOrientNew, int(deckNumber[0])))
			{			
				canLocate = true;				
				setTint(cell, GREEN, 0, 0.5);
			
			}else{
				
				canLocate = false;				
				setTint(cell, RED, 0, 0.5);
			}
			
			var newPoint:Point = setPointInIso(x_coef, y_coef);
				
			if(deckOrientNew == 0 && (x_coef + int(deckNumber[0]) - 1 < 10 || x_coef - int(deckNumber[0]) > 0))
			{
				cell.x = newPoint.x;
				cell.y = newPoint.y;
				
			}else if(deckOrientNew == 1 && (y_coef + int(deckNumber[0]) - 1 < 10 || y_coef - int(deckNumber[0]) > 10) )
			{
				cell.x = newPoint.x;
				cell.y = newPoint.y;
			}				
		}
			
		private function removeMoveListeners():void
		{	
			for (var i:int = 0; i < 10; i++) 
			{
				if(i < 10 && i > 5)
				{
					(playerField.getChildByName("s1_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);				
				}
				
				if(i < 6 && i > 2)
				{
					(playerField.getChildByName("s2_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);				
				}
				
				if(i < 3 && i > 0)
				{
					(playerField.getChildByName("s3_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);				
				}
				
				if(i < 1)
				{
					(playerField.getChildByName("s4_" + i) as MovieClip).removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);				
				}
			}
		}	
		
		private function initState(e:TimerEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER, initState);
			
			TweenLite.to(viewGameWindow, 1, {scaleX:1.5, scaleY:1.5});
		}	
		
		private function shuffleButtonClick(e:MouseEvent):void
		{		
			_model.shuffleShips();			
		}
		
		/**
		 * Reset rotating ships position.
		 * Update all ships position.
		 * If can rotate, change position. Else show "red table" on unposibble position, set timer for hide this red table. 
		 */		
		private function rotateButtonClick(e:MouseEvent):void
		{
			if(elementForRotation && elementForRotationPosition)
			{	
				var cell:MovieClip, newPoint:Point, shipOrientNew:int;	
				
				var shipOrient:int = elementForRotationPosition.orient;			
				
				shipsLocationLogic.resetShipLocation(				elementForRotationPosition.column, elementForRotationPosition.line, elementForRotationPosition.orient, elementForRotationPosition.deck);
				shipsLocationLogic.updateShipsLocationWithoutDraged(elementForRotationPosition.column, elementForRotationPosition.line, elementForRotationPosition.orient, elementForRotationPosition.deck);
				shipsLocationLogic.traceShipsArray();
				
				if( shipsLocationLogic.canRotate( elementForRotationPosition.column, elementForRotationPosition.line, elementForRotationPosition.orient, elementForRotationPosition.deck) ) 
				{
					if(shipOrient == 1)
					{					
						shipOrientNew = 1;
						elementForRotation.gotoAndStop(1);
						elementForRotationPosition.orient = 1;
						
					}else{
						
						shipOrientNew = 0;
						elementForRotation.gotoAndStop(2);
						elementForRotationPosition.orient = 0;
					}
					
					shipsLocationLogic.shipsOldPosition = [elementForRotationPosition.column, elementForRotationPosition.line];	
					
					shipsLocationLogic.putShipInField(		elementForRotationPosition.column, elementForRotationPosition.line, shipOrientNew, elementForRotationPosition.deck);
					shipsLocationLogic.changeShipLocation(	elementForRotationPosition.column, elementForRotationPosition.line, shipOrientNew);					
					
				}else
				{
					if(shipOrient == 1)		shipOrientNew = 1;						
					else					shipOrientNew = 0;													
					
					addTable(cell, elementForRotationPosition.deck, shipOrientNew+1,  playerField.getChildIndex(elementForRotation) - 1);
					newPoint = setPointInIso(elementForRotationPosition.column, elementForRotationPosition.line);

					cell = (playerField.getChildByName("table_element") as MovieClip);
					cell.x = newPoint.x;
					cell.y = newPoint.y;					
					cell.alpha = 1;
					setTint(cell, RED, 0, 0.5);
					
					hideTimer.addEventListener(TimerEvent.TIMER, hideTable);
					hideTimer.start();
				}
			}
		}
		
		private function addTable(element:MovieClip, deck:int, orient:int, level:int):void
		{
			element = new movingTable();
			element.name = "table_element";
			playerField.addChildAt(element, level);
			element.gotoAndStop(deck);
			element.table.gotoAndStop(orient);
		}
		
		private function hideTable(e:TimerEvent):void
		{
			hideTimer.stop();
			hideTimer.removeEventListener(TimerEvent.TIMER, hideTable);			
			removeTable();
		}
		
		private function removeTable():void
		{	
			if(playerField.contains(playerField.getChildByName("table_element") as MovieClip))
			playerField.removeChild(playerField.getChildByName("table_element") as MovieClip);		
		}
		
		public function setPlayerShipsPosition(obj:Object):void
		{	
			shipsLocationLogic.shipsInArray = obj[1];
			shipsLocationLogic.shipsLocationArray = obj[0][0];			
				
			for (var j:int = 0; j < shipsLocationLogic.shipsLocationArray.length; j++) 
			{
				locateShip(shipsLocationLogic.shipsLocationArray[j].coordinates[0][0], shipsLocationLogic.shipsLocationArray[j].coordinates[0][1], shipsLocationLogic.shipsLocationArray[j].orient, shipsLocationLogic.shipsLocationArray[j].deck, j);
			}					
		}
		
		private function locateShip(x_coef:int, y_coef:int, orient:int, deck:int, count:int):void
		{		
			var _shipMC:MovieClip, _cellMC:MovieClip, oldX:int, oldY:int;
			
			if(10 - x_coef - deck < 0 && orient == 1)
			{
				oldX = x_coef;
				oldY = y_coef;
				
				x_coef = x_coef + (9 - x_coef - deck);		
				
				shipsLocationLogic.updateShipsLocation(x_coef, y_coef, oldX, oldY);
			}
			
			if(10 - y_coef - deck < 0 && orient == 0)
			{
				oldX = x_coef;
				oldY = y_coef;
				
				y_coef = y_coef + (9 - y_coef - deck);

				shipsLocationLogic.updateShipsLocation(x_coef, y_coef, oldX, oldY);
			}
			
			switch(deck)
			{
				case 1:
				{
					_shipMC = playerField.getChildByName("s1_" + count) as MovieClip;						
					break;
				}
				case 2:
				{
					_shipMC = playerField.getChildByName("s2_" + count) as MovieClip;							
					break;
				}
				case 3:
				{
					_shipMC = playerField.getChildByName("s3_" + count) as MovieClip;	
					break;
				}
				case 4:
				{
					_shipMC = playerField.getChildByName("s4_" + count) as MovieClip;					
					break;
				}
			}
									
			var mcP:Point = setPointInIso(x_coef, y_coef);
			
			_shipMC.x = mcP.x;
			_shipMC.y = mcP.y;
			playerField.setChildIndex(_shipMC, playerField.numChildren - 1);				
			
			if(orient == 1)		_shipMC.gotoAndStop(2);					
			else				_shipMC.gotoAndStop(1);						
		}
		
		private function startGame(e:MouseEvent):void
		{
			TweenLite.to(viewGameWindow, 1,{scaleX:1, scaleY:1});
			removeListenersForPlayerField();
			
			shuffleButton.visible	= false;
			rotateButton.visible	= false;
			nextButton.visible		= false;	
			
			_model.savePlayerShips(shipsLocationLogic.shipsLocationArray);
			activeOponentTableField();
		}
		
		private function activeOponentTableField():void
		{
			oponentField.addEventListener(MouseEvent.MOUSE_DOWN, oponentsFieldClick);			
		}
		
		private function oponentsFieldClick(e:MouseEvent):void
		{
			var curPoint:Point = coordTransistor.toIso(e.localX, e.localY);			
			var x_coef:int = (curPoint.x)/cellSize;
			var y_coef:int = (curPoint.y)/cellSize;
			
			_model.sendPositionOfSelectedCell(x_coef, y_coef);		
		}
		
		public function setSelectedComputerCell(val:Object):void
		{
			setSelectedCell(val, oponentField);			
		}
		
		public function setSelectedPlayerCell(val:Object):void
		{
			setSelectedCell(val, playerField);		
		}
		
		private function setSelectedCell(val:Object, container:MovieClip):void
		{
			var realPoint:Point = setPointInIso(val[1][0], val[1][1]);			
			var mcObject:MovieClip = new cellTable();
			container.addChild(mcObject);			
			
			mcObject.x = realPoint.x;
			mcObject.y = realPoint.y;
			
			if(val[0]) mcObject.gotoAndStop(2);
		}
		
		private function setTint(_element:MovieClip, _color:uint, _time:int = 0, _alpha:Number = 1):void
		{
			TweenLite.to(_element, _time, {tint:_color,  alpha:_alpha});	
		}
		
		private function setPointInIso(x:int, y:int):Point
		{
			var mcP:Point = coordTransistor.toReal(x*cellSize, y*cellSize);			
			return mcP;
		}
		
		public function lockComputerFiled(val:Object):void
		{
			oponentField.mouseChildren = !Boolean(val);
			oponentField.mouseEnabled  = !Boolean(val);
		}
	}
}