package
{
	import de.popforge.widget.fl909.FL909Player;
	
	import flash.display.Sprite;
	
	[SWF( backgroundColor='0xffffff', frameRate='80', width='580', height='262')]

	public class FL909App extends Sprite
	{
		private var player: FL909Player;
		
		public function FL909App()
		{
			player = new FL909Player();
			addChild( player );
		}
	}
}
