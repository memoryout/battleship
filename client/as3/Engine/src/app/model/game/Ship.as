package app.model.game
{
	public class Ship
	{
		public var column:		int;
		public var line:		int;
		
		public var direction:	int;
		public var deck:	int;
		
		public var drowned:	Boolean;
		
		public var coordinates:Vector.<Array> = new Vector.<Array>;
	
		public function Ship(){}
	}
}