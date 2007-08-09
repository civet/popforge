package de.popforge.fui.core
{
	import flash.display.Sprite;
	
	public class Component extends Sprite
	{
		/**
		* The factory associated with this component.
		*/		
		protected var _factory: IFuiFactory;
		
		/**
		 * The tag that has been used to define this component.
		 */
		protected var _tag: XML;
		
		/**
		 * Width of the component in tiles.
		 * This property has to be overriden.
		 * 
		 * @throws ImplementationRequiredError If this method is not overriden.
		 */		
		public function get tileWidth(): uint
		{
			throw new ImplementationRequiredError;
		}

		/**
		 * Height of the component in tiles.
		 * This property has to be overriden.
		 * 
		 * @throws ImplementationRequiredError If this method is not overriden.
		 */		
		public function get tileHeight(): uint
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
		
		/**
		 * Removes the component and all its internal references.
		 */		
		public function dispose(): void
		{
			_factory = null;
		}
		
		/**
		 * The XML tag that has been used to define this component.
		 */		
		public function set tag( value: XML ): void
		{
			_tag = value;
		}
		
		/**
		 * The factory used to render this component.
		 * A call to <code>render()</code> is made if you set a factory for a component.
		 */		
		public function set factory( value: IFuiFactory ): void
		{
			_factory = value;
			render();
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