package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonShuffleNormal;
	import de.popforge.bitboy.assets.ButtonShuffleOver;
	
	public class ShuffleButton extends ButtonBase
	{
		public function ShuffleButton()
		{
			super( new ButtonShuffleNormal(0,0), new ButtonShuffleOver(0,0) );
		}
	}
}