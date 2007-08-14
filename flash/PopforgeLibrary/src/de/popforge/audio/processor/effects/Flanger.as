package de.popforge.audio.processor.effects
{
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.output.Sample;
	import de.popforge.parameter.Parameter;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.MappingNumberExponential;

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
			
			var fl: Number;
			var fr: Number;
			
			var delay: Number = parameterDelay.getValue() * 44100 / 1000;
			var depth: Number = parameterDepth.getValue();
			var phaseShift: Number = 1 / ( 44100 * parameterSpeed.getValue() );
			var feedback: Number = parameterFeedback.getValue();
			var mix: Number = parameterMix.getValue();
			
			var a: Number;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				sample = samples[i];
				
				bufferL[write] = sample.left;
				bufferR[write] = sample.right;
				
				//-- triangle lfo
				a = ( phase - int( phase ) ) * 4;
				if( a < 2 ) a -= 1;
				else a = 3 - a;
				phase += phaseShift;
				
				a *= depth * delay;
				
				readL = write - ( delay + a );
				readR = write - ( delay - a );
				
				while( readL < 0 )
					readL += 0xffff;
				while( readR < 0 )
					readR += 0xffff;
				
				fl = bufferL[ readL ];
				fr = bufferL[ readR ];
				
				//-- feedback
				bufferL[write] += fl * feedback;
				bufferR[write] += fr * feedback;
				
				//-- mix into stream
				sample.left = ( 1 - mix ) * sample.left + fl * mix;
				sample.right = ( 1 - mix ) * sample.right + fr * mix;
				
				if( ++write == 0xffff )
					write = 0;
			}
		}
		
		public function reset():void
		{
			for( var i: int = 0 ; i < 0xffff ; i++ )
			{
				bufferL[i] = .0;
				bufferR[i] = .0;
			}
			
			write = 0;
			phase = 0.0;
		}
	}
}