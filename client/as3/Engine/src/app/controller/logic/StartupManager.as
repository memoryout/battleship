package app.controller.logic
{
	import app.GlobalSettings;
	import app.controller.events.AppEvents;
	import app.model.config.ConfigData;
	import app.model.config.pGameConfig;
	import app.model.device.Device;
	import app.model.device.DeviceInfo;
	import app.model.events.ModelEvents;
	import app.model.server.ServerParser;
	import app.model.server.pServer;
	import app.view.events.MenuEvents;
	import app.view.events.WindowsEvents;
	
	import com.adobe.crypto.MD5;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class StartupManager extends Mediator
	{
		private var _deviceInfo:				DeviceInfo;
	
		private var _configProxy:				pGameConfig;
		
		private var _serverProxy:				pServer;
		
		public function StartupManager(viewComponent:Object=null)
		{
			super(viewComponent);
			
			_serverProxy = this.facade.retrieveProxy(pServer.NAME) as pServer;
			_serverProxy.addEventListener(pServer.ERROR_CONNECTION, handlerErrorConnection);
			_serverProxy.addEventListener(pServer.ERROR_PARSING, handlerErrorParsing);
			
			
			_configProxy = this.facade.retrieveProxy(pGameConfig.NAME) as pGameConfig;
		}
		
		//----------------------------------------- override ------------
		public override function getMediatorName():String
		{
			return "StartupManager";
		}
		
		public override function listNotificationInterests():Array
		{
			return [
						MenuEvents.USER_SET_NAME,
						ModelEvents.S_NEW_USER_LOGED_SUCCSESS,
						ModelEvents.S_NEW_USER_LOGIN_FAIL
					]
		}
		
		public override function handleNotification(notification:INotification):void
		{
			
			var eventName:String = notification.getName();
			var eventBody:Object = notification.getBody();
			
			switch(eventName)
			{							
				case MenuEvents.USER_SET_NAME:
				{
					_configProxy.getConfigData().name = String( notification.getBody() );
					
					makeNewUserAuthorization();
					break;
				}
					
				case ModelEvents.S_NEW_USER_LOGIN_FAIL:
				{
					showLoginDialog();
					break;
				}
					
				case ModelEvents.S_NEW_USER_LOGED_SUCCSESS:
				{
					saveLoginInfo(eventBody);
					
					_serverProxy.setKey( eventBody.loginInfo.session );
					
					sendStartupComplete();
					break;
				}
			}
		}		
		
		//----------------------------------------- public ------------
		
		/**
		 * 1) Call auth module authorization.
		 * next: waiting events ModelEvents.AUTH_AUTHORIZATION_COMPLETE or ModelEvents.SERVER_CONNECTION_ERROR
		 * */
		public function startup():void
		{
			this.sendNotification(WindowsEvents.OPEN_WINDOW, "debug");
			
			initDevice();
			
			
			//getDeviceInfo();
		}
		
		
		//----------------------------------------- private ------------
		
		private function initDevice():void
		{
			Device.get().addEventListener( Device.DEVICE_INIT, handlerDeviceInited);
			Device.get().initDevice();
		}
		
		private function handlerDeviceInited(info:DeviceInfo):void
		{
			Device.get().removeEventListener( Device.DEVICE_INIT, handlerDeviceInited);
			
			_deviceInfo = info;			
			
			loadConfigFile();
		}
		
		private function loadConfigFile():void
		{
			_configProxy.addEventListener(pGameConfig.COMPLETE, onLoadConfigFile );
			_configProxy.addEventListener(pGameConfig.ERROR_LOAD, onErrorLoadConfigFile );
			_configProxy.addEventListener(pGameConfig.ERROR_PARSING, onErrorPasingConfigFile );
			
			_configProxy.loadConfig( GlobalSettings.PATH + GlobalSettings.CONFIG_FILE_NAME );
		}
		
		private function onErrorLoadConfigFile(error:uint):void
		{
			showLoginDialog();
			
			_configProxy.removeEventListener(pGameConfig.COMPLETE, onLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_LOAD, onErrorLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_PARSING, onErrorPasingConfigFile );
		}
		
		private function onErrorPasingConfigFile(error:Error):void
		{
			_configProxy.removeEventListener(pGameConfig.COMPLETE, onLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_LOAD, onErrorLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_PARSING, onErrorPasingConfigFile );
			
			trace("onErrorPasingConfigFile");
		}
		
		private function onLoadConfigFile(ba:ByteArray):void
		{
			_configProxy.removeEventListener(pGameConfig.COMPLETE, onLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_LOAD, onErrorLoadConfigFile );
			_configProxy.removeEventListener(pGameConfig.ERROR_PARSING, onErrorPasingConfigFile );
			
			if( _deviceInfo.OS == DeviceInfo.EMULATOR )
			{
				if( !_configProxy.getConfigData().key ) 
				{
					_configProxy.getConfigData().key = MD5.hash( ( (Math.random() * ( new Date().time )).toString() ) );
					_configProxy.saveConfig( GlobalSettings.PATH + GlobalSettings.CONFIG_FILE_NAME );
				}
				
				_deviceInfo.deviceId = _configProxy.getConfigData().key;
			}
			
			tryAuthorizationOnServer();
		}
		
		
		private function tryAuthorizationOnServer():void
		{			
			_serverProxy.newUser( _configProxy.getConfigData().login, _configProxy.getConfigData().pass );
		}		
		
		private function showLoginDialog():void
		{
			this.sendNotification(MenuEvents.SHOW_MENU);
			this.sendNotification(MenuEvents.SHOW_LOGIN);
		}
		
		
		private function makeNewUserAuthorization():void
		{
			_serverProxy.newUser( _deviceInfo.deviceId, _configProxy.getConfigData().name );
		}
		
		
		private function handlerErrorConnection(error:String):void
		{
			sendStartupComplete();
		}
		
		private function handlerErrorParsing( data:String ):void
		{
			sendStartupComplete();
		}
		
		
		private function saveLoginInfo(data:Object):void
		{
			var configData:ConfigData = _configProxy.getConfigData();
			
			if(data.loginInfo &&  data.loginInfo.login && data.loginInfo.pass)
			{
				configData.login = data.loginInfo.login;
				configData.pass = data.loginInfo.pass;
				
				_configProxy.saveConfig( GlobalSettings.PATH + GlobalSettings.CONFIG_FILE_NAME );
			}
		}
		
		
		private function sendStartupComplete():void
		{
			this.sendNotification(MenuEvents.HIDE_STARTUP_PAGE);
			
			this.sendNotification(AppEvents.START_UP_COMPLETE);
			this.facade.removeMediator( this.getMediatorName() );
			
			_deviceInfo = null;
			_serverProxy = null;
			_configProxy = null;
			
			this.facade = null;
		}
	}
}