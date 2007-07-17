package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	import de.popforge.gui.Slider;
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;
	
	/**
	 * Example CreateAStream
	 * Creates endless dynamic audio
	 * 
	 * @author Andre Michelle
	 */

	public class CreateAStream extends Sprite
	{
		public var parameterFrequency: Parameter;
		
		private var phase: Number;
		private var frequency: Number;
		
		public function CreateAStream()
		{
			init();
		}
		
		private function init(): void
		{
			var buffer: AudioBuffer = new AudioBuffer( 4, Audio.STEREO, Audio.BIT16, Audio.RATE44100 );
			buffer.onInit = onAudioBufferInit;
			buffer.onComplete = onAudioBufferComplete;
			
			parameterFrequency = new Parameter( new MappingNumberExponential( 110, 8000 ), frequency = 110 );
			
			var sliderFrequency: Slider = new Slider( parameterFrequency );
			sliderFrequency.x = ( stage.stageWidth - sliderFrequency.width ) >> 1;
			sliderFrequency.y = ( stage.stageHeight - sliderFrequency.height ) >> 1;
			addChild( sliderFrequency );
			
			phase = 0;
		}
		
		private function onAudioBufferInit( buffer: AudioBuffer ): void
		{
			buffer.start();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void
		{
			//-- get array to store samples
			var samples: Array = buffer.getSamples();
			
			//-- some locals
			var sample: Sample;
			var amplitude: Number;
			
			//-- CREATE ONE SECOND OF AUDIO (SINUS WAVE)
			for( var i: int = 0 ; i < samples.length ; i++ )
			{
				//-- store local
				sample = samples[i];
				
				//-- create an amplitude [-1,1]
				amplitude = Math.sin( phase * Math.PI * 2 );
				
				//-- write to sample
				sample.left = sample.right = amplitude;
				
				//-- interpolate
				frequency += ( parameterFrequency.getValue() - frequency ) * .0002;
				
				//-- increase phase
				phase += frequency / Audio.RATE44100;
			}
			
			//-- update audio buffer
			buffer.update();
		}
	}
}
