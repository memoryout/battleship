package app.model.social
{
	import org.puremvc.patterns.mediator.Mediator;
	
	public class SocialParser extends Mediator
	{
		public function SocialParser(viewComponent:Object=null)
		{
			super(viewComponent);
		}
	}
}