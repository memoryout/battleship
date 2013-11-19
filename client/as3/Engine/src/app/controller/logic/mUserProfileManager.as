package app.controller.logic
{
	import app.controller.events.AppEvents;
	import app.model.profiles.pUserProfileManager;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.mediator.Mediator;
	
	public class mUserProfileManager extends Mediator
	{
		private var _userDataManager:			pUserProfileManager;
		
		public function mUserProfileManager()
		{
			super();
		}
		
		public override function listNotificationInterests():Array
		{
			return [
					AppEvents.GET_USER_PROFILE,
					AppEvents.CREATE_DEFAULT_PROFILE,
					AppEvents.CREATE_AI_PROFILE
					];
		}
		
		public override function handleNotification(notification:INotification):void
		{
			var eventName:String = notification.getName();
			
			switch(eventName)
			{
				case AppEvents.CREATE_DEFAULT_PROFILE:
				{
					createDefaultUserProfile();
					break;
				}
					
				case AppEvents.CREATE_AI_PROFILE:
				{
					createAIProfile();
					break;
				}	
			}
		}
		
		private function createDefaultUserProfile():void
		{
			
		}
		
		private function createAIProfile():void
		{
			
		}
	}
}