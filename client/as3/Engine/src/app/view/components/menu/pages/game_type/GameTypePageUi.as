package app.view.components.menu.pages.game_type
{
	import app.model.game.FullGameData;
	import app.model.game.GameList;
	import app.model.game.MainGameData;
	import app.view.components.menu.BaseMenuPage;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class GameTypePageUi extends BaseMenuPage
	{	
		private var _model:					GameTypePage;
		
		private var addPlayer:				SimpleButton;
		private var computerPullButton:		SimpleButton;
		
		private var activeGameView:			MovieClip;
		private var _gameList:				MovieClip;
		private var gameListMask:			MovieClip;
		
		private var _hInit:					DisplayObject;
		
		private var gameContainer:			Sprite;		
		private var arrayOfActiveGame:		Array = new Array();
		private var currentElementCounter:	int;
		
		private var yOffset:				Number = 0;		
		
		private var _tween:					TweenLite;
		
		private var deltaY:					Number = 0;
		
		private var selectedElement:		MovieClip;
		private var selectedForRemoveElement:MovieClip;
				
		public function GameTypePageUi()
		{
			super();
			
			addLinks();
			addListeners();
			
			_model = new GameTypePage(this);		
		}
		
		public override function switchToOffline():void
		{
			if(addPlayer) 
			{
				addPlayer.removeEventListener(MouseEvent.MOUSE_DOWN, addPlayerBtnClick);
				addPlayer.enabled = false;
				addPlayer.alpha = 0.5;
			}				
		}
		
		protected override function onClose():void
		{		
			activeGameView = null;
			
			_model.destroy();
			_model = null;
			
			super.onClose();
		}
		
		private function addLinks():void
		{
			activeGameView = new viewActiveGame();
			addChild(activeGameView);		
			
			_hInit = activeGameView;
			
			addPlayer 				= activeGameView.getChildByName("allPlayer") as SimpleButton;	
			computerPullButton  	= activeGameView.getChildByName("computerPullBtn") as SimpleButton;		
		}
		
		private function addListeners():void
		{
			addPlayer.addEventListener(MouseEvent.MOUSE_DOWN, 		   addPlayerBtnClick);
			computerPullButton.addEventListener(MouseEvent.MOUSE_DOWN, addComputerBtnClick);			
		}
		
		private function addPlayerBtnClick(e:MouseEvent):void
		{
			_model.addPlayerClick();
		}
		
		private function addComputerBtnClick(e:MouseEvent):void
		{
			_model.computerPullClick();
		}	
		
		public function blockButton(val:Object):void
		{			
			mouseEnabled = !(val as Boolean);
			mouseChildren = !(val as Boolean);
		}
	}
}