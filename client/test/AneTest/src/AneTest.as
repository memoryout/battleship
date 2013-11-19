package
{
	import com.freshplanet.ane.AirDeviceId;
	
//	import device_id.src.com.freshplanet.ane.AirDeviceId;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class AneTest extends Sprite
	{
		public function AneTest()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;			
			
			var _time:Timer = new Timer(2000, 1);
			_time.addEventListener(TimerEvent.TIMER_COMPLETE, addTimer);
				_time.start();
			
//			Security.allowDomain("*");
//			Security.allowInsecureDomain("*");			
			
//			trace(air.getDeviceId("as"));			
			
//			
		}
		
		private function addTimer(e:TimerEvent):void
		{
			
			var air:AirDeviceId = new com.freshplanet.ane.AirDeviceId();
			
			var txt:TextField = new TextField();
			this.addChild(txt);
			txt.width = 400;
			txt.height = 400;
			txt.text = String(air);
			
			txt.text = air.getDeviceId("as");
		}
	}
}