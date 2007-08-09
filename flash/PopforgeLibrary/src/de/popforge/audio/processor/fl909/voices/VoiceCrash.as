package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneCrash;
	
	public final class VoiceCrash extends Voice
	{
		static private const snd: Array = Rom.getAmplitudesByName( '909.cr.raw' );
		
		private var tone: ToneCrash;
		
		public function VoiceCrash( start: int, volume: Number, tone: ToneCrash )
		{
			super( start, volume );
			
			this.tone = tone;
			
			monophone = true;
			
			maxLength = length = snd.length << 1;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var tuneValue: Number = tone.tune.getValue();
			var levelValue: Number = tone.level.getValue() * volume;
			
			var tunePos: Number;
			var tunePosInt: int;
			var alpha: Number;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				//-- LINEAR INTERPOLATION
				tunePos = ( position >> 1 ) * tuneValue;
				tunePosInt = tunePos;
				alpha = tunePos - tunePosInt;
				
				amplitude = snd[ tunePosInt ] * ( 1 - alpha );
				amplitude += snd[ int( tunePosInt + 1 ) ] * alpha;
				amplitude *= levelValue;
				
				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				if( ++position >= length )
					return true;
			}
			
			start = 0;
			
			return false;
		}
	}
}