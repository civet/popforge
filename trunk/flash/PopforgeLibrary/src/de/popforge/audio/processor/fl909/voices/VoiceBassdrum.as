package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneBassdrum;
	
	public final class VoiceBassdrum extends Voice
	{
		static private var smpNoise: Array = Rom.convert16Bit( new Rom.BassDrumNoise() );
		static private var smpBody: Array = Rom.convert16Bit( new Rom.BassDrumBody() );
		
		static private var smpBodyNum: int = smpBody.length - 1;
			
		private var volEnv: Number;
		private var posBody: Number;
		
		private var tuneValue: Number;
		private var levelValue: Number;
		private var attackValue: Number;
		private var decayValue: int;
		
		public function VoiceBassdrum( start: int, volume: Number, tone: ToneBassdrum )
		{
			super( start );
			
			volEnv = 1;
			posBody = 0;
			
			tuneValue = tone.tune.getValue();
			attackValue = tone.attack.getValue();
			levelValue = tone.level.getValue() * volume;
			decayValue = tone.decay.getValue();
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
				amplitude = smpBody[ posBodyInt ] * ( 1 - alpha );
				amplitude += smpBody[ posBodyInt + 1 ] * alpha;
				amplitude *= volEnv * levelValue;
				
				//-- CLICK NOISE
				if( position < smpNoise.length )
					amplitude += smpNoise[ position ] * attackValue * levelValue;
				
				//-- DECAY
				if( position > decayValue )
				{
					//-- observed value
					volEnv *= .9995;

					if( volEnv < .001 )
						return true;
				}
				
				if( ++position >= length )
					return true;
				
				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				//-- ADVANCE WAVEFORMS
				posBody += tuneValue;
				if( posBody >= smpBodyNum )
					posBody -= smpBodyNum;

				//-- observed value
				tuneValue += ( 1 - tuneValue ) * .0011;
			}
			
			start = 0;
			
			return false;
		}
	}
}