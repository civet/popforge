package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.output.Sample;

	public class StereoEnhancer
		implements IAudioProcessor
	{
		private const delayL: Array = new Array();
		private const delayR: Array = new Array();
		
		private var rate: uint;
		
		private var writeIndex: int;
		
		public function StereoEnhancer( rate: uint )
		{
			this.rate = rate;
			
			init();
		}
		
		public function clear(): void
		{
			for( var i: int = 0 ; i < 0xffff ; i++ )
			{
				delayL[i] = 0.0;
				delayR[i] = 0.0;
			}
			
			writeIndex = 0;
		}
		
		public function processAudio( samples: Array ): void
		{
			var n: int = samples.length;
			
			var stream: Sample;
			var readIndex: int;
			var offset: int = rate / 55;
			
			for( var i: int = 0 ; i < n ; i++ )
			{
				stream = samples[i];
				
				delayL[writeIndex] = stream.left;
				delayR[writeIndex] = stream.right;
				
				readIndex = writeIndex - offset;
				if( readIndex < 0 ) readIndex += 0xffff;
				
				stream.right += delayL[readIndex] * .5;
				stream.left += delayR[readIndex] * .5;
				
				if( ++writeIndex == 0xffff )
					writeIndex = 0;
			}
		}
		
		private function init(): void
		{
			for( var i: int = 0 ; i < 0xffff ; i++ )
			{
				delayL.push( 0.0 );
				delayR.push( 0.0 );
			}
			
			writeIndex = 0;
		}
	}
}