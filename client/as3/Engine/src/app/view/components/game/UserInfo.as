package app.view.components.game
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class UserInfo extends Sprite
	{
		private var _model:	mGame;		
		private var viewUserInfoWindow:	MovieClip;
		
		public function UserInfo(med:mGame=null)
		{
			super();
			
			_model = med as mGame;
			
			addLinks();
		}
		
		private function addLinks():void
		{
			viewUserInfoWindow = new viewUserInfo();
			addChild(viewUserInfoWindow);	
		}
	}
}