package app.model.config
{
	public class ConfigData
	{
		public var pass:		String;
		public var login:		String;
		public var name:		String;
		public var key:			String;
		
		public function serialize():Object
		{
			var obj:Object = new Object();
			obj.pass = pass;
			obj.login = login;
			obj.name = name;
			obj.key = key;
			
			return obj;
		}
	}
}