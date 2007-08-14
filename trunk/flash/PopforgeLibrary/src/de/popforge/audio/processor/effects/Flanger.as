package de.popforge.audio.processor.effects
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;

	public class Flanger
		implements IAudioProcessor
	{
		public const parameterDelay: Parameter = new Parameter( new MappingNumberLinear( 1, 10 ), 5 ); // ms
		public const parameterDepth: Parameter = new Parameter( new MappingNumberLinear( .2, 1 ), .8 );
		public const parameterSpeed: Parameter = new Parameter( new MappingNumberLinear( 24, .5 ), 6 ); // sec
		public const parameterFeedback: Parameter = new Parameter( new MappingNumberLinear( 0, .86 ), .6 );
		public const parameterMix: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), 1 );
		
		private const bufferL: Array = new Array();
		private const bufferR: Array = new Array();
		
		private var write: int;
		private var phase: Number;
		
		public function Flanger()
		{
			reset();
		}
		
		public function processAudio( samples: Array ): void
		{
			var n: int = samples.length;
			
			var sample: Sample;
			
			var readL: int;
			var readR: int;
			
			var sl: Number;
			var sr: Number;
			var fl: Number;
			var fr: Number;
			
			var bl: Float;
			var br: Float;
			
			var delay: Number = parameterDelay.getValue() * 44100 / 1000;
			var depth: Number = parameterDepth.getValue();
			var phaseShift: Number = 1 / ( 44100 * parameterSpeed.getValue() );
			var feedback: Number = parameterFeedback.getValue();
			var mix: Number = parameterMix.getValue();
			var mixm: Number = 1 - mix;
			
			var a: Number;
			
			//for( var i: int = 0 ; i < n ; ++i )
			for each( sample in samples )
			{
				//sample = samples[i];
				
				bl = bufferL[write];
				br = bufferR[write];
				
				//-- write in buffer
				sl = bl.value = sample.left;
				sr = br.value = sample.right;
				
				//-- triangle lfo
				a = ( phase - int( phase ) ) * 4;
				if( a < 2 ) a -= 1;
				else a = 3 - a;
				
				phase += phaseShift;
				
				a *= depth * delay;
				
				readL = write - ( delay + a );
				readR = write - ( delay - a );
				
				if( readL < 0 )
					readL += 0xfff;
				if( readR < 0 )
					readR += 0xfff;
				
				fl = Float( bufferL[ readL ] ).value;
				fr = Float( bufferR[ readR ] ).value;
				
				//-- feedback
				bl.value += fl * feedback;
				br.value += fr * feedback;
				
				//-- mix into stream
				sample.left = mixm * sl + fl * mix;
				sample.right = mixm * sr + fr * mix;
				
				if( ++write == 0xfff )
					write = 0;
			}
		}
		
		public function reset():void
		{
			for( var i: int = 0 ; i < 0xfff ; i++ )
			{
				bufferL[i] = new Float();
				bufferR[i] = new Float();
			}
			
			write = 0;
			phase = 0.0;
		}
	}
}

/**
 * This boost the performance 5 times!
 */
class Float
{
	public var value: Number = .0;
}