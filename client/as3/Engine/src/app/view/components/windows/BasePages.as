package app.view.components.windows
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class BasePages extends Sprite
	{
		
		private static const OPEN_TIME:		Number = 0.3;
		private static const CLOSE_TIME:	Number = 0.3;
		
		private var _tween:			TweenLite;
		
		public var pageName:		String;
		
		public function BasePages()
		{
			this.alpha = 0;
		}
		
		public function reOpen():void
		{
			
		}
		
		public function open():void
		{
			if(_tween) _tween.kill();
			_tween = new TweenLite(this, OPEN_TIME, {alpha:1});
		}
		
		public function close():void
		{
			if(_tween) _tween.kill();
			_tween = new TweenLite(this, CLOSE_TIME, {alpha:0, onComplete:onClose});
		}
		
		protected function onClose():void
		{
			if(_tween) _tween.kill();
			_tween = null;
			
			this.parent.removeChild(this);
		}
	}
}