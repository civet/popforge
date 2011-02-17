package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.output.Sample;
	
	public final class BassBoost
		implements IAudioProcessor
	{
		private var rate: uint;
		private var freq: uint;
		private var dB: int;
			
		private var lxn1: Number;
		private var lxn2: Number;
		private var lyn1: Number;
		private var lyn2: Number;

		private var rxn1: Number;
		private var rxn2: Number;
		private var ryn1: Number;
		private var ryn2: Number;
				
		private var b0: Number;
		private var b1: Number;
		private var b2: Number;
		
		private var a0: Number;
		private var a1: Number;
		private var a2: Number;
		
		public function BassBoost( rate: uint )
		{
			this.rate = rate;
			
			freq = 240;
			dB = 3;
			
			init();
		}
		
		public function reset(): void
		{
		}
		
		private function init(): void
		{
			const angle: Number = Math.PI * 2 * freq / rate;
			const sin: Number = Math.sin( angle );
			const cos: Number = Math.cos( angle );
			const a: Number = Math.exp( Math.log( 10 ) * dB / 40 );
			const s: Number = 1;
			const beta: Number = Math.sqrt( ( a * a + 1 ) / s - ( Math.pow( ( a - 1 ), 2 ) ) );

			lxn1 = lxn2 = lyn1 = lyn2 = 0;
			rxn1 = rxn2 = ryn1 = ryn2 = 0;

			b0 = a * ( ( a + 1 ) - ( a - 1 ) * cos + beta * sin );
			b1 = 2 * a * ( ( a - 1 ) - ( a + 1 ) * cos );
			b2 = a * ( ( a + 1 ) - ( a - 1 ) * cos - beta * sin );
			a0 = ( ( a + 1 ) + ( a - 1 ) * cos + beta * sin );
			a1 = -2 * ( ( a - 1 ) + ( a + 1 ) * cos );
			a2 = ( a + 1 ) + ( a - 1 ) * cos - beta * sin;
		}
		
		public function processAudio( samples: Array ): void
		{
			const n: int = samples.length;
			
			var i: int = 0;
			var stream: Sample;
			var value: Number;
			var src: Number;
			
			for(;i<n;++i)
			{
				stream = samples[i];

				src = stream.left;

				value = ( b0 * src + b1 * lxn1 + b2 * lxn2 - a1 * lyn1 - a2 * lyn2 ) / a0;
				
				lxn2 = lxn1;
				lxn1 = src;
				lyn2 = lyn1;
				lyn1 = value;

				stream.left = value;
				
				src = stream.right;
				
				value = ( b0 * src + b1 * rxn1 + b2 * rxn2 - a1 * ryn1 - a2 * ryn2 ) / a0;
				
				rxn2 = rxn1;
				rxn1 = src;
				ryn2 = ryn1;
				ryn1 = value;

				stream.right = value;
			}
		}
	}
}