package de.popforge.audio.processor.effects
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class SamplingRateModulator
		implements IAudioProcessor
	{
		public const parameterRatio: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), 1 );
		
		// TODO: Make this dynamic
		public const original: int = Audio.RATE44100;
		
		private const buffer: Array = new Array();
		
		public function SamplingRateModulator()
		{
			
		}
		
		public function processAudio( samples: Array ): void
		{
			var n: int = samples.length;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				
			}
		}
	}
}