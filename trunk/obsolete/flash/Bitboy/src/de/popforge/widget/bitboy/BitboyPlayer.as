package de.popforge.widget.bitboy
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.bitboy.BitBoy;
	import de.popforge.audio.processor.bitboy.formats.FormatBase;
	import de.popforge.bitboy.assets.Background;
	import de.popforge.ui.KeyboardShortcut;

	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.SampleDataEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.media.Sound;
	import flash.utils.getTimer;

	public class BitboyPlayer extends Sprite
	{
		static public const LOOP_PLAY_TIME_SEC: uint = 120;
		static public const BUFFER_SIZE: int = 4096;
		
		[Embed(source='/../assets/font/04B_03__.TTF', fontName='bitboy_font', unicodeRange='U+0020-U+007E' )]
			static private const Font04B_03: Class;
		
		static public const FONT_NAME: String = 'bitboy_font';
		
		//-- AUDIO
		private var bitboy: BitBoy;
		private var lastBuffer: Boolean;
		private var fader: AudioFadeOut;
		private var stereoEnhancer: StereoEnhancer;
		private var bassBoost: BassBoost;
		
		//-- Flash10
		private var sound: Sound;
		private var buffer: Array;
		private var isRunning: Boolean;

		//-- GUI
		private var volumeSlider: VolumeSlider;
		private var muteButton: MuteButton;
		private var stopButton: StopButton;
		private var playPauseButton: PlayPauseButton;
		private var prevButton: PrevButton;
		private var nextButton: NextButton;
		private var shuffleModeButton: ShuffleModeButton;
		private var loopModeButton: LoopModeButton;
		private var display: Display;
		private var spectrum: Spectrum;
		private var bitMenu: BitMenu;
		
		private var xmlConfig: XMLConfig;
		private var songList: SongList;
		private var modLoader: ModLoader;
		
		private var startTime: uint;
		private var autoStart: Boolean;
		
		public function BitboyPlayer()
		{
			loadXMLConfig();
		}
		
		internal function stop(): void
		{
			bitboy.parameterPause.setValue( true );
			bitboy.reset();
		}
		
		internal function prev(): void
		{
			bitboy.parameterPause.setValue( true );
			songList.prev();
			loadMod();
		}
		
		internal function next(): void
		{
			bitboy.parameterPause.setValue( true );
			songList.next();
			loadMod();
		}
		
		internal function setStereoEnhancement( value: Boolean ): void
		{
			stereoEnhancer = value ? new StereoEnhancer( 44100 ) : null;
		}
		
		internal function setBassBoost( value: Boolean ): void
		{
			bassBoost = value ? new BassBoost( 44100 ) : null;
		}
		
		private function loadXMLConfig(): void
		{
			xmlConfig = new XMLConfig();
			xmlConfig.onComplete = onXMLConfigComplete;
		}
		
		private function onXMLConfigComplete( success: Boolean ): void
		{
			if( success )
			{
				initAudioEngine();
				
				songList = xmlConfig.getSongList();
				bitboy.parameterGain.setValueNormalized( parseFloat( xmlConfig.getParamValue( 'volume' ) ) );
				
				autoStart = xmlConfig.getParamValue( 'autostart' ) == 'true';
				
				build();
			}
		}
		
		private function initAudioEngine(): void
		{
			bitboy = new BitBoy();
			
			buffer = new Array();
			
			for( var i: int = 0 ; i < BUFFER_SIZE ; ++i )
				buffer[i] = new Sample();
			
			sound = new Sound();
			sound.addEventListener( SampleDataEvent.SAMPLE_DATA, onSampleData );
			sound.play();
		}
		
		private function onSampleData( event: SampleDataEvent ): void
		{
			if( isRunning )
			{
				bitboy.processAudio( buffer );
				
				if( bassBoost )
					bassBoost.processAudio( buffer );
				
				if( stereoEnhancer )
					stereoEnhancer.processAudio( buffer );
				
				if( lastBuffer )
				{
					onModComplete();
				}
				else if( bitboy.isIdle() )
				{
					lastBuffer = true;
				}
				else if( fader != null )
				{
					if( fader.proceesAudio( buffer ) )
					{
						fader = null;
						next();
					}
				}
				else if( !bitboy.parameterLoopMode.getValue() )
				{
					if( bitboy.getLengthSeconds() == -1 && getTimer() / 1000 - startTime > LOOP_PLAY_TIME_SEC )
						fader = new AudioFadeOut( 44100 );
				}
			}
			
			var sample: Sample;
			
			var i: int = 0;
			var n: int = BUFFER_SIZE;
			
			for( ; i < n ; ++i )
			{
				sample = buffer[i];
				
				event.data.writeFloat( sample.left );
				event.data.writeFloat( sample.right );
				
				sample.left = 0.0;
				sample.right = 0.0;
			}
		}

		private function loadMod(): void
		{
			if( modLoader != null )
			{
				modLoader.close();
			}
			
			modLoader = new ModLoader( songList.getCurrentSong().url, onModLoad );
			
			display.showPreloadingInformation( modLoader );
			
			display.updateSong( songList.getCurrentSong() );
			
			startTime = int.MAX_VALUE;
			
			isRunning = false;
		}
		
		private function onModLoad( format: FormatBase ): void
		{
			bitboy.setFormat( format );
			
			songList.getCurrentSong().setFormat( format );
			
			display.showPlayListSongInfo();
			
			bitboy.parameterPause.setValue( !autoStart );
			
			autoStart = true;
			
			startTime = getTimer() / 1000;
			
			modLoader = null;
			
			isRunning = true;
		}
		
		private function onModComplete(): void
		{
			if( stereoEnhancer )
				stereoEnhancer.reset();
			
			startTime = int.MAX_VALUE;
			bitboy.parameterPause.setValue( true );
			songList.next();
			loadMod();
			lastBuffer = false;
		}
		
		private function build(): void
		{
			addChild( new Bitmap( new Background(0,0) ) );
			
			volumeSlider = new VolumeSlider( bitboy.parameterGain );
			volumeSlider.x = 61;
			volumeSlider.y = 5;
			addChild( volumeSlider );
			
			muteButton = new MuteButton( bitboy.parameterMute );
			muteButton.x = 134;
			muteButton.y = 4;
			addChild( muteButton );
			
			playPauseButton = new PlayPauseButton( bitboy.parameterPause );
			playPauseButton.x = 0;
			playPauseButton.y = 48;
			addChild( playPauseButton );
			
			stopButton = new StopButton( this );
			stopButton.x = 39;
			stopButton.y = 48;
			addChild( stopButton );
			
			prevButton = new PrevButton( this );
			prevButton.x = 62;
			prevButton.y = 48;
			addChild( prevButton );

			nextButton = new NextButton( this );
			nextButton.x = 82;
			nextButton.y = 48;
			addChild( nextButton );

			shuffleModeButton = new ShuffleModeButton( songList.parameterShuffle );
			shuffleModeButton.x = 128;
			shuffleModeButton.y = 48;
			addChild( shuffleModeButton );

			loopModeButton = new LoopModeButton( bitboy.parameterLoopMode );
			loopModeButton.x = 105;
			loopModeButton.y = 48;
			addChild( loopModeButton );
			
			display = new Display( bitboy );
			display.x = 4;
			display.y = 14;
			addChild( display );
			
			spectrum = new Spectrum();
			spectrum.x = 4;
			spectrum.y = 29;
			addChild( spectrum );
			
			//-- AVOID ContextMenu Bug (otherwise contextMenu isn't enabled on bitmaps)
			var s: Shape = new Shape();
			s.graphics.beginFill( 0, 0 );
			s.graphics.drawRect( 0, 0, 150, 57 );
			s.graphics.endFill();
			addChild( s );
			
			bitMenu = new BitMenu( this );

			tintUI();
			
			KeyboardShortcut.getInstance().addShortcut( onChannelMute, [ 17, 49 ], 1 );
			KeyboardShortcut.getInstance().addShortcut( onChannelMute, [ 17, 50 ], 2 );
			KeyboardShortcut.getInstance().addShortcut( onChannelMute, [ 17, 51 ], 4 );
			KeyboardShortcut.getInstance().addShortcut( onChannelMute, [ 17, 52 ], 8 );
			
			loadMod();
		}
		
		private function onChannelMute( channelIndex: int ): void
		{
			var bits: int = bitboy.parameterChannel.getValue();
			
			bits ^= channelIndex;
			
			bitboy.parameterChannel.setValue( bits );
		}
		
		private function tintUI(): void
		{
			//-- Replace Placeholder Colors [blue,green]
			var color0: uint = parseInt( xmlConfig.getParamValue( 'background' ), 16 );
			var color1: uint = parseInt( xmlConfig.getParamValue( 'foreground' ), 16 );
			
			//-- compute colorcomponents
			var a0: Number = ( color0 >> 24 & 0xff ) / 0xff;
			var r0: Number = ( color0 >> 16 & 0xff ) / 0xff;
			var g0: Number = ( color0 >> 8 & 0xff ) / 0xff;
			var b0: Number = ( color0 & 0xff ) / 0xff;

			var a1: Number = ( color1 >> 24 & 0xff ) / 0xff;
			var r1: Number = ( color1 >> 16 & 0xff ) / 0xff;
			var g1: Number = ( color1 >> 8 & 0xff ) / 0xff;
			var b1: Number = ( color1 & 0xff ) / 0xff;
			
			//-- replace matrix
			var matrix: Array =
			[
				0, r0, r1, 0, 0,
				0, g0, g1, 0, 0,
				0, b0, b1, 0, 0,
				0, a0-1, a1-1, 1, 0
			];
			
			filters = [ new ColorMatrixFilter( matrix ) ];
		}
	}
}