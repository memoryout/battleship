package app.model.game
{
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pGame extends Proxy
	{
		public static const WAIT_FOR_USER_SHIPS:		uint = 0;
		public static const WAIT_FOR_OPPONENT_SHIPS:	uint = 1;
		public static const WAIT_FOR_USER_STEP:			uint = 2;
		public static const WAIT_FOR_OPPONENT_STEP:		uint = 3;
		
		public static const ERROR_LOAD_GAME:			uint = 4;
		public static const ERROR_UNLOAD_GAME:			uint = 5;
		public static const GAME_UNLOADED:				uint = 6;
		public static const GAME_LOADED:				uint = 7;
		
		public static const WAIT_FOR_OPPONENT:			uint = 8;
		
		public static const NAME:						String = "pGame";
		
		
		
		
		private var _currentGameData:			FullGameData;
		
		public function pGame(proxyName:String=null, data:Object=null)
		{
			super(NAME);
		}
		
		public function loadGame(id:uint):void
		{
			if( _currentGameData ) unloadCurrentGame();
			
			
			_currentGameData = GameList.Get().getGameData( id );
			
			
			if( _currentGameData.opponentType == FullGameData.OPPONENT_COMPUTER )
			{
				// set computer current GameData object.
			}
			
			parserGameStatus();
			
		}
		
		public function unloadCurrentGame():void
		{
			this.dispatch( GAME_UNLOADED );
			
			// reset computer
		}
		
		
		private function parserGameStatus():void
		{
			switch( _currentGameData.status )
			{
				case FullGameData.WAIT_FOR_OPPONENT:
				{
					break;
				}
					
				case FullGameData.WAIT_ENEMY_SHIPS:
				{
					break;
				}
				
				case FullGameData.WAIT_FOR_OPPONENT:
				{
					break;
				}
					
				case FullGameData.WAIT_OPPONENT_STEP:
				{
					break;
				}
				
				case FullGameData.WAIT_USER_STEP:
				{
					break;
				}
				
				case FullGameData.GAME_FINISHED:
				{
					
					break;
				}
			}
		}
	}
}