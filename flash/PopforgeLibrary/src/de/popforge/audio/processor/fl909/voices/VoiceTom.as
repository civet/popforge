package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneTom;
	
	public final class VoiceTom extends Voice
	{
		static public const SIZE_LOW: uint = 0;
		static public const SIZE_MED: uint = 1;
		static public const SIZE_HIGH: uint = 2;
		
		static private const snd0: Array = Rom.convert16Bit( new Rom.TomLow() );
		static private const snd1: Array = Rom.convert16Bit( new Rom.TomMed() );
		static private const snd2: Array = Rom.convert16Bit( new Rom.TomHigh() );
		
		private var snd: Array;

		private var volEnv: Number;
		private var levelValue: Number;
		private var decayValue: int;
		private var tuneValue: Number;
		
		public function VoiceTom( start: int, volume: Number, tone: ToneTom, size: uint )
		{
			super( start );
			
			switch( size )
			{
				case SIZE_LOW: snd = snd0; break;
				case SIZE_MED: snd = snd1; break;
				case SIZE_HIGH: snd = snd2; break;
				default: throw new Error( 'Size is not defined.' ); return;
			}
			
			length = snd.length - 1;
			decayValue = length * tone.decay.getValue();
			
			tuneValue = tone.tune.getValue();
			
			volEnv = 1;
			levelValue = tone.level.getValue() * volume;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var tunePos: Number;
			var tunePosInt: int;
			var alpha: Number;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				//-- LINEAR INTERPOLATION
				tunePos = ( position++ ) * tuneValue;
				tunePosInt = tunePos;
				
				if( tunePosInt >= length )
					return true;
				
				alpha = tunePos - tunePosInt;
				
				amplitude = snd[ tunePosInt ] * ( 1 - alpha );
				amplitude += snd[ tunePosInt + 1 ] * alpha;
				amplitude *= levelValue * volEnv;

				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				//-- DECAY
				if( position > decayValue )
				{
					//-- observed value
					volEnv *= .9988;

					if( volEnv < .001 )
						return true;
				}
			}
			
			start = 0;
			
			return false;
		}
	}
}