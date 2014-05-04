package app.model.save
{
	import app.model.game.FullGameData;
	import app.model.game.Ship;

	public class SavedData
	{	
		public var userShips:			Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		public var oponentShips:		Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		
		public var userBattleField:		Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		public var oponentBattleField:	Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		
		public var status:				uint;	 
		public var opponentType:		uint;
		
		public var gameType:			String;
		
		public var gameInfo:			Boolean;
		
		public var shipsWasLocated:		Boolean;
		
		public var hitedUserShipPosition:Array;
		
		public var killedOponentShipsCouter:	int;
		public var killedUserShipsCouter:		int;		
		
		public var lastHitedOponentShipPosition:	Vector.<Array>;
		public var lastHitedUserShipPosition:	Vector.<Array>;
		
		public var oponentShipIsHited:	Boolean;
		public var shipIsKilled:			Boolean;
		public var findAnotherShip:		Boolean;
		
		public var isHited:				Boolean = true;
		
		public var currentSelectedCell:	Array;
		
		public var infoAboutShipsDecksPl:	Array;		
		public var infoAboutShipsDecksCom:	Array;
		
		public var _arrayWithPositionForFindShip:			Array;
		public var arrayWithPositionForFindShipSecondStep:	Array;		
		public var arrayWithPositionForFindShipThirdStep:	Array;
		
		public var gameData:FullGameData;
		
		public function set arrayWithPositionForFindShip(array:Array):void
		{
			_arrayWithPositionForFindShip = array;
		}
		
		public function serialize():Object
		{
			var obj:Object = new Object();
			
			obj.userShips 			= userShips;
			obj.enemyShips 			= oponentShips;
			
			obj.userBattleField 	= userBattleField;
			obj.enemyBattleField 	= oponentBattleField;
			
			obj.status 				= status;
			obj.gameType 			= gameType;
			obj.gameInfo 			= gameInfo;
			obj.opponentType 		= opponentType;
			obj.shipsWasLocated 			= shipsWasLocated;
			obj.hitedPlayerShipPosition 	= hitedUserShipPosition;
			
			obj.killedShipsCouterCom 		= killedOponentShipsCouter;
			obj.killedShipsCouterPl 		= killedUserShipsCouter;
			
			obj.lastHitShipPositionCom 		= lastHitedOponentShipPosition;
			obj.lastHitShipPositionPl 		= lastHitedUserShipPosition;
			
			obj.oponentShipIsHit 		= oponentShipIsHited;
			obj.shipIsKill 				= shipIsKilled;

			obj.isHited 				= isHited;
			obj.currentSelectedCell 	= currentSelectedCell;
			
			obj.infoAboutShipsDecksPl 	= infoAboutShipsDecksPl;
			obj.infoAboutShipsDecksCom 	= infoAboutShipsDecksCom;
			
			obj.arrayWithPositionForFindShip 			= _arrayWithPositionForFindShip;
			obj.arrayWithPositionForFindShipSecondStep 	= arrayWithPositionForFindShipSecondStep;
			obj.arrayWithPositionForFindShipThirdStep 	= arrayWithPositionForFindShipThirdStep;
			
			return obj;
		}
	}
}