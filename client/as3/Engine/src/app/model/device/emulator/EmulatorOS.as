package app.model.device.emulator
{
	import app.model.device.DeviceInfo;
	import app.model.device.ITargetDeviceOS;
	
	import flash.utils.ByteArray;
	
	public class EmulatorOS implements ITargetDeviceOS
	{
		public function EmulatorOS()
		{
			
		}
		
		public function saveFile(ba:ByteArray, fileName:String, onSave:Function, onErrorSave:Function):void
		{
			var file:EmulatorFileStream = new EmulatorFileStream();
			file.save(fileName, ba, onSave, onErrorSave);
		}
		
		public function removeFile(fileName:String, onRemove:Function, onErrorRemove:Function):void
		{
			var file:EmulatorFileStream = new EmulatorFileStream();
			file.remove(fileName, onRemove, onErrorRemove);
		}
		
		public function openFile(fileName:String, onOpen:Function, onErrorOpen:Function):void
		{
			var file:EmulatorFileStream = new EmulatorFileStream();
			file.open(fileName, onOpen, onErrorOpen);
		}
		
		public function getAdvancedDeviceInfo(deviceInfo:DeviceInfo):void
		{
			
		}
	}
}