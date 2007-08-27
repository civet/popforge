package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	internal class Display extends FuiComponent
	{
		protected var screen: BitmapData;
		
		override protected function build(): void
		{
			screen = new BitmapData( targetWidth, targetHeight, false, 0x333333 );
			addChild( new Bitmap( screen ) );
		}
		
		override public function toString(): String
		{
			return '[Display]';
		}
		
		protected function drawLineV( x: uint, y0: uint, y1: uint, color: uint ): void
		{
			if ( y1 > y0 )
				while ( --y1 >= y0 )
					screen.setPixel( x, y1, color );
			else if ( y1 < y0 )
				while( ++y1 <= y0 )
					screen.setPixel( x, y1, color );
		}
	}
}