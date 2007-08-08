package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneClap;
	
	public final class VoiceClap extends Voice
	{
		static private const snd: Array = Rom.convert16Bit( new Rom.Clap() );
		static private const sndLength: int = snd.length - 1;
		
		private var level: Number;
		
		public function VoiceClap( start: int, volume: Number, tone: ToneClap )
		{
			super( start );
			
			level = tone.level.getValue() * volume;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];

				if( position < sndLength )
				{
					amplitude = snd[ position++ ] * level;

					//-- ADD AMPLITUDE (MONO)
					sample.left += amplitude;
					sample.right += amplitude;
				}
				else
					return true;
			}

			start = 0;
			
			return false;
		}
	}
}