package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneRimshot;
	
	public final class VoiceRimshot extends Voice
	{
		static private const snd: Array = Rom.convert16Bit( new Rom.Rimshot() );
		static private const sndLength: int = snd.length - 1;
		
		private var level: Number;
		
		public function VoiceRimshot( start: int, tone: ToneRimshot )
		{
			super( start );
			
			level = tone.level.getValue();
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