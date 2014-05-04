package app
{
	import flash.filesystem.File;
	
	public class GlobalSettings
	{
		public static const SERVER_URL:			String = "http://wid.com.ua/game_server_stable/service.php";

		public static const CONFIG_FILE_NAME:	String = "/conf.dat";
		public static const SAVED_GAMES_FILE:	String = "/save.dat";
		
		public static const PATH			:	String =  File.applicationStorageDirectory.nativePath;
		
		public static const DEFAULT_WIDTH:		Number = 768;
		public static const DEFAULT_HEIGHT:		Number = 1280;
	}
}