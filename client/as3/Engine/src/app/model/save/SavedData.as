package app.model.save
{
	import app.model.game.FullGameData;
	import app.model.game.Ship;

	public class SavedData
	{	
		public var userShips:			Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		public var enemyShips:			Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		
		public var userBattleField:		Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		public var enemyBattleField:	Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		
		public var status:				uint;	 
		public var opponentType:		uint;
		
		public var gameType:			String;
		
		public var gameInfo:			Boolean;
		
		public var shipsWasLocated:		Boolean;
		
		public var hitedPlayerShipPosition:Array;
		
		public var killedShipsCouterCom:	int;
		public var killedShipsCouterPl:		int;		
		
		public var lastHitShipPositionCom:	Array;
		public var lastHitShipPositionPl:	Array;
		
		public var oponentShipIsHit:	Boolean;
		public var shipIsKill:			Boolean;
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
			obj.enemyShips 			= enemyShips;
			
			obj.userBattleField 	= userBattleField;
			obj.enemyBattleField 	= enemyBattleField;
			
			obj.status 				= status;
			obj.gameType 			= gameType;
			obj.gameInfo 			= gameInfo;
			obj.opponentType 		= opponentType;
			obj.shipsWasLocated 			= shipsWasLocated;
			obj.hitedPlayerShipPosition 	= hitedPlayerShipPosition;
			
			obj.killedShipsCouterCom 		= killedShipsCouterCom;
			obj.killedShipsCouterPl 		= killedShipsCouterPl;
			
			obj.lastHitShipPositionCom 		= lastHitShipPositionCom;
			obj.lastHitShipPositionPl 		= lastHitShipPositionPl;
			
			obj.oponentShipIsHit 		= oponentShipIsHit;
			obj.shipIsKill 				= shipIsKill;

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