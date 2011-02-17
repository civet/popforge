package de.popforge.widget.bitboy
{
	import de.popforge.audio.output.Sample;
	
	public class AudioFadeOut
	{
		private var rate: int;
		
		private var gain: Number;
		
		public function AudioFadeOut( rate: int )
		{
			this.rate = rate;
			
			gain = 1;
		}
		
		public function proceesAudio( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			
			for( var i: int = 0 ; i < n ; ++i )
			{
				sample = samples[i];
				
				gain -= gain * 1 / rate;
				
				sample.left *= gain;
				sample.right *= gain;
			}
			
			return gain < .01;
		}
	}
}