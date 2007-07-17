package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.bitboy.BitBoy;
	import de.popforge.audio.processor.bitboy.formats.mod.ModFormat;
	import de.popforge.audio.processor.bitboy.formats.mod.ModSample;
	
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class Display extends Sprite
	{
		private var bitboy: BitBoy;
		
		private var textfield: TextField;
		private var textformat: TextFormat;
		
		private var song: SongItem;
		private var songNo: String;
		private var songInfo: String;
		private var songCredits: Array; //-- mostly written in the sample name definition
		
		private var infoTimer: Timer;
		private var infoIndex: int;
		
		public function Display( bitboy: BitBoy )
		{
			this.bitboy = bitboy;
			
			init();
		}
		
		public function updateSong( song: SongItem ): void
		{
			songNo = new String( '0' + ( song.getId() + 1 ) ).substr( -2 );
			
			infoTimer.stop();
			
			this.song = song;
		}
		
		public function showPlayListSongInfo(): void
		{
			var format: ModFormat = song.getModFormat();
			
			var length: int = bitboy.getLengthSeconds();
			var duration: String;
			
			if( length == -1 )
			{
				duration = 'loop';
			}
			else
			{
				var mm: int = length / 60;
				var ss: int = length - mm * 60;
				
				duration = ( mm < 10 ? '0' + mm : mm ) + ':' + ( ss < 10 ? '0' + ss : ss );
			}
			
			songCredits = [ format.title + ' (' + duration + ')' ];
			
			var modSample: ModSample;
			
			for( var i: int = 1 ; i < format.modSamples.length ; i++ )
			{
				modSample = format.modSamples[i];
				
				if( modSample.title != '' )
				{
					songCredits.push( modSample.title );
				}
			}
			
			infoIndex = 0;
			
			textfield.text = songNo + ': ' + songCredits[ infoIndex ];
			
			if( song.hasCredits )
			{
				infoTimer.reset();
				infoTimer.start();
			}
		}
		
		public function showPlayListSongError( msg: String ): void
		{
			textfield.text = songNo + ': ' + '#error: ' + msg;
		}
		
		public function showError( msg: String ): void
		{
			textfield.text = '#error: ' + msg;
		}
		
		public function showPreloadingInformation( loader: URLLoader ): void
		{
			loader.addEventListener( ProgressEvent.PROGRESS, onPreloaderProcess );
		}
		
		private function onPreloaderProcess( event: ProgressEvent ): void
		{
			if( event.bytesLoaded < event.bytesTotal )
			{
				textfield.text = songNo + ': ' + new String( '0' + int( event.bytesLoaded / event.bytesTotal * 100 ) ).substr( -2 ) + '%';
			}
			else
			{
				URLLoader( event.target ).removeEventListener( ProgressEvent.PROGRESS, onPreloaderProcess );
			}
		}
		
		private function init(): void
		{
			textformat = new TextFormat();
			textformat.font = BitboyPlayer.FONT_NAME;
			textformat.size = 8;
			textformat.color = 0x0000ff;
			
			textfield = new TextField();
			textfield.embedFonts = true;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.selectable = false;
			textfield.defaultTextFormat = textformat;
			textfield.text = 'init...';
			addChild( textfield );
			
			infoTimer = new Timer( 2500, 0 );
			infoTimer.addEventListener( TimerEvent.TIMER, onNextInfo );
		}
		
		private function onNextInfo( event: TimerEvent ): void
		{
			if( ++infoIndex >= songCredits.length ) infoIndex = 0;
			
			textfield.text = songNo + ': ' + songCredits[ infoIndex ];
		}
	}
}