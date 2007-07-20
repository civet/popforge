package
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.bitboy.BitBoy;
	import de.popforge.audio.processor.bitboy.formats.FormatBase;
	import de.popforge.audio.processor.bitboy.formats.FormatFactory;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import de.popforge.format.Wav;
	import de.popforge.audio.output.Audio;

	public class BitboyTestApp extends Sprite
	{
		[Embed(source="/../bin/mod/rainfore.mod", mimeType="application/octet-stream")] static private const MOD: Class;
		
		public function BitboyTestApp()
		{
			init();
		}
		
		private function init(): void
		{
			var format: FormatBase = FormatFactory.createFormat( ByteArray( new MOD() ) );
			
			var bitboy: BitBoy = new BitBoy();
			bitboy.setFormat( format );
			
			var samples: Array = new Array();
			
			//-- create 2 seconds audio
			for( var i: int = 0 ; i < 44100 * 3 ; ++i )
			{
				samples.push( new Sample() );
			}
			
			bitboy.processAudio( samples );
			
			var bytes: ByteArray = Wav.encode( samples, 2, Audio.BIT16, Audio.RATE44100 );
			
			ExportBinarySocket.getInstance().saveFile( 'declicker.wav', bytes );
		}
	}
}