package app.view.components.windows.loader
{
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class LoaderWindow extends Sprite
	{
		private var loaderView:MovieClip;
		
		public function LoaderWindow()
		{
			super();
			
			addLinks();
		}
		
		private function addLinks():void
		{
			loaderView = new viewLoaderWindow();
		}
	}
}