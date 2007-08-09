package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneClap;
	
	public final class VoiceClap extends Voice
	{
		static private const snd: Array = Rom.getAmplitudesByName( '909.clap.raw' );
		
		private var tone: ToneClap;
		
		public function VoiceClap( start: int, volume: Number, tone: ToneClap )
		{
			super( start, volume );
			
			this.tone = tone;
			
			maxLength = length = snd.length << 1;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var level: Number = tone.level.getValue() * volume;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];

				amplitude = snd[ int( position >> 1 ) ] * level;

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