package
{
	import flash.net.Socket;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	/**
	 * This class provides saving binary files over a socket connection
	 * with a processing server application
	 */
	
	public class ExportBinarySocket extends Socket
	{
		static public const HOST: String = 'localhost';
		static public const PORT: int = 10002;
		
		static public function getInstance(): ExportBinarySocket
		{
			if( instance == null )
				instance = new ExportBinarySocket();
			return instance;
		}
		
		static private var instance: ExportBinarySocket;
		
		public function ExportBinarySocket()
		{
			configure();
		}
		
		public function saveFile( filename: String, bytes: ByteArray ): void
		{
			writeUTFBytes( filename );
			writeByte( 0 );
			writeBytes( bytes );
			
			flush();
		}
		
		private function configure(): void
		{
			addEventListener( IOErrorEvent.IO_ERROR, onSocketError );
			addEventListener( ProgressEvent.SOCKET_DATA, onData );
			connect( HOST, PORT );
		}
		
		private function onData( event: ProgressEvent ): void
		{
			trace( readUTFBytes( event.bytesLoaded ) );
		}
		
		private function onSocketError( event: IOErrorEvent ): void
		{
			trace( event );
		}
	}
}