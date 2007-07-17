package de.popforge.audio.processor.bitboy.formats.xm
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public final class XMFormat
	{
		internal static const VERBOSE: Boolean = false;
		internal static const ENCODING: String = 'us-ascii';
		
		private static const MAX_CHANNELS: uint = 0x20;
		private static const MAX_INSTRUMENTS: uint = 0x80;
		private static const MAX_PATTERNS: uint = 0x100;
		private static const MAX_LENGTH: uint = 0x100;
		
		public var patterns: Array;
		
		public var sequence: Array; //pattern order
		public var length: uint; //sequence length
		public var restartPosition: uint;
		
		public var title: String;
		
		public var numChannels: uint;
		public var numPatterns: uint;
		public var numInstruments: uint;
		
		public var useLinearSlides: Boolean;
		
		public var defaultTempo: uint;
		public var defaultBPM: uint;
		
		private var instruments: Array;
		
		static public function decode( stream: ByteArray ): XMFormat
		{
			return new XMFormat( stream );
		}
		
		public function XMFormat( stream: ByteArray )
		{
			patterns = new Array;
			instruments = new Array;
			
			parse( stream );
		}
		
		private function parse( stream: ByteArray ): void
		{
			var i: int;
			
			stream.position = 0;
			stream.endian = Endian.LITTLE_ENDIAN;
			
			var idText: String = stream.readMultiByte( 17, ENCODING );
			title = stream.readMultiByte( 20, ENCODING );

			if ( idText != 'Extended Module: ' )
				throw new XMFormatError( XMFormatError.FILE_CORRUPT );
				
			if ( VERBOSE ) trace( 'idText', idText );
			if ( VERBOSE ) trace( 'title', title );
			
			if ( stream.readUnsignedByte() != 0x1a )
				throw new XMFormatError( XMFormatError.FILE_CORRUPT );
				
			var trackerName: String = stream.readMultiByte( 20, ENCODING );
			
			if ( VERBOSE ) trace( 'trackerName', trackerName );
			
			var version: uint = stream.readUnsignedShort();
	
			if ( VERBOSE ) trace( 'version', version.toString(0x10) );
	
			if ( version > 0x0104 )//01 = major, 04 = minor
				throw new XMFormatError( XMFormatError.NOT_IMPLEMENTED );
			
			var headerSize: uint = stream.readUnsignedInt();
			
			if ( VERBOSE ) trace( 'headerSize', headerSize );
			
			length = stream.readUnsignedShort();//songLength in patterns
			
			if ( VERBOSE ) trace( 'length', length );
			
			if ( length > MAX_LENGTH )
				throw new XMFormatError( XMFormatError.MAX_LENGTH );
			
			restartPosition = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'restartPosition', restartPosition );
			
			numChannels = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'numChannels', numChannels );
			
			if ( numChannels > MAX_CHANNELS )
				throw new XMFormatError( XMFormatError.MAX_CHANNELS );
			
			numPatterns = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'numPatterns', numPatterns );
			
			if ( numPatterns > MAX_PATTERNS )
				throw new XMFormatError( XMFormatError.MAX_PATTERNS );
			
			numInstruments = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'numInstruments', numInstruments );
			
			if ( numInstruments > MAX_INSTRUMENTS )
				throw new XMFormatError( XMFormatError.MAX_INSTRUMENTS );
			
			var flags: uint = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'flags', flags.toString(0x02) );
			
			useLinearSlides = ( ( flags & 1 ) == 1 );
			
			defaultTempo = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'defaultTempo', defaultTempo );
			
			defaultBPM = stream.readUnsignedShort();
			
			if ( VERBOSE ) trace( 'defaultBPM', defaultBPM );
			
			sequence = new Array( length );
			
			for ( i = 0; i < length; ++i )
			{
				sequence[ i ] = stream.readUnsignedByte();
			}
			
			stream.position += 0x100 - length;
			
			if ( VERBOSE ) trace( 'sequence', sequence );
			
			//-- seek to instruments by getting pattern headers
			for ( i = 0; i < numPatterns; ++i )
			{
				patterns.push( new XMPattern( stream ) );
			}
			
			//-- parse instruments
			for ( i = 0; i < numInstruments; ++i )
			{
				instruments.push( new XMInstrument( stream, i + 1 ) );
				//if ( VERBOSE ) trace( XMInstrument( instruments[ i ] ).toString() );
			}
			
			//-- parse pattern data now
			for ( i = 0; i < numPatterns; ++i )
			{
				XMPattern( patterns[ i ] ).parseData( stream, numChannels, instruments );
				//if ( VERBOSE ) trace( XMPattern( patterns[ i ] ).toASCII() );
			}
			
			// access a trigger:
			// patternId = id of pattern
			// rowNumber = number of row in pattern
			// channelNumber = desired channel
			//
			// XMTrigger( XMPattern( patterns[ patternId ] ).rows[ rowNumber ][ channelNumber ] )
		}
	}
}