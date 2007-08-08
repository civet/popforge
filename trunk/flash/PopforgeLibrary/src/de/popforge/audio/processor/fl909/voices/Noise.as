package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.math.Random;
	
	public class Noise
	{
		static public function createSnareNoise(): Array
		{
			var amplitudes: Array = new Array();
			var r: Random = new Random( 0xffff );
			var a: Number;
			var v: Number = 0;
			var o: Number = 0;
			var i: int = 11025;
			
			while( --i > -1 )
			{
				a = r.getNumber( -2, 2 );
				v *= .3;
				v += ( a - o ) * .2;
				o += v;
				amplitudes[i] = a - o;
			}
			
			return amplitudes;
		}
	}
}