package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneHighHat;
	
	public final class VoiceHiHat extends Voice
	{
		static public const CLOSED: Boolean = true;
		static public const OPEN: Boolean = false;
		
		static private const sndCL: Array = Rom.convert16Bit( new Rom.HighhatClosed() );
		static private const sndOP: Array = Rom.convert8Bit( new Rom.HighhatOpen() );
		
		private var snd: Array;

		private var closed: Boolean;
		
		private var volEnv: Number;
		private var levelValue: Number;
		private var decayValue: int;
		
		public function VoiceHiHat( start: int, volume: Number, tone: ToneHighHat, closed: Boolean )
		{
			super( start );
			
			this.closed = closed;
			
			if( closed )
			{
				snd = sndCL;
				length = snd.length - 1;
				decayValue = length * tone.decayCL.getValue();
			}
			else
			{
				snd = sndOP;
				length = snd.length - 1;
				decayValue = length * tone.decayOP.getValue();
			}
			
			volEnv = 1;
			levelValue = tone.level.getValue() * volume;
		}
		
		public override function stop( offset: int ): void
		{
			length = position + offset;
			
			if( length > snd.length - 1 )
				length = snd.length - 1;
		}		
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				amplitude = snd[ position++ ] * levelValue * volEnv;

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

				if( position >= length )
					return true;
			}
			
			start = 0;
			
			return false;
		}
		
		public override function isMonophone(): Boolean
		{
			return true;
		}
	}
}