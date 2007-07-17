package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.bitboy.BitBoy;
	import de.popforge.bitboy.assets.ButtonStopNormal;
	import de.popforge.bitboy.assets.ButtonStopOver;
	
	public class StopButton extends ButtonBase
	{
		private var player: BitboyPlayer;
		
		public function StopButton( player: BitboyPlayer )
		{
			super( new ButtonStopNormal(0,0), new ButtonStopOver(0,0) );
			
			this.player = player;
		}
		
		public override function onRelease(): void
		{
			player.stop();
		}
	}
}