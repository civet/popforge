package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.processor.special.ParticleSynth;
	import de.popforge.gui.Label;
	import de.popforge.gui.Slider;
	
	import flash.display.Sprite;
	
	[SWF( backgroundColor='0xffffff', frameRate='30', width='480', height='320')]
	
	/**
	 * The ParticleSynth based on attraction of an array of particles.
	 * The waveform is shaped by passing all particles each cycle(Linear Interpolation).
	 * 
	 * Frequency
	 * How fast the playback header moves over the waveform.
	 * 
	 * ChannelOffset
	 * An offset is adjustable to separate left and right.
	 * 
	 * Attraction
	 * The strength of the force between two particles.
	 * 
	 * ParticlesCount
	 * Defines, how many particle are beaded.
	 * 
	 * HEADPHONES REQUIRED!
	 * 
	 * @author Andre Michelle
	 */

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
			var container: Sprite = new Sprite();
			
			var label: Label;
			var slider: Slider;
			
			var y: int = 0;
			
			label = new Label( 'FREQUENCY', 100 );
			label.x = 8;
			label.y = y;
			container.addChild( label );
			
			slider = new Slider( synth.parameterFrequency, 100 );
			slider.x = 8;
			slider.y = y + 20;
			container.addChild( slider );
			
			y += 48;
			
			label = new Label( 'STEREO OFFSET', 100 );
			label.x = 8;
			label.y = y;
			container.addChild( label );
			
			slider = new Slider( synth.parameterChannelOffset, 100 );
			slider.x = 8;
			slider.y = y + 20;
			container.addChild( slider );
			
			y += 48;
			
			label = new Label( 'ATTRACTION', 100 );
			label.x = 8;
			label.y = y;
			container.addChild( label );
			
			slider = new Slider( synth.parameterAttraction, 100 );
			slider.x = 8;
			slider.y = y + 20;
			container.addChild( slider );
			
			y += 48;
			
			label = new Label( 'PARTICLE COUNT', 100 );
			label.x = 8;
			label.y = y;
			container.addChild( label );
			
			slider = new Slider( synth.parameterParticlesCount, 100 );
			slider.x = 8;
			slider.y = y + 20;
			container.addChild( slider );
			
			container.x = ( stage.stageWidth - container.width ) >> 1;
			container.y = ( stage.stageHeight - container.height ) >> 1;
			
			addChild( container );
		}
	}
}
