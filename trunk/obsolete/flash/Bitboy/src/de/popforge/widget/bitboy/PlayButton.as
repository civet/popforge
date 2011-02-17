package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonPlayNormal;
	import de.popforge.bitboy.assets.ButtonPlayOver;
	
	public class PlayButton extends ButtonBase
	{
		public function PlayButton()
		{
			super( new ButtonPlayNormal(0,0), new ButtonPlayOver(0,0) );
		}
	}
}