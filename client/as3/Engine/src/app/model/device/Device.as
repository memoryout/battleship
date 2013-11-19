package app.model.device
{
	import com.freshplanet.ane.AirDeviceId;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.puremvc.patterns.proxy.Proxy;
	import app.model.device.emulator.EmulatorOS;

	public class Device extends Proxy
	{
		private static const DEVICE_ID_SALT:		String = "123456789";
		
		public static const DEVICE_INIT:			uint = 0;
		
		
		private static const _this:			Device = new Device();
		
		
		private const _deviceInfo:		DeviceInfo = new DeviceInfo();
		
		private const _osList:			Dictionary = new Dictionary();
		
		private var _targetOS:			ITargetDeviceOS;
		
		public function Device()
		{
			if( _this == null )
			{
				_osList[ DeviceInfo.ANDROID ] = 	EmulatorOS;
				_osList[ DeviceInfo.EMULATOR ] =	EmulatorOS;
				_osList[ DeviceInfo.IOS ] = 		EmulatorOS;
			}
		}
		
		public static function get():Device
		{
			return _this;
		}
		
		public function initDevice():void
		{
			getBaseDeviceInfo();
		}
		
		public function getCurrentDeviceInfo():DeviceInfo
		{
			return null;
		}
		
		public function saveFile(ba:ByteArray, path:String, onSave:Function, onError:Function):void
		{
			if(_targetOS) _targetOS.saveFile(ba, path, onSave, onError);
		}
		
		public function openFile(path:String, onOpen:Function, onError:Function):void
		{
			trace("openFile", path);
			if(_targetOS) _targetOS.openFile(path, onOpen, onError);
		}
		
		public function removeFile(path:String, onRemove:Function, onError:Function):void
		{
			if(_targetOS) _targetOS.removeFile(path, onRemove, onError);
		}
		
		private function getBaseDeviceInfo():void
		{
			var airDeviceANE:AirDeviceId = AirDeviceId.getInstance();
			
			if( airDeviceANE )
			{
				if( airDeviceANE.isOnAndroid ) 
				{
					_deviceInfo.OS = DeviceInfo.ANDROID;
					_deviceInfo.deviceId = airDeviceANE.getDeviceId( DEVICE_ID_SALT );
				}
					
				else if( airDeviceANE.isOnIOS ) 
				{
					_deviceInfo.OS = DeviceInfo.IOS;
					_deviceInfo.deviceId = airDeviceANE.getDeviceId( DEVICE_ID_SALT );
				}
				else 
				{
					_deviceInfo.OS = DeviceInfo.EMULATOR;
				}
			}
			
			createTargetOS();
			
			this.dispatch( DEVICE_INIT, _deviceInfo );
		}
		
		
		private function createTargetOS():void
		{
			if( _osList[ _deviceInfo.OS ] )
			{
				_targetOS = new _osList[ _deviceInfo.OS ]();
			}
		}
	}
}