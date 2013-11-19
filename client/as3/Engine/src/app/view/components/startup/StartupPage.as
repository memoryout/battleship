package app.view.components.startup
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class StartupPage extends Sprite
	{
		private var _skin:			MovieClip;
		
		public function StartupPage()
		{
			super();
			
			_skin = new viewLoaderWindow();
			this.addChild(_skin);
		}
		
		public function destroy():void
		{
			this.parent.removeChild(this);
		}
	}
}