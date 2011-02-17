package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonLoopNormal;
	import de.popforge.bitboy.assets.ButtonLoopOver;
	
	/**
	 * LoopButton
	 */
	public class LoopButton extends ButtonBase
	{
		public function LoopButton()
		{
			super( new ButtonLoopNormal(0,0), new ButtonLoopOver(0,0) );
		}
	}
}