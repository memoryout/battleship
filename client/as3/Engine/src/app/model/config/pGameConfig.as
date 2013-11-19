package app.model.config
{
	import app.model.device.Device;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pGameConfig extends Proxy
	{
		public static const ERROR_LOAD:		uint = 0;
		public static const ERROR_PARSING:	uint = 1;
		public static const ERROR_SAVE:		uint = 2;
		public static const COMPLETE:		uint = 3;
		
		public static const NAME:			String = "proxy.Config";
		
		private const _config:			ConfigData = new ConfigData();
		
		public function pGameConfig()
		{
			super(NAME, null);
		}
		
		
		public function loadConfig(path:String):void
		{
			Device.get().openFile( path, onLoadFile, onErrorLoadFile );
		}
		
		public function getConfigData():ConfigData
		{
			return _config;
		}
		
		public function saveConfig(path:String):void
		{
			var saveData:Object = _config.serialize();
			var ba:ByteArray = new ByteArray();
			ba.writeObject( saveData );
			
			Device.get().saveFile(ba, path, onSaveFile, onErrorSaveFile );
		}
		
		private function onLoadFile(ba:ByteArray):void
		{
			parseData( ba.readObject() );
		}
		
		private function onErrorLoadFile(error:uint):void
		{
			this.dispatch( ERROR_LOAD );
		}
		
		public function parseData(data:Object):void
		{
			if(data)
			{
				_config.login = data.login;
				_config.pass = data.pass;
				_config.name = data.name;
			}
			else
			{
				this.dispatch( ERROR_PARSING );
				return;
			}
			
			this.dispatch( COMPLETE );
		}
		
		
		private function onSaveFile( data:Object = null ):void
		{
			
		}
		
		private function onErrorSaveFile( data:Object = null ):void
		{
			
		}
	}
}