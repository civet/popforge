package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonLinearNormal;
	import de.popforge.bitboy.assets.ButtonLinearOver;
	
	/**
	 * LinearButton
	 */
	public class LinearButton extends ButtonBase
	{
		public function LinearButton()
		{
			super( new ButtonLinearNormal(0,0), new ButtonLinearOver(0,0) );
		}
	}
}