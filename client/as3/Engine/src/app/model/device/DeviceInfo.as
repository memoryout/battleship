package app.model.device
{
	public class DeviceInfo
	{
		public static const EMULATOR:	uint = 0;
		public static const ANDROID:	uint = 1;
		public static const IOS:		uint = 2;
		
		
		public var deviceId:			String = "ka";
		public var OS:					uint;
		
		
		public var name:String;
		public var id:String;
	}
}