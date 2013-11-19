package app.model.events
{
	public class ModelEvents
	{
		public static const DEVICE_ID:						String = "events.pDevice.device_id";
		public static const SAVE_LOCAL_USER_INFO:			String = "events.pDevice.save";
		
		public static const AUTH_AUTHORIZATION_COMPLETE:	String = "events.pAuth.auth_complete";
		public static const DEVICE_ID_RECIVE:				String = "event.pAuth.device_id_recive";
		public static const GAME_MODE:						String = "app.view.events.menu.game_mode";		
									
		public static const SERVER_CONNECTION_ERROR:		String = "events.server.connection_error";
		
		public static const S_EVENTS_START:					String = "events.server.start_events";
		public static const S_UPDATE_USER_INFO:				String = "events.server.update_user_info";
		public static const S_USER_NOT_LOGIN:				String = "events.server.user_not_loged_in";
		public static const S_EVENTS_FINISH:				String = "events.server.finish_events";
		public static const S_USER_LOGED_SUCCSESS:			String = "events.server.user_loged_success";
		public static const S_NEW_USER_LOGED_SUCCSESS:		String = "events.server.new_user_loged_success";
		public static const S_NEW_USER_LOGIN_FAIL:			String = "events.server.user_login_fail";
		public static const S_GET_ACTIVE_GAME_LIST:			String = "events.server.get_active_game_list";
			
		public static const S_RECEIVE_LOGIN_INFO:			String = "events.server.loginInfo";
				
		public static const USER_PROFILE_ADD_NEW:			String = "events.profile.add_new_player";
				
		public static const CREATE_GAME:					String = "events.game.create_game";
		
		public static const START_GAME:						String = "events.game.start";
		
		public static const REMOVE_GAME_ON_SERVER:			String = "events.game.remove_game_on_server";
	}
}