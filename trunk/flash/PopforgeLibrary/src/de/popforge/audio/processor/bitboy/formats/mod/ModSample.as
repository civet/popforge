package de.popforge.audio.processor.bitboy.formats.mod
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @private
	 */
	
	public final class ModSample
	{
		public var title: String;
		public var length: int;
		public var tone: int;
		public var volume: int;
		public var repeatStart: int;
		public var repeatEnd: int;
		public var waveform: ByteArray;
		public var wave: Array;
		
		public function ModSample( stream: ByteArray )
		{
			parse( stream );
		}
		
		public function loadWaveform( stream: ByteArray ): void
		{
			if ( length == 0 )
				return;

			waveform = new ByteArray();
			
			wave = new Array();
			
			for( var i: int = 0 ; i < length ; i++ )
			{
				wave.push( int( stream.readByte() ) );
			}
			
			//if( repeatEnd == 0 )
				//stream.readBytes( waveform, 0, length );
			//else
				//stream.readBytes( waveform, repeatStart, repeatEnd );
		}
		
		private function parse( stream: ByteArray ): void
		{
			stream.position = 0;			
			title = '';
			
			//-- read 22 chars into the title
			//   we dont break if we reach the NUL char cause this would turn
			//   the stream.position wrong
			for ( var i: int = 0; i < 22; i++ )
			{
				var char: uint = uint( stream.readByte() );
				if ( char != 0 )
					title += String.fromCharCode( char );
			}
			
			length = stream.readUnsignedShort();
			tone = stream.readUnsignedByte(); //everytime 0
			volume = stream.readUnsignedByte();
			repeatStart = stream.readUnsignedShort();
			repeatEnd = stream.readUnsignedShort();

			//-- turn it into bytes
			length <<= 1;
			repeatStart <<= 1;
			repeatEnd <<= 1;
		}
		
		public function toString(): String
		{
			return '[MOD Sample'
				+ ' title: '+ title
				+ ', length: ' + length
				+ ', tone: ' + tone
				+ ', volume: ' + volume
				+ ', repeatStart: ' + repeatStart
				+ ', repeatEnd: ' + repeatEnd
				+ ']';
		}
	}
}