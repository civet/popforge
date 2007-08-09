package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneHighHat;
	
	public final class VoiceHiHat extends Voice
	{
		static public const CLOSED: Boolean = true;
		static public const OPEN: Boolean = false;
		
		static private const sndCL: Array = Rom.getAmplitudesByName( '909.ch.raw' );
		static private const sndOP: Array = Rom.getAmplitudesByName( '909.oh.raw' );
		
		private var snd: Array;
		private var volEnv: Number;
		
		private var tone: ToneHighHat;
		private var closed: Boolean;
		
		public function VoiceHiHat( start: int, volume: Number, tone: ToneHighHat, closed: Boolean )
		{
			super( start, volume );
			
			this.tone = tone;
			this.closed = closed;
			
			snd = closed ? sndCL : sndOP;
			
			maxLength = length = snd.length << 1;
			
			monophone = true;
			
			volEnv = 1;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var levelValue: Number = tone.level.getValue() * volume;
			var decayValue: int = maxLength * ( closed ? tone.decayCL.getValue() : tone.decayOP.getValue() );
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				amplitude = snd[ int( position >> 1 ) ] * levelValue * volEnv;

				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;
				
				//-- DECAY
				if( position > decayValue )
				{
					//-- observed value
					volEnv *= .999;

					if( volEnv < .001 )
						return true;
				}

				if( ++position >= length )
					return true;
			}
			
			start = 0;
			
			return false;
		}
	}
}