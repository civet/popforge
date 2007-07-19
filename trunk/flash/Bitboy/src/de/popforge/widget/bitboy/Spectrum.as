package de.popforge.widget.bitboy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class Spectrum extends Bitmap
	{
		private var output: BitmapData;
		private var outputBitmap: Bitmap;
		private var outputArray: ByteArray;
		private var peaks: Array;
				
		public function Spectrum()
		{
			super( output = new BitmapData( 142, 13, false, 0x00ff00 ) );
			
			outputArray = new ByteArray();
			
			peaks = new Array();
			
			for( var i: int = 0 ; i < 16 ; i++ )
				peaks[i] = 0.0;

			var timer: Timer = new Timer( 25 );
			timer.addEventListener( TimerEvent.TIMER, onTimer );
			timer.start();
		}
		
		private function onTimer( event: TimerEvent ): void
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
				
				a /= 32;
				
				if( a > 1 )
					a = 1;
				
				if( a > peaks[i] )
				{
					peaks[i] = a;
				}
				
				h = 12 - peaks[i] * 12;
				y = 11;
				
				peaks[i] *= .8;
				
				while( y > h )
				{
					drawBlock( x, y );
					
					y -= 2;
				}
			}
			
			output.unlock();
		}
		
		private function drawBlock( x: int, y: int ): void
		{
			output.setPixel( x++, y, 0x0000ff );
			x++
			output.setPixel( x++, y, 0x0000ff );
			x++
			output.setPixel( x++, y, 0x0000ff );
			x++
			output.setPixel( x, y, 0x0000ff );
		}
	}
}