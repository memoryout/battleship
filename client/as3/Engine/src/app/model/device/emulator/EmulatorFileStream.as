package app.model.device.emulator
{
	import app.model.device.DeviceOSConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import org.puremvc.events.LocalDispacther;

	public class EmulatorFileStream extends LocalDispacther
	{
		private static const ON_OPEN:			uint = 0;
		private static const ON_ERROR_OPEN:		uint = 1;
		private static const ON_SAVE:			uint = 2;
		private static const ON_ERROR_SAVE:		uint = 3;
		private static const ON_REMOVE:			uint = 4;
		private static const ON_ERROR_REMOVE:	uint = 5;		
		
		private var _path:				String;
		private var _stream:			FileStream;
		
		public function EmulatorFileStream()
		{
			
		}
		
		
		public function open(path:String, onLoad:Function, onError:Function):void
		{
			this.addEventListener(ON_OPEN, onLoad);
			this.addEventListener(ON_ERROR_OPEN, onError);
			
			if(path == "")
			{
				this.dispatch(ON_ERROR_OPEN, DeviceOSConstants.ERROR_FILE_PATH);
				return;
			}
			
			var file:File = new File(path);
			_stream = new FileStream();
			_stream.addEventListener(Event.COMPLETE, handlerCompleteOpen);
			_stream.addEventListener(IOErrorEvent.IO_ERROR, handlerErrorOpen);
			
			_stream.openAsync( file, FileMode.READ ); 
		}
		
		public function save(path:String, data:ByteArray, onSave:Function, onError:Function):void
		{
			this.addEventListener(ON_SAVE, onSave);
			this.addEventListener(ON_ERROR_SAVE, onError);
			
			if(path == "")
			{
				this.dispatch( ON_ERROR_SAVE, DeviceOSConstants.ERROR_FILE_PATH );
				return;
			}
			
			var file:File = new File(path);
			
			_stream = new FileStream();
			
			try
			{
				_stream.open(file, FileMode.WRITE);
			
				_stream.writeBytes(data, 0, data.bytesAvailable);
				_stream.close();
			}
			catch(error:Error)
			{
				this.dispatch( ON_ERROR_SAVE, DeviceOSConstants.ERROR_SAVE_FILE );
				return;
			}
			
			this.dispatch(ON_SAVE);
		}
		
		public function remove(path:String, onSave:Function, onError:Function):void
		{
			this.addEventListener(ON_REMOVE, onSave);
			this.addEventListener(ON_ERROR_REMOVE, onError);
			
			if(path == "")
			{
				this.dispatch( ON_ERROR_REMOVE, DeviceOSConstants.ERROR_FILE_PATH );
				return;
			}
			
			var file:File = new File(path);		
			
			try
			{
				file.deleteFile();				
			}
			catch(error:Error)
			{
				this.dispatch( ON_ERROR_REMOVE, DeviceOSConstants.ERROR_REMOVE_FILE);
				return;
			}
			
			this.dispatch(ON_REMOVE);
		}
		
		
		//------------------ open listeners --------------------------
		private function handlerCompleteOpen(e:Event):void
		{
			_stream.removeEventListener(Event.COMPLETE, handlerCompleteOpen);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorOpen);
			
			var ba:ByteArray = new ByteArray();
			_stream.readBytes(ba, 0, _stream.bytesAvailable);
			
			this.dispatch(ON_OPEN, ba);
			
			_stream.close();
			_stream = null;
		}
		
		
		private function handlerErrorOpen(e:IOErrorEvent):void
		{
			_stream.removeEventListener(Event.COMPLETE, handlerCompleteOpen);
			_stream.removeEventListener(IOErrorEvent.IO_ERROR, handlerErrorOpen);
			
			this.dispatch(ON_ERROR_OPEN, DeviceOSConstants.ERROR_OPEN_FILE);
		}
	}
}