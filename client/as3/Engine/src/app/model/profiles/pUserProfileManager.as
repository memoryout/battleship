package app.model.profiles
{
	import flash.utils.Dictionary;
	
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pUserProfileManager extends Proxy
	{
		public static const NAME:			String = "pUserProfileManager";
		
		private var _users:			Vector.<UserProfile>;
		private var _cachedUsers:	Dictionary;
		
		public function pUserProfileManager()
		{
			super(NAME);
			
			_users = new Vector.<UserProfile>;
			_cachedUsers = new Dictionary();
		}
		
		public function addUserData(uid:String, data:Object):void
		{
			if( _cachedUsers[uid] ) return;
			
			var user:UserProfile = new UserProfile();
			user.uid = uid;
			
			var par:String;
			for(par in user)
			{
				if(data[par] != undefined) user[par] = data[par];
			}
			
			_cachedUsers[uid] = user;
		}
		
		public function getUserProfile(uid:String):UserProfile
		{
			return _cachedUsers[uid];
		}
	}
}