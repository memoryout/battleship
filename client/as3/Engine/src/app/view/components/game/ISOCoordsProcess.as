package app.view.components.game
{	
	import flash.geom.Point;	
	/**
	 * ...
	 * @author memoryout
	 */
	public class ISOCoordsProcess
	{
		private static var _this:				ISOCoordsProcess = null;
		
		private var _alpha:		Number
		private var _cos:		Number;
		private var _sin:		Number;
		
		private var _cellSize:	Number;
		
		public function ISOCoordsProcess() 
		{
			alpha = 30;
			_cellSize = 31.5;
		}
		
		public static function get Get():ISOCoordsProcess
		{
			if (_this == null) _this = new ISOCoordsProcess();
			return _this;
		}
		
		public function toReal(x:Number, y:Number, z:Number = 0):Point
		{
			var point:Point = new Point();
			point.x = (x - y) * _cos;
			point.y = (x + y) * _sin - z;
			return point;
		}
		
		public function toIso(x:Number, y:Number, z:Number = 0):Point
		{
			var point:Point = new Point();
			point.y = ( (y + z) / _sin - x / _cos) * 0.5;
			point.x = x / _cos + point.y;
			return point;
		}
		
		public function set alpha(alp:Number):void
		{
			_alpha = Math.PI * alp / 180;
			_cos = Math.cos(_alpha);
			_sin = Math.sin(_alpha);
		}
		
		public function get alpha():Number
		{
			return _alpha * 180 / Math.PI;
		}
		
		public function set cellSize(num:Number):void
		{
			_cellSize = num;
//			sdispatchEvent(IsoEventDescription.ISO_CELL_SIZE_CHANGED);
		}
		
		public function get cellSize():Number
		{
			return _cellSize;
		}	
	}
}