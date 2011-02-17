package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonPauseNormal;
	import de.popforge.bitboy.assets.ButtonPauseOver;
	
	public class PauseButton extends ButtonBase
	{
		public function PauseButton()
		{
			super( new ButtonPauseNormal(0,0), new ButtonPauseOver(0,0) );
		}
	}
}