package de.popforge.fui.core
{
	import de.popforge.fui.controls.*;
	
	/**
	 * The IFuiSkin interface has to bee implemented by a skin provider for the Fui framework.
	 * 
	 * @author Joa Ebert
	 */
	public interface IFuiSkin
	{
		/**
		 * Width and height of a tile for this skin.
		 * Tiles are always squares.
		 */		
		function get tileSize(): Number;

		
		function createSlider(): Slider;
		function createKnob(): Knob;
	}
}