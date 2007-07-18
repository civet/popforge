package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.bitboy.formats.FormatBase;
	import de.popforge.audio.processor.bitboy.formats.FormatFactory;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class ModLoader extends URLLoader
	{
		private var onModLoad: Function;
		
		public function ModLoader( url: String, onModLoad: Function )
		{
			super( new URLRequest( url ) );
			this.onModLoad = onModLoad;
			
			dataFormat = URLLoaderDataFormat.BINARY;
			addEventListener( Event.COMPLETE, onComplete );
			addEventListener( IOErrorEvent.IO_ERROR, onError );
		}
		
		private function onComplete( event: Event ): void
		{
			var format: FormatBase = FormatFactory.createFormat( data );
			
			onModLoad( format );
			
			removeEventListener( Event.COMPLETE, onComplete );
		}
		
		private function onError( event: IOErrorEvent ): void
		{
			trace( event );
			
			removeEventListener( IOErrorEvent.IO_ERROR, onError );
		}
	}
}