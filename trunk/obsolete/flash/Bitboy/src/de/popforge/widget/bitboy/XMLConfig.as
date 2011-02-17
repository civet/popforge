package de.popforge.widget.bitboy
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class XMLConfig
	{
		public var onComplete: Function;
		
		private var xml: XML;
		private var songList: SongList;
		
		public function XMLConfig()
		{
			init();
		}
		
		public function getSongList(): SongList
		{
			return songList;
		}
		
		public function getParamValue( name: String ): String
		{
			return xml.parameter.param.(@name==name).@value;
		}
		
		private function init(): void
		{
			var loader: URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener( Event.COMPLETE, onXMLLoaderComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, onLoaderError );
			loader.load( new URLRequest( '8bitboy.xml' ) );
		}
		
		private function onXMLLoaderComplete( event: Event ): void
		{
			var data: String = URLLoader( event.target ).data;
			
			xml = new XML( data );
			
			if( xml.playlist.@phpPath == undefined )
			{
				songList = new SongList( xml.playlist.song );
				onComplete( true );
			}
			else
			{
				var loader: URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener( Event.COMPLETE, onPHPLoaderComplete );
				loader.addEventListener( IOErrorEvent.IO_ERROR, onLoaderError );
				loader.load( new URLRequest( xml.playlist.@phpPath ) );
			}
		}
		
		private function onPHPLoaderComplete( event: Event ): void
		{
			var data: String = URLLoader( event.target ).data;
			
			songList = new SongList( new XML( data ).song );
			onComplete( true );
		}
		
		private function onLoaderError( event: IOErrorEvent ): void
		{
			onComplete( false );
		}
	}
}