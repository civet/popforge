package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.led.Active;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class LED extends Sprite
	{
		private const active: BitmapData = new Active(0,0);
		
		private var current: Bitmap;
		
		public function LED()
		{
			build();
		}
		
		public function show( index: int ): void
		{
			var bitmap: Bitmap = Bitmap( getChildAt( index ) );
			
			bitmap.bitmapData = active;

			if( current != null )
				current.bitmapData = null;
			
			current = bitmap;
		}
		
		private function build(): void
		{
			var bitmap: Bitmap;
			
			for( var i: int = 0 ; i < 16 ; i++ )
			{
				bitmap = new Bitmap( null );
				bitmap.x = 112 + i * 27;
				bitmap.y = 231;
				addChild( bitmap );
			}
		}
	}
}