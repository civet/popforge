package de.popforge.fui.core
{
	/**
	 * The IFuiFactory interface has to bee implemented by a skin provider for the Fui framework.
	 * 
	 * @author Joa Ebert
	 */
	public interface IFuiFactory
	{
		/**
		 * Width of a tile for this skin.
		 */		
		function get tileWidth(): uint;
		
		/**
		 * Height of a tile for this skin.
		 */		
		function get tileHeight(): uint;
	}
}