package app.model.game
{
	public class MainGameData
	{
		private var _id:			uint;
		private var _status:		uint;
		private var _game_time:		uint;
		private var _time_out:		uint;
		private var _nonification:	Object;
		
		public function MainGameData(){}
		
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
		
		public function get gameTime():uint
		{
			return _game_time;
		}
		
		public function set gameTime(val:uint):void
		{
			_game_time = val;
		}
		
		public function get timeOut():uint
		{
			return _time_out;
		}
		
		public function set timeOut(val:uint):void
		{
			_time_out = val;
		}
		
		public function get notification():Object
		{
			return _nonification;
		}
		
		public function set notification(val:Object):void
		{
			_nonification = val;
		}
	}
}