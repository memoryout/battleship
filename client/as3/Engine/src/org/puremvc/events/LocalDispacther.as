package org.puremvc.events
{
	import flash.utils.Dictionary;

	public class LocalDispacther
	{
		private var _events:			Dictionary
		
		public function LocalDispacther()
		{
			_events = new Dictionary();
		}
		
		public function addEventListener(event:uint, listener:Function):void
		{
			if(!_events[event]) _events[event] = new Vector.<Function>;
			
			var i:int, v:Vector.<Function>;
			v = _events[event];
			i = v.length;
			
			while(i--) if(v[i] == listener) return;
			
			v.push(listener);
			
		}
		
		public function removeEventListener(event:uint, listener:Function):void
		{
			if(!_events[event]) return;
			
			var i:int, v:Vector.<Function>;
			v = _events[event];
			i = v.length;
			
			while(i--)
			{
				if(v[i] == listener)
				{
					v.splice(i,1);
					return;
				}
			}
		}
		
		public function dispatch(event:uint, data:* = null):void
		{
			if(!_events[event]) return;
			
			var i:int, v:Vector.<Function>;
			v = _events[event];
			i = v.length;
			
			for(i = 0; i < v.length; i++) v[i]( data );
		}
		
		public function destroy():void
		{
			_events = null;
		}
	}
}