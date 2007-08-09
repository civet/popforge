package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneSnaredrum;
	import de.popforge.math.Random;
	
	public class VoiceSnaredrum extends Voice
	{
		static private const sndBody: Array = Rom.getAmplitudesByName( '909.sd.raw' );
		static private const sndBodyNum: int = sndBody.length - 1;
		
		static private const sndNoise: Array = createSnareNoise();
		static private const sndNoiseNum: int = sndNoise.length;
		
		static private function createSnareNoise(): Array
		{
			var amplitudes: Array = new Array();
			var r: Random = new Random( 0xffff );
			var a: Number;
			var hv: Number = 0;
			var ho: Number = 0;
			var lv: Number = 0;
			var lo: Number = 0;
			var i: int = 11025;
			
			while( --i > -1 )
			{
				a = r.getNumber( -5, 5 );
				
				//-- highpass
				ho += ( a - ho ) * .2;
				
				//-- lowpass
				lo += ( ( a - ho ) - lo ) * .2;
				
				amplitudes[i] = lo;
			}
			
			return amplitudes;
		}
		
		private var bodyEnv: Number;
		private var noiseEnv: Number;
		private var posBody: Number;
		private var levelValue: Number;
		private var tuneValue: Number;
		private var snappyValue: Number;
		private var toneValue: Number;
		
		public function VoiceSnaredrum( start: int, volume: Number, tone: ToneSnaredrum )
		{
			super( start );
			
			bodyEnv = 1;
			noiseEnv = 1;
			posBody = 0;
			
			levelValue = tone.level.getValue() * volume;
			tuneValue = tone.tune.getValue();
			snappyValue = tone.snappy.getValue();
			toneValue = tone.tone.getValue();
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var alpha: Number;
			var posBodyInt: int;

			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];

				//-- BODY GRAIN (INTERPOLATED)
				posBodyInt = posBody;
				alpha = posBody - posBodyInt;
				amplitude = sndBody[ posBodyInt ] * ( 1 - alpha );
				amplitude += sndBody[ posBodyInt + 1 ] * alpha;
				amplitude *= bodyEnv * levelValue;
				
				//-- DECAY
				//-- observed value
				bodyEnv *= .999;

				//-- NOISE (LINEAR)
				if( position < 11025 )
					amplitude += sndNoise[ position++ ] * levelValue * noiseEnv * snappyValue;
				else
					return true;
				
				noiseEnv *= toneValue;
				
				if( noiseEnv < .001 )
					return true;
				
				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				//-- ADVANCE WAVEFORMS
				posBody += tuneValue;
				if( posBody >= sndBodyNum )
					posBody -= sndBodyNum;
			}
			
			start = 0;
			
			return false;
		}
	}
}