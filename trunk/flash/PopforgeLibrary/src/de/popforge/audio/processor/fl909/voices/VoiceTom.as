package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneTom;
	
	public final class VoiceTom extends Voice
	{
		static public const SIZE_LOW: uint = 0;
		static public const SIZE_MED: uint = 1;
		static public const SIZE_HIGH: uint = 2;
		
		static private const snd0: Array = Rom.getAmplitudesByName( '909.tl.raw' );
		static private const snd1: Array = Rom.getAmplitudesByName( '909.tm.raw' );
		static private const snd2: Array = Rom.getAmplitudesByName( '909.th.raw' );
		
		private var snd: Array;
		
		private var tone: ToneTom;
		private var volEnv: Number;
		
		private var tuneValue: Number;
		
		public function VoiceTom( start: int, volume: Number, tone: ToneTom, size: uint )
		{
			super( start, volume );
			
			this.tone = tone;
			
			switch( size )
			{
				case SIZE_LOW: snd = snd0; break;
				case SIZE_MED: snd = snd1; break;
				case SIZE_HIGH: snd = snd2; break;
			}
			
			monophone = true;
			
			maxLength = length = snd.length << 1;
			
			tuneValue = tone.tune.getValue()
			
			volEnv = 1;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var tunePos: Number;
			var tunePosInt: int;
			var alpha: Number;
			
			var levelValue: Number = tone.level.getValue() * volume;
			var tuneValue: Number = tone.tune.getValue();
			var decayValue: int = maxLength / tuneValue * tone.decay.getValue();
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				//-- LINEAR INTERPOLATION
				tunePos = ( position >> 1 ) * this.tuneValue;
				tunePosInt = tunePos;
				
				alpha = tunePos - tunePosInt;
				
				amplitude = snd[ tunePosInt ] * ( 1 - alpha );
				amplitude += snd[ int( tunePosInt + 1 ) ] * alpha;
				amplitude *= levelValue * volEnv;
				
				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				//-- DECAY
				if( position >= decayValue )
				{
					//-- observed value
					volEnv *= .9988;

					if( volEnv < .001 )
						return true;
				}
				
				if( ++position >= length )
					return true;
				
				//-- interpolate to avoid clicks
				this.tuneValue += ( tuneValue - this.tuneValue ) * .001;
			}
			
			start = 0;
			
			return false;
		}
	}
}