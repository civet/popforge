package de.popforge.fui.core
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class FuiComponent extends Sprite
	{
		/**
		* The factory associated with this component.
		*/		
		protected var _skin: IFuiSkin;
		
		/**
		 * The tag that has been used to define this component.
		 */
		protected var _tag: XML;
		
		/**
		 * Size of the component in tiles.
		 * This property has to be overriden.
		 * 
		 * @throws ImplementationRequiredError If this method is not overriden.
		 */		
		public function get size(): FuiComponentSize
		{
			throw new ImplementationRequiredError;
		}

		/**
		 * Renders the component by creating all the necessary display objects.
		 * 
		 * @throws ImplementationRequiredError If this method is not overriden.
		 */	
		protected function render(): void
		{
			throw new ImplementationRequiredError;
		}
		
		protected function createChildren(): void
		{
			throw new ImplementationRequiredError;
		}
		
		/**
		 * Removes the components chidlren and all its internal references.
		 */		
		public function dispose(): void
		{
			_skin = null;
		}
		
		/**
		 * The XML tag that has been used to define this component.
		 */		
		public function set tag( value: XML ): void
		{
			_tag = value;
		}
		
		/**
		 * The skin used to render this component.
		 * A call to <code>render()</code> is made if you set a skin for a component.
		 */		
		public function set skin( value: IFuiSkin ): void
		{
			_skin = value;
			render();
		}

		/**
		 * Masks the component using the exact width and height calculated
		 * using the tile size and components size in tiles.
		 */		
		protected function maskComponent(): void
		{
			scrollRect = new Rectangle( 0, 0, _skin.tileSize * size.width, _skin.tileSize * size.height );
		}
		
		/**
		 * Draws the bounds of the component given by tile size and components size in tiles.
		 */
		protected function debugBounds(): void
		{
			graphics.lineStyle( 1, 0xff00ff );
			graphics.drawRect( 0, 0, _skin.tileSize * size.width, _skin.tileSize * size.height );
		}

		/**
		 * Creates and returns the string representation of the current object.
		 * 
		 * @return The string representation of the current object.
		 */		
		override public function toString(): String
		{
			return '[Component]';
		}
	}
}