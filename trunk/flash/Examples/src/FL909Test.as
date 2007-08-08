package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.processor.fl909.FL909;
	
	import flash.display.Sprite;
	
	/**
	 * FL909 Test
	 * 
	 * @author Andre Michelle
	 */

	public class FL909Test extends Sprite
	{
		private var fl909: FL909;
		
		public function FL909Test()
		{
			init();
		}
		
		private function init(): void
		{
			var buffer: AudioBuffer = new AudioBuffer( 4, Audio.STEREO, Audio.BIT16, Audio.RATE44100 );
			buffer.onInit = onAudioBufferInit;
			buffer.onComplete = onAudioBufferComplete;

			fl909 = new FL909();
		}
		
		private function onAudioBufferInit( buffer: AudioBuffer ): void
		{
			buffer.start();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void
		{
			var samples: Array = buffer.getSamples();
			
			fl909.processAudio( samples );
			
			buffer.update();
		}
	}
}
