package app.controller.commands
{
	import app.controller.logic.AppLogic;
	import app.model.config.pGameConfig;
	import app.model.game.pShipsArray;
	import app.model.profiles.pUserProfileManager;
	import app.model.save.pSavedGame;
	import app.model.server.ServerParser;
	import app.model.server.pServer;
	import app.model.social.SocialParser;
	import app.model.social.pSocial;
	import app.view.components.mMainView;
	
	import flash.display.Stage;
	
	import org.puremvc.interfaces.INotification;
	import org.puremvc.patterns.command.SimpleCommand;
	
	public class cmdStartup extends SimpleCommand
	{		
		override public function execute( note:INotification ) :void    
		{  
			var root:Stage = (note.getBody() as Stage);		
			                     
//			facade.registerProxy( new pComputer() );            
			facade.registerProxy( new pShipsArray() );     
			//facade.registerProxy( new pShipsArrayCom() );     
			facade.registerProxy( new pServer() );   
			facade.registerProxy( new pSavedGame() );         
			facade.registerProxy( new pSocial() );
			facade.registerProxy( new pGameConfig() );
			facade.registerProxy( new pUserProfileManager() );
			
			facade.registerMediator( new ServerParser() );  
			facade.registerMediator( new SocialParser() );  
			
			
			facade.registerMediator( new AppLogic() );
			facade.registerMediator( new mMainView( root ) );
		}
	}
}