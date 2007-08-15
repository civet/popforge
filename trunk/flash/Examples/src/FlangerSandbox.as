package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.AudioBuffer;
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.effects.Flanger;
	import de.popforge.format.wav.WavFormat;
	import de.popforge.gui.Label;
	import de.popforge.gui.Slider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.output.SoundFactory;
	import flash.media.Sound;
	import flash.utils.getTimer;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.processor.effects.FlangerNumber;
	
	[SWF( backgroundColor='0xffffff', frameRate='30', width='320', height='256')]
	
	/**
	 * @author Andre Michelle
	 */

	public class FlangerSandbox extends Sprite
	{
		private var buffer: AudioBuffer;
		
		private var debugField: TextField;
		
		private var wav: WavFormat;
		private var phase: Number;
		
		private var filter: FlangerNumber;
		
		public function FlangerSandbox()
		{
			filter = new FlangerNumber();
			
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
				label.y = i * 44 + 32;
				addChild( label );
				
				slider = new Slider( p[i].p, 128 );
				slider.x = 80;
				slider.y = i * 44 + 52;
				addChild( slider );
			}
			
			debugField = new TextField();
			debugField.autoSize = TextFieldAutoSize.LEFT;
			debugField.defaultTextFormat = new TextFormat( 'verdana', 9 );
			debugField.text = '...';
			addChild( debugField );
			
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
			buffer = new AudioBuffer( 4, Audio.STEREO, Audio.BIT16, Audio.RATE44100 );
			//buffer.onInit = onAudioBufferInit;
			//buffer.onComplete = onAudioBufferComplete;
			
			phase = 0;
			
			test();
		}
		
		private function onAudioBufferInit( buffer: AudioBuffer ): void
		{
			buffer.start();
		}
		
		private function onAudioBufferComplete( buffer: AudioBuffer ): void
		{
			//-- get array to store samples
			var samples: Array = buffer.getSamples();
			
			sampler( samples );
			
			filter.processAudio( samples );
			
			//-- update audio buffer
			buffer.update();
		}
		
		//-- dummy generator
		private function sampler( samples: Array ): void
		{
			var n: int = samples.length;
			//-- some locals
			var output: Sample;
			var input: Sample;
			
			//-- compute speed
			var speed: Number = wav.rate / buffer.getRate();
			
			for( var i: int = 0 ; i < n ; ++i )
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
		}
		
		private function test(): void
		{
			var millisAudio: int = 20000;
			
			var n: int = 44.100 * millisAudio; // 10 seconds audio
			
			var samples: Array = new Array();
			
			for( var i: int = 0 ; i < n ; ++i )
				samples.push( new Sample() );
			
			//-- fill with loop
			sampler( samples );
			
			var ms: int = getTimer();
			var elapsed: int;
			
			filter.processAudio( samples );
			
			elapsed = getTimer() - ms;
			
			debugField.text = elapsed.toString() + 'ms\n';
			
			debugField.appendText( int( millisAudio / elapsed ).toString() + ' x faster than runtime.' );
			
			SoundFactory.fromArray( samples, Audio.STEREO, Audio.BIT16, Audio.RATE44100, onSoundComplete );
		}
		
		private function onSoundComplete( sound: Sound ): void
		{
			sound.play();
		}
	}
}
