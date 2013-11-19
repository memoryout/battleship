package app.model.device
{
	import flash.utils.ByteArray;

	public interface ITargetDeviceOS
	{
		function saveFile(ba:ByteArray, fileName:String, onSave:Function, onErrorSave:Function):void
		function openFile(fileName:String, onOpen:Function, onErrorOpen:Function):void
		function removeFile(fileName:String, onRemove:Function, onErrorRemove:Function):void
		function getAdvancedDeviceInfo( deviceInfo:DeviceInfo ):void
	}
}