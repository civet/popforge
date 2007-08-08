package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneBassdrum;
	
	public final class VoiceBassdrum extends Voice
	{
		static private var sndNoise: Array = Rom.convert16Bit( new Rom.BassDrumNoise() );
		static private var sndBody: Array = Rom.convert16Bit( new Rom.BassDrumBody() );
		
		static private var sndBodyNum: int = sndBody.length - 1;
			
		private var bodyEnv: Number;
		private var posBody: Number;
		
		private var stopEnv: Number;
		
		private var tuneValue: Number;
		private var levelValue: Number;
		private var attackValue: Number;
		private var decayValue: int;
		
		public function VoiceBassdrum( start: int, volume: Number, tone: ToneBassdrum )
		{
			super( start );
			
			bodyEnv = 1;
			stopEnv = 1;
			posBody = 0;
			
			tuneValue = tone.tune.getValue();
			attackValue = tone.attack.getValue();
			levelValue = tone.level.getValue() * volume;
			decayValue = tone.decay.getValue();
		}
		
		public override function stop( offset: int ): void
		{
			length = ( position + offset ) - 1024;
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
				amplitude *= bodyEnv * levelValue * stopEnv;
				
				//-- CLICK NOISE
				if( position < sndNoise.length )
					amplitude += sndNoise[ position ] * attackValue * levelValue;
				
				//-- DECAY
				if( position > decayValue )
				{
					//-- observed value
					bodyEnv *= .9994;

					if( bodyEnv < .001 )
						return true;
				}
				
				if( ++position >= length )
				{
					stopEnv *= .994;
					
					if( stopEnv < .001 )
						return true;
				}
				
				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				//-- ADVANCE WAVEFORMS
				posBody += tuneValue;
				if( posBody >= sndBodyNum )
					posBody -= sndBodyNum;

				//-- observed value
				tuneValue += ( 1 - tuneValue ) * .0011;
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