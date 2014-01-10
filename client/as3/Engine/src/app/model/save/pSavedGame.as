package app.model.save
{
	import app.model.device.Device;
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.Ship;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pSavedGame extends Proxy
	{		
		public static const ERROR_LOAD:		uint = 0;
		public static const ERROR_PARSING:	uint = 1;
		public static const ERROR_SAVE:		uint = 2;
		public static const COMPLETE:		uint = 3;
		
		public static const NAME:			String = "app.model.save.pSavedGameData";
		
		private const _data:SavedData 		= new SavedData();
		
		public function pSavedGame()
		{
			super(NAME, null);
		}
		
		public function getSavedData():SavedData
		{			
			return _data;
		}
				
		public function loadConfig(path:String):void
		{
			Device.get().openFile( path, onLoadFile, onErrorLoadFile );
		}
		
		public function saveConfig(path:String):void
		{
			var saveData:Object = _data.serialize();
			var ba:ByteArray = new ByteArray();
			ba.writeObject( saveData );
			
			Device.get().saveFile(ba, path, onSaveFile, onErrorSaveFile );
		}
		
		public function removeSavedFiel(path:String):void
		{
			Device.get().removeFile(path, onRemoveFile, onErrorRemoveFile );
		}
		
		private function onLoadFile(ba:ByteArray):void
		{
			parseData( ba.readObject() );
		}
		
		private function onErrorLoadFile(error:uint):void
		{
			this.dispatch( ERROR_LOAD );
		}
		
		public function parseData(data:Object):void
		{
			if(data)
			{
				var _gameDataWithComputer:FullGameData = new FullGameData();
				
				_gameDataWithComputer.userShips.push(convertShipLocation(data.userShips[0]));
				_gameDataWithComputer.enemyShips.push(convertShipLocation(data.enemyShips[0]));			
				
				_gameDataWithComputer.userBattleField  = convertBattleField(data.userBattleField);
				_gameDataWithComputer.enemyBattleField = convertBattleField(data.enemyBattleField);
				
				_gameDataWithComputer.status 		= data.status;				
				_gameDataWithComputer.opponentType	= data.opponentType;
				_gameDataWithComputer.gameType 		= data.gameType;
				_gameDataWithComputer.gameInfo 		= data.gameInfo;
				
				_gameDataWithComputer.shipsWasLocated 			= data.shipsWasLocated;
				_gameDataWithComputer.hitedPlayerShipPosition 	= data.hitedPlayerShipPosition;
				
				_gameDataWithComputer.killedShipsCouterCom 	= data.killedShipsCouterCom;
				_gameDataWithComputer.killedShipsCouterPl 	= data.killedShipsCouterPl;
				
				_gameDataWithComputer.lastHitShipPositionCom = data.lastHitShipPositionCom;
				_gameDataWithComputer.lastHitShipPositionPl  = data.lastHitShipPositionPl;
				
				_gameDataWithComputer.oponentShipIsHit 	= data.oponentShipIsHit;
				_gameDataWithComputer.shipIsKill 		= data.shipIsKill;
				
				_gameDataWithComputer.isHited 				= data.isHited;
				_gameDataWithComputer.currentSelectedCell 	= data.currentSelectedCell;
				
				_gameDataWithComputer.infoAboutShipsDecksPl 	= data.infoAboutShipsDecksPl;
				_gameDataWithComputer.infoAboutShipsDecksCom 	= data.infoAboutShipsDecksCom;
				
				_gameDataWithComputer.strategyArrayOne 				= data.arrayWithPositionForFindShip;
				_gameDataWithComputer.strategyArrayTwo 	= data.arrayWithPositionForFindShipSecondStep;
				_gameDataWithComputer.strategyArrayThree 	= data.arrayWithPositionForFindShipThirdStep;
				
				GameList.Get().addGameWithComputerToList(_gameDataWithComputer);
				GameList.Get().setComputerGameData(_gameDataWithComputer);
			}
			else
			{
				this.dispatch( ERROR_PARSING );
				return;
			}
			
			this.dispatch( COMPLETE );
		}
		
		public function setSavedData(val:Object):void
		{
			_data.userShips 								= val.userShips;
			_data.enemyShips 								= val.enemyShips;			
			
			_data.userBattleField 							= val.userBattleField;
			_data.enemyBattleField 							= val.enemyBattleField;
			
			_data.status 									= val.status;
			_data.gameType 									= val.gameType;
			_data.gameInfo 									= val.gameInfo;
			_data.opponentType								= val.opponentType;
			
			_data.shipsWasLocated 							= val.shipsWasLocated;
			_data.hitedPlayerShipPosition 					= val.hitedPlayerShipPosition;
			
			_data.killedShipsCouterCom 						= val.killedShipsCouterCom;
			_data.killedShipsCouterPl 						= val.killedShipsCouterPl;
			
			_data.lastHitShipPositionCom 					= val.lastHitShipPositionCom;
			_data.lastHitShipPositionPl 					= val.lastHitShipPositionPl;
			
			_data.oponentShipIsHit 							= val.oponentShipIsHit;
			_data.shipIsKill 								= val.shipIsKill;
			
			_data.isHited 									= val.isHited;
			_data.currentSelectedCell 						= val.currentSelectedCell;
			
			_data.infoAboutShipsDecksPl 					= val.infoAboutShipsDecksPl;
			_data.infoAboutShipsDecksCom 					= val.infoAboutShipsDecksCom;
			
			_data.arrayWithPositionForFindShip 				= val.strategyArrayOne;
			_data.arrayWithPositionForFindShipSecondStep 	= val.strategyArrayTwo;
			_data.arrayWithPositionForFindShipThirdStep 	= val.strategyArrayThree;
		}
		
		private function convertShipLocation(val:Object):Vector.<Ship>
		{
			var _ships:Vector.<Ship> = new Vector.<Ship>;
						
			for (var i:int = 0; i < val.length; i++) 
			{	
				var _ship:Ship = new Ship();
				_ship.column 		= val[i].column;
				_ship.coordinates	= val[i].coordinates;
				_ship.deck			= val[i].deck;
				_ship.drowned		= val[i].drowned;
				_ship.line			= val[i].line;
				_ship.direction		= val[i].orient;
					
				_ships.push(_ship);
			}		
			
			return _ships;
		}
		
		private function convertBattleField(val:Object):Vector.<Vector.<int>>
		{
			var _battleField:Vector.<Vector.<int>> = new Vector.<Vector.<int>>;
			
			for (var i:int = 0; i < val.length; i++) 
			{
				_battleField.push(val[i]);
			}
			
			return _battleField;
		}
		
		
		private function onSaveFile( data:Object = null ):void
		{
			
		}
		
		private function onErrorSaveFile( data:Object = null ):void
		{
			
		}
		
		private function onRemoveFile( data:Object = null ):void
		{
			
		}
		
		private function onErrorRemoveFile( data:Object = null ):void
		{
			
		}
	}
}