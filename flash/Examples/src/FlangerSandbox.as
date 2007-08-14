package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.effects.ParametricEQ;
	import de.popforge.format.wav.WavFormat;
	import de.popforge.gui.Label;
	import de.popforge.gui.XYPlane;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import de.popforge.audio.processor.effects.Flanger;
	import de.popforge.gui.Slider;
	import de.popforge.gui.Slider;
	
	[SWF( backgroundColor='0xffffff', frameRate='30', width='320', height='240')]
	
	/**
	 * Example PlayWavfile
	 * Creates endless dynamic audio with the content of a wavefile
	 * 
	 * @author Andre Michelle
	 */

	public class FlangerSandbox extends Sprite
	{
		private var wav: WavFormat;
		private var phase: Number;
		
		private var filter: Flanger;
		
		public function FlangerSandbox()
		{
			filter = new Flanger();
			
			var label: Label;
			var slider: Slider;
			
			var p: Array =
			[
				{ p: filter.parameterDelay, name: 'DELAY' },
				{ p: filter.parameterDepth, name: 'DEPTH' },
				{ p: filter.parameterSpeed, name: 'SPEED' },
				{ p: filter.parameterFeedback, name: 'FEEDBACK' },
				{ p: filter.parameterMix, name: 'MIX' }
			];
			
			for( var i: int = 0 ; i < p.length ; i++ )
			{
				label = new Label( p[i].name, 128 );
				label.x = 80;
				label.y = i * 44 + 12;
				addChild( label );
				
				slider = new Slider( p[i].p, 128 );
				slider.x = 80;
				slider.y = i * 44 + 32;
				addChild( slider );
			}

			
			loadWave();
		}
		
		private function loadWave(): void
		{
			var loader: URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener( Event.COMPLETE, onLoaderComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onLoaderError );
			loader.load( new URLRequest( 'highQ.wav' ) );
		}
		
		private function onLoaderComplete( event: Event ): void
		{
			var loader: URLLoader = URLLoader( event.target );
			
			wav = WavFormat.decode( loader.data );
			
			initAudioEngine();
		}
		
		private function onLoaderError( event: IOErrorEvent ): void
		{
			trace( event );
		}
		
		private function initAudioEngine(): void
		{
			var buffer: AudioBuffer = new AudioBuffer( 4, Audio.STEREO, Audio.BIT16, Audio.RATE44100 );
			buffer.onInit = onAudioBufferInit;
			buffer.onComplete = onAudioBufferComplete;
			
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
			var output: Sample;
			var input: Sample;
			
			//-- compute speed
			var speed: Number = wav.rate / buffer.getRate();
			
			//-- CREATE ONE SECOND OF AUDIO (SINUS WAVE)
			for( var i: int = 0 ; i < samples.length ; i++ )
			{
				//-- store local
				output = samples[i];
				input = wav.samples[ int( phase ) ];

				//-- write to sample
				output.left = input.left;
				output.right = input.right;
				
				//-- move pointer
				phase += speed;
				
				if( phase < 0 )
					phase += wav.samples.length;
				else if( phase >= wav.samples.length )
					phase -= wav.samples.length;
			}
			
			filter.processAudio( samples );
			
			//-- update audio buffer
			buffer.update();
		}
	}
}
