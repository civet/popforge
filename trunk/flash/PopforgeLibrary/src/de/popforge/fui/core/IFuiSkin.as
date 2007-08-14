package de.popforge.fui.core
{
	import de.popforge.fui.controls.*;
	import de.popforge.fui.controls.Label;
	
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
		function get tileSize(): uint;

		
		function createHSlider(): HSlider;
		function createVSlider(): VSlider;
		
		function createLabel(): Label;
		
		function createKnob(): Knob;
	}
}