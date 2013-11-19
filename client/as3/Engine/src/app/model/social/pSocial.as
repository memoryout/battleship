package app.model.social
{
	import org.puremvc.patterns.proxy.Proxy;
	
	public class pSocial extends Proxy
	{
		public static const NAME:			String = "pSocial";
		
		public function pSocial(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
		}
	}
}