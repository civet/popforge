package de.popforge.widget.bitboy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class Spectrum extends Bitmap
	{
		private var output: BitmapData;
		private var outputBitmap: Bitmap;
		private var outputArray: ByteArray;
				
		public function Spectrum()
		{
			super( output = new BitmapData( 142, 13, false, 0x00ff00 ) );
			
			outputArray = new ByteArray();

			addEventListener( Event.ENTER_FRAME, update );
		}
		
		private function update( event: Event ): void
		{
			try
			{
				SoundMixer.computeSpectrum( outputArray, true, 3 );
			}
			catch( e: Error )
			{
				return;
			}
			
			output.lock();
			output.fillRect( output.rect, 0x00ff00 );
			
			var x: int;
			var y: int;
			var h: int;
			var f: int;
			var a: Number;
			
			for( var i: int = 0 ; i < 16 ; i++ )
			{
				x = i * 9;
				
				a = 0;
				
				for( f = 0 ; f < 16 ; f++ )
				{
					outputArray.position = ( i * 16 + f ) << 2;
					a += outputArray.readFloat();
					outputArray.position = ( 256 + i * 16 + f ) << 2;
					a += outputArray.readFloat();
				}
				
				h = 12 - a / 32 * 12;
				y = 12;
				
				if( h < 0 ) h = 0;
				
				while( y > h )
				{
					drawBlock( x, y );
					
					y -= 2;
				}
			}
			
			/*var x: int = 0;
			var i: int = 0;
			var value: Number;
			
			for (i;i<0x100;i+=(0x100/143))
			{
				//-- mix stereo to mono
				outputArray.position = i << 2;
				value = outputArray.readFloat();
				outputArray.position = ( i | 0x100 ) << 2;
				value += outputArray.readFloat();
				
				//-- draw
				output.setPixel( x++, 6 - value * 5, 0x0000ff );
			}*/
			
			output.unlock();
		}
		
		private function drawBlock( x: int, y: int ): void
		{
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x++, y, 0x0000ff );
			output.setPixel( x, y, 0x0000ff );
		}
	}
}