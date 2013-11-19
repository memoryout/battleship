package app.view.events
{
	public class GameEvents
	{
		public static const SHOW_SHIP_LOCATION:				String = "app.view.events.game.show_ship_location";
		public static const SHOW_GAME:						String = "app.view.events.game.show_game";
		
		public static const GET_GAME_DATA:					String = "app.view.events.game.get_game_data";
		public static const SHUFFLE_SHIPS_POSITION:			String = "app.view.events.game.shuffle_ships_array";		
		public static const PLACE_SHIPS:					String = "app.view.events.game.set_ships_array";			//set ships in ships location table
		public static const SET_SHIPS_POSITION_IN_GAME:		String = "app.view.events.game.set_ships_array_in_game";
		public static const GET_GAME_STATUS:				String = "app.view.events.game.get_game_status";
		
		public static const GET_COMPUTER_SHIPS_POSITION:	String = "app.view.events.game.get_computer_ships_array";
		public static const SET_COMPUTER_SHIPS_POSITION:	String = "app.view.events.game.set_computer_ships_array";
		
		public static const SAVE_PLAYER_SHIPS:				String = "app.view.events.game.save_player_ships";
		public static const SAVE_COMPUTER_SHIPS:			String = "app.view.events.game.save_computer_ships";
		
		public static const SEND_POSITION_OF_SELECTED_CELL_TO_VERIFYING:		String = "app.view.events.game.send_position_of_selected_cell_to_verifying";
		public static const UPDATE_OPONENT_FIELD:			String = "app.view.events.game.update_computer_field";
		public static const UPDATE_USER_FIELD:			String = "app.view.events.game.update_player_field";
		
		public static const LOCK_OPONENT_FIELD:			String = "app.view.events.game.lock_computer_field";
		
		public static const INIT_COMPTER_LOGIC:				String = "app.view.events.game.init_computer_logic";
		
		public static const SHOW_FINISH_POP_UP:				String = "app.view.events.game.show_finish_pop_up";
		
		public static const SET_WINNER:						String = "app.view.events.game.set_winner";
		public static const DESTROY_GAME:					String = "app.view.events.game.destroy_game";
		
		public static const EXIT_TO_MENU:					String = "app.view.events.game.exit_to_menu";
		public static const SAVE_GAME_DATA:					String = "app.view.events.game.save_game_data";
		public static const SHOW_MENU_PAGE:					String = "app.view.events.game.show_menu_page";
		
		public static const SHOW_PLAYER_MOVE:				String = "app.view.events.game.player_move";
		public static const SHOW_COM_MOVE:					String = "app.view.events.game.com_move";
		public static const MOVE_END:						String = "app.view.events.game.move_end";
		
		public static const SWITCH_GAME_DATA:				String = "app.view.events.game.switch_game_data";
		public static const STOP_GAME:						String = "app.view.events.game.stop_game";
		
		public static const IS_POSSIBLE_TO_SHOW_GAME:		String = "app.view.events.game.is_possible_to_show_game";	//showing game windoew after get request with "game_status"
	
		public static const UPDATE_GAME:					String = "app.view.events.game.update_game"; // update game after get "notification" in "active_games" server request
		
		public static const STOP_COMPUTER_LOGIC:			String = "app.view.events.game.stop_computer_logic"; // stop logic wich is responsible for computer movement
	}
}