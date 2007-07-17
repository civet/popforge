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
				SoundMixer.computeSpectrum( outputArray, false );
			}
			catch( e: Error )
			{
				return;
			}
			
			output.lock();
			output.fillRect( output.rect, 0x00ff00 );
			
			var x: int = 0;
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
			}
			
			output.unlock();
		}
	}
}