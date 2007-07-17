package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonNextNormal;
	import de.popforge.bitboy.assets.ButtonNextOver;
	
	public class NextButton extends ButtonBase
	{
		private var player: BitboyPlayer;
		
		public function NextButton( player: BitboyPlayer )
		{
			super( new ButtonNextNormal(0,0), new ButtonNextOver(0,0) );
			
			this.player = player;
		}
		
		public override function onRelease(): void
		{
			player.next();
		}
	}
}