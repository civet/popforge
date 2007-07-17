package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.processor.special.ParticleSynth;
	import de.popforge.gui.Slider;
	
	import flash.display.Sprite;
	
	[SWF( backgroundColor='0xffffff', frameRate='30', width='480', height='320')]

	public class ParticleSynthApp extends Sprite
	{
		private var synth: ParticleSynth;
		
		public function ParticleSynthApp()
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
			synth = new ParticleSynth();
			
			buffer.start();
			
			buildUI();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void
		{
			var samples: Array = buffer.getSamples();
			
			synth.processAudio( samples );
			
			buffer.update();
		}
		
		private function buildUI(): void
		{
			var slider: Slider;
			
			slider = new Slider( synth.parameterFrequency, 100 );
			slider.x = 8;
			slider.y = 8;
			addChild( slider );
			
			slider = new Slider( synth.parameterChannelOffset, 100 );
			slider.x = 8;
			slider.y = 32;
			addChild( slider );
			
			slider = new Slider( synth.parameterAttraction, 100 );
			slider.x = 8;
			slider.y = 56;
			addChild( slider );
		}
	}
}
