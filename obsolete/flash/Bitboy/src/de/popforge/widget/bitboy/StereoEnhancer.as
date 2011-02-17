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
		
		public function reset(): void
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
			
			var readL: int;
			var offsetL: int = 44.1 * 12;
			var readR: int;
			var offsetR: int = 44.1 * 24;
			
			var l: Number;
			var r: Number;
			var m: Number;
			
			var dL: Number;
			var dR: Number;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				stream = samples[i];
				
				l = stream.left;
				r = stream.right;

				m = ( l + r ) * .5;
				
				readL = writeIndex - offsetL;
				if( readL < 0 ) readL += 0xffff;
				
				readR = writeIndex - offsetR;
				if( readR < 0 ) readR += 0xffff;
				
				dL = delayL[readL] * .6;
				dR = delayR[readR] * .6;

				delayL[writeIndex] = l + dR * .05;
				delayR[writeIndex] = r + dL * .05;
				
				stream.left = dR + m;
				stream.right = dL + m;
				
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