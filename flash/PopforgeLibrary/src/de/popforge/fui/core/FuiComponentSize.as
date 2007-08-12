package de.popforge.fui.core
{
	public final class FuiComponentSize
	{
		private var _width: uint;
		private var _height: uint;
		
		public function FuiComponentSize( widthInTiles: uint, heightInTiles: uint )
		{
			_width = widthInTiles;
			_height = heightInTiles;
		}
		
		public function get width(): uint
		{
			return _width;
		}
		
		public function get height(): uint
		{
			return _height;
		}
		
		public function toString(): String
		{
			return '[FuiComponentSize width: ' + _width + ', height: ' + _height + ']';
		}
	}
}