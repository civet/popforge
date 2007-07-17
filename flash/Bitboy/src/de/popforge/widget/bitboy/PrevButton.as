package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonPrevNormal;
	import de.popforge.bitboy.assets.ButtonPrevOver;
	
	public class PrevButton extends ButtonBase
	{
		private var player: BitboyPlayer;
		
		public function PrevButton( player: BitboyPlayer )
		{
			super( new ButtonPrevNormal(0,0), new ButtonPrevOver(0,0) );
			
			this.player = player;
		}
		
		public override function onRelease(): void
		{
			player.prev();
		}
	}
}