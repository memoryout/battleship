/*
 PureMVC - Copyright(c) 2006, 2007 FutureScale, Inc., Some rights reserved.
 Your reuse is governed by the Creative Commons Attribution 3.0 United States License
*/
package org.puremvc.patterns.proxy
{
	import flash.utils.Dictionary;
	
	import org.puremvc.interfaces.*;
	import org.puremvc.patterns.facade.Facade;
	import org.puremvc.patterns.observer.*;
	
	/**
	 * A base <code>IProxy</code> implementation. 
	 * 
	 * <P>
	 * In PureMVC, <code>Proxy</code> classes are used to manage parts of the 
	 * application's data model. </P>
	 * 
	 * <P>
	 * A <code>Proxy</code> might simply manage a reference to a local data object, 
	 * in which case interacting with it might involve setting and 
	 * getting of its data in synchronous fashion.</P>
	 * 
	 * <P>
	 * <code>Proxy</code> classes are also used to encapsulate the application's 
	 * interaction with remote services to save or retrieve data, in which case, 
	 * we adopt an asyncronous idiom; setting data (or calling a method) on the 
	 * <code>Proxy</code> and listening for a <code>Notification</code> to be sent 
	 * when the <code>Proxy</code> has retrieved the data from the service. </P>
	 * 
	 * @see org.puremvc.core.model.Model Model
	 */
	public class Proxy extends Notifier implements IProxy, INotifier
	{

		public static var NAME:String = 'Proxy';
		
		/**
		 * Constructor
		 */
		public function Proxy( proxyName:String=null, data:Object=null ) 
		{
			
			this.proxyName = (proxyName != null)?proxyName:NAME; 
			if (data != null) setData(data);
		}

		/**
		 * Get the proxy name
		 */
		public function getProxyName():String 
		{
			return proxyName;
		}		
		
		/**
		 * Set the data object
		 */
		public function setData( data:Object ):void 
		{
			this.data = data;
		}
		
		/**
		 * Get the data object
		 */
		public function getData():Object 
		{
			return data;
		}		
		
		// the proxy name
		protected var proxyName:String;
		
		// the data object
		protected var data:Object;
		
		
		
		//------- local event sending -----------
		
		
		private var _events:			Dictionary = new Dictionary();
		
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
	}
}