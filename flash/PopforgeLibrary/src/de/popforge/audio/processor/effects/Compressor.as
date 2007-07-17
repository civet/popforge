package de.popforge.audio.processor.effects
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class Compressor
		implements IAudioProcessor
	{
		public const parameterThreshold: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .25 );
		public const parameterRatio: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .5 );
		public const parameterAttack: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .5 );
		public const parameterRelease: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .5 );
		
		private var envelope: Number;
		
		private var x: Number;
		private var a0: Number;
		private var b1: Number;
		private var tmp: Number;
		
		public function Compressor()
		{
			envelope = 0;
			
			x = Math.exp( -1 / 44.100 );
			
			a0 = 1.0 - x;
			b1 = -x;
			
			tmp = 0;
		}
		
		public function processAudio( samples: Array ): void
		{
			var n: int = samples.length;
			
			var threshold: Number = parameterThreshold.getValue();
			var attack: Number = .1;
			var release: Number = .0002;
			var ratio: Number = 1/4;
			
			var sample: Sample;
			var out: Number;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				sample = samples[i];
				
				out = a0 * ( sample.left + sample.right ) / 2 - b1 * tmp;
				tmp = out;

				if( out * out > threshold )
					envelope += ( 1 - envelope ) * attack;
				else
					envelope -= envelope * release;

				sample.left = ( 1 - envelope ) * sample.left + envelope * sample.left * ratio;
				sample.right = ( 1 - envelope ) * sample.right + envelope * sample.right * ratio;
			}
		}
	}
}