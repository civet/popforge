package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonNormalNormal;
	import de.popforge.bitboy.assets.ButtonNormalOver;
	
	/**
	 * Button Normal for Playmode 'normal' (SongList in Sequence, not shuffled)
	 */
	public class NormalButton extends ButtonBase
	{
		public function NormalButton()
		{
			super( new ButtonNormalNormal(0,0), new ButtonNormalOver(0,0) );
		}
	}
}