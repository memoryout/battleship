package app.model.game
{
	public class Ship
	{
		public var column:		int;
		public var line:		int;
		
		public var orient:	int;
		public var deck:	int;
		
		public var drowned:	Boolean;
		
		public var coordinates:Array;
		
		public function Ship(){}
	}
}