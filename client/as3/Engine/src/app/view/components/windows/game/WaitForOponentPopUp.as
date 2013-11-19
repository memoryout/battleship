package app.view.components.windows.game
{
	import app.view.components.windows.BasePages;
	
	import flash.display.MovieClip;
	
	public class WaitForOponentPopUp extends BasePages
	{
		private var _model:						mWaitForOponentPopUp;
		private var _waitForOponentPopUpView:	MovieClip;
		
		public function WaitForOponentPopUp()
		{
			super();
			
			_waitForOponentPopUpView = new viewWaitForOponentPopUp();
			addChild(_waitForOponentPopUpView);	
			
			_model = new mWaitForOponentPopUp(this);
		}
		
		public function showPopUp():void
		{
			
		}
	}
}