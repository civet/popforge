package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	
	import flash.display.Sprite;
	import de.popforge.audio.output.Sample;

	public class FMSynthesis extends Sprite
	{
		private var cPhase: Number;
		private var mPhase: Number;
		
		public function FMSynthesis()
		{
			init();
		}
		
		private function init(): void
		{
			var buffer: AudioBuffer = new AudioBuffer( 4, Audio.STEREO, Audio.BIT16, Audio.RATE44100 );
			buffer.onInit = onAudioBufferInit;
			buffer.onComplete = onAudioBufferComplete;
		}
		
		private function onAudioBufferInit( buffer: AudioBuffer ): void
		{
			cPhase = 0;
			mPhase = 0;
			
			buffer.start();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void
		{
			//-- get array to store samples
			var samples: Array = buffer.getSamples();
			var n: int = samples.length;
			
			var sample: Sample;
			
			var m: Number = 0;
			var c: Number = 0;
			
			for( var i: int = 0 ; i < n ; i++ )
			{
				sample = samples[i];
				
				//-- Modulator
				m = Math.sin( mPhase * Math.PI * 2 );
				
				//-- Carrier + Modulator
				c = Math.sin( ( cPhase + m/2 ) * Math.PI * 2 );
				
				mPhase += 220 / 44100;
				cPhase += 55 / 44100;
				
				sample.left = sample.right = c;
			}
			
			buffer.update();
		}
	}
}