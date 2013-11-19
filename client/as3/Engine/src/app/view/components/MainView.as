package app.view.components
{
	import app.GlobalSettings;
	import app.view.components.startup.StartupPage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class MainView extends Sprite
	{
		private var _gameSprite:		Sprite;
		private var _menuSprite:		Sprite;
		private var _windowSprite:		Sprite;
		
		private var _startupSprite:		StartupPage;
		
		private var _scaleKoef:			Number;
		
		private var _defaultWidth:		Number;
		private var _defaultHeight:		Number;
		
		private var _background:		Shape;
		
		public function MainView()
		{
			super();
						
			this.addEventListener(Event.ADDED_TO_STAGE, handlerAdded);
		}
		
		private function handlerAdded(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handlerAdded);
			
			updateStageSize();			
			initLayers();
			
			this.stage.frameRate = 60;
		}
		
		private function initLayers():void
		{
			_gameSprite = new Sprite();
			this.addChild(_gameSprite);
			
			_menuSprite = new Sprite();
			this.addChild(_menuSprite);
			
			_windowSprite = new Sprite();
			this.addChild(_windowSprite);
		}
		
		public function showStartupPage():void
		{
			_startupSprite = new StartupPage();
			this.addChildAt(_startupSprite, 0);
		}
		
		public function removeStartupPage():void
		{
			if(_startupSprite)
			{
				_startupSprite.destroy();
				_startupSprite = null;
			}
		}
		
		public function get menuLayer():Sprite
		{
			return _menuSprite;
		}
		
		public function get gameLayer():Sprite
		{
			return _gameSprite;
		}
		
		public function get windowsLayer():Sprite
		{
			return _windowSprite;
		}
		
		public function updateStageSize():void
		{
			var wideSide:Number = Math.max(this.stage.fullScreenWidth, this.stage.fullScreenHeight);
			
			if(wideSide < _defaultHeight)
			{
				this.height = wideSide;
				this.scaleX = this.scaleY
				//this.scaleY = this.scaleX = wideSide/_defaultHeight;
			}			
		}
		
		public function setDefaultContentSize(wid:Number, heig:Number):void
		{
			_defaultWidth = wid;
			_defaultHeight = heig;
			
			_background = new Shape();
			this.addChildAt(_background, 0);
			
			_background.graphics.beginFill(0);
			_background.graphics.drawRect(0,0, _defaultWidth,_defaultHeight);
			_background.graphics.endFill();
		}
	}
}