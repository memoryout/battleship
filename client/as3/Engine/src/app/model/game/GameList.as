package app.model.game
{
	import app.view.components.game.GameUi;
	
	import flash.utils.Dictionary;

	public class GameList
	{
		private static const _instance	:GameList = new GameList();
		
		private var gameList:				Dictionary = new Dictionary();				 // contains general information about the games that are in the list of active games		
		private var currentGameData:		FullGameData = new FullGameData();									 // contains inforatsiyu the present game
		private var gameDataWithComputer:	FullGameData = new FullGameData();
		
		
		public function GameList(){}
		
		public static function Get():GameList
		{
			return _instance;
		}
		
		public function setCurrentGameData(val:FullGameData):void
		{
			currentGameData = val;
		}
		
		public function setComputerGameData(val:FullGameData):void
		{
			gameDataWithComputer = val;
		}
		
		public function addGameToList(val:Object):void
		{
			var data:MainGameData = new MainGameData();
			
			if(val)
			{			
				data.id 			= val.game_id;				
				data.status 		= val.status;
				data.gameTime		= val.game_time;
				data.notification 	= val.notification;
				data.timeOut		= val.time_out;
				
				gameList[data.id] = data;
			}
		}
		
		public function addGameWithComputerToList(val:Object):void
		{
			var data:MainGameData = new MainGameData();
						
			if(val)
			{			
				data.id 			= val.id;				
				data.status 		= val.status;					
				
				gameList[0] = data;
			}
		}
		public function findGameInList(val:int):Boolean
		{
			var res:Boolean;
			
			for (var i:String in gameList) 
			{
				if(gameList[i].id == val) res = true;				
			}
			
			return res;
		}
		
		public function addCurrentGameToList(obj:Object):void
		{
			if(obj)
			{
				currentGameData.id 		= obj.game_id;
				currentGameData.status  = obj.status;		
				
				gameList[obj.game_id] 	= currentGameData;				
			}
		}
		
		public function createGameDataAndPutToList(obj:Object = null):FullGameData
		{
			var data:FullGameData = new FullGameData();
			
			if(obj)
			{
				data.id 	= obj.game_id;
				data.status = obj.status;
				
			}else{
			
				data.id++;
			}
			
			gameList[data.id] = data;						
			
			return data;
		}	
		
		public function deleteGameData(id:uint):void
		{
			if( gameList[id] )
			{				
//				gameList[id].destroy();
				delete gameList[id];
			}
		}
		
		public function getList():Dictionary
		{	
			return gameList;
		}
		
		public function getCurrentGameData():FullGameData
		{
			return currentGameData;
		}
		
		public function getComputerGameData():FullGameData
		{
			return gameDataWithComputer;
		}
	}
}