package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.effects.Distort;
	import de.popforge.format.wav.WavFormat;
	import de.popforge.interpolation.InterpolationCubic;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	import de.popforge.ui.procontroll.ProcontrollControl;
	import de.popforge.ui.procontroll.ProcontrollDevice;
	import de.popforge.ui.procontroll.ProcontrollStick;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import de.popforge.audio.processor.effects.Flanger;
	
	[SWF( backgroundColor='0xcccccc', frameRate='30', width='320', height='240')]
	
	/**
	 * Example PlayWavfile
	 * Creates endless dynamic audio with the content of a wavefile
	 * 
	 * @author Andre Michelle
	 */

	public class PlayWavfile extends Sprite
	{
		private var wav: WavFormat;
		private var phase: Number;
		
		private var pcc: ProcontrollControl;
		private var filter: Flanger;
		
		private var parameterPitch: Parameter;
		
		public function PlayWavfile()
		{
			parameterPitch = new Parameter( new MappingNumberLinear( -1, 3 ), 1 );
			
			filter = new Flanger();

			/**
			 * You need to have the Java server running and
			 * a Joystick with 'analogue sticks'
			 * Otherwise it is simply ignored.
			 */
			pcc = new ProcontrollControl( 'localhost', 10002 );
			//pcc.addEventListener( Event.INIT, onControlsInit );
			
			loadWave();
		}
		
		private function onControlsInit( event: Event ): void
		{
			var device: ProcontrollDevice = pcc.getDeviceByName( 'Logitech Dual Action' );
			
			if( device != null )
			{
				ProcontrollStick( device.sticks[0] ).setParameterX( parameterPitch );
				//ProcontrollStick( device.sticks[1] ).setParameterX( filter.parameterX );
				//ProcontrollStick( device.sticks[1] ).setParameterY( filter.parameterY );
			}
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
			var speed: Number = wav.rate / buffer.getRate() * parameterPitch.getValue();
			
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
