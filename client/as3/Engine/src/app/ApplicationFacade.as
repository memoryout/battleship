package app
{   
    import app.controller.commands.cmdStartup;
    
    import flash.display.DisplayObject;
    import flash.display.Stage;
    
    import org.puremvc.interfaces.*;
    import org.puremvc.patterns.facade.*;
    import org.puremvc.patterns.observer.Notification;
    import org.puremvc.patterns.observer.Observer;
    import org.puremvc.patterns.proxy.*;

    /**
     * A concrete <code>Facade</code> for the application.
     * <P>
     * The main job of the <code>ApplicationFacade</code> is to act as a single 
     * place for mediators, proxies and commands to access and communicate
     * with each other without having to interact with the Model, View, and
     * Controller classes directly. All this capability it inherits from 
     * the PureMVC Facade class.</P>
     * 
     * <P>
     * This concrete Facade subclass is also a central place to define 
     * notification constants which will be shared among commands, proxies and
     * mediators, as well as initializing the controller with Command to 
     * Notification mappings.</P>
     */
    public class ApplicationFacade extends Facade
    {
        
        // Notification name constants
        public static const CMD_STARTUP:String              = "cmdStartup";         
		
		public static const SHOW_MENU:String                = "showMenu";     
		public static const SHOW_LOGIN:String               = "showLogin";    
        /**
         * Startup method 
         */
        public function startup( root:Stage ) : void {
            notifyObservers( new Notification( ApplicationFacade.CMD_STARTUP, root ) );
        }
                
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController( ) : void 
        {
            super.initializeController();           
            registerCommand( CMD_STARTUP,       	cmdStartup  );   		
        }        
        
        /**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance() : ApplicationFacade 
        {
            if ( instance == null ) instance = new ApplicationFacade( );
            return instance as ApplicationFacade;
        }        
    }
}
