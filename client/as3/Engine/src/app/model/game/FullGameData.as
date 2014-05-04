package app.model.game
{
	public class FullGameData
	{
		public static const WAITING_FOR_START:				uint = 0; // wait for oponent
		
		public static const STEP_OF_INCOMING_USER:			uint = 1; // players step
		public static const STEP_OF_OPPONENT:				uint = 2; // oponents step
		
		public static const INCOMING_USER_WON:				uint = 3; // user won			
		public static const OPPONENT_WON:					uint = 4; // player won
		
		public static const INCOMING_USER_OUT:				uint = 5; // player out
		public static const OPPONENT_OUT:					uint = 6; // oponent out	
		
		public static const OPPONENT_PLAYER:				uint = 0;
		public static const OPPONENT_COMPUTER:				uint = 1;
		
		private static var globalId:						uint = 0;
			
		public var userShips:								Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		public var oponentShips:							Vector.<Vector.<Ship>> = new Vector.<Vector.<Ship>>;
		
		public var userBattleField:							Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		public var oponentBattleField:						Vector.<Vector.<int>>  = new Vector.<Vector.<int>>;
		
		private var _id:									uint;    // current game id
		
		public var _status:									uint;	 // current game status
		
		public var enemyName:								String;
		
		public var opponentType:							uint;	 // for distinguish is game with computer or player
		
		public var gameType:								String;  // for distinguish is limited or unlimited game type
		
		public var gameInfo:								Object;
		
		// part of variables correspon to game with computer
		
		public var shipsWasLocated:							Boolean;
		
		public var hitedUserShipPosition:					Array = new Array();
		
		public var killedOponentShipsCouter:				int;
		public var killedUserShipsCouter:					int;		
		
		public var lastHitedOponentShipPosition:			Vector.<Array> = new Vector.<Array>()
		public var lastHitedUserShipPosition:				Vector.<Array> = new Vector.<Array>();
		
		public var oponentShipIsHited:						Boolean;
		public var shipIsKilled:							Boolean;
		public var findAnotherShip:							Boolean;		
		public var isHited:									Boolean;
		
		public var currentSelectedCell:	Array = new Array();
		
		public var infoAboutShipsDecksPl:	Array = [4,  3, 3,  2, 2, 2, 1, 1, 1, 1];		
		public var infoAboutShipsDecksCom:	Array = [4,  3, 3,  2, 2, 2, 1, 1, 1, 1];
		
		public var strategyOne:Array = 
			[	[0,3], [0,7],
				[1,2], [1,6], 
				[2,1], [2,5], [2,9],
				[3,0], [3,4], [3,8],
				[4,3], [4,7], 
				[5,2], [5,6],
				[6,1], [6,5], [6,9],
				[7,0], [7,4], [7,8],
				[8,3], [8,7],
				[9,2], [9,6] ];
		
		public var strategyTwo:Array = 
			[	[0,1], [0,5],
				[1,0], [1,4], 
				[2,3], [2,7],
				[3,2], [3,6],
				[4,1], [4,5], [4,9],
				[5,0], [5,4], [5,8],
				[6,3], [6,7],
				[7,2], [7,6],
				[8,1], [8,5], [8,9],
				[9,0], [9,4], [9,8]	];
		
		public var strategyThree:Array = 
			[	[0,0], [0,2], [0,4], [0,6], [0,8],
				[1,1], [1,3], [1,5], [1,7], [1,9],
				[2,0], [2,2], [2,4], [2,6], [2,8],
				[3,1], [3,3], [3,5], [3,7], [3,9],
				[4,0], [4,2], [4,4], [4,6], [4,8],
				[5,1], [5,3], [5,5], [5,7], [5,9],
				[6,0], [6,2], [6,4], [6,6], [6,8],
				[7,1], [7,3], [7,5], [7,7], [7,9],
				[8,0], [8,2], [8,4], [8,6], [8,8],
				[9,1], [9,3], [9,5], [9,7], [9,9], 				
				
				[0,9], [1,8]  ];
		
		// part of variables correspon to game with computer
		
		public function FullGameData()
		{
			opponentType = OPPONENT_PLAYER;			
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function set id(val:uint):void
		{
			_id = val;
		}
		
		public function get status():uint
		{
			return _status;
		}
		
		public function set status(val:uint):void
		{
			_status = val;
		}
		
		public function setOpponent(name:String, id:String):void
		{
			enemyName = name;
		}
		
		public function destroy():void{}
		
		public function saveGameData():void
		{
			gameInfo = {id:_id, userShips:userShips, enemyShips:oponentShips, userBattleField:userBattleField, enemyBattleField:oponentBattleField};			
		}
	}
}