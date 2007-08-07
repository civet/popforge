package de.popforge.format.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	public class FurnaceFormat implements IExternalizable
	{
		internal static const VERSION: Number = 1.0;
		
		internal var _header: FurnaceHeader;
		internal var _items: Array;
		internal var _library: Array;
		
		public function FurnaceFormat()
		{
			_header = new FurnaceHeader;
			_items = new Array;
			_library = new Array;
		}
		
		public function get numFiles(): uint
		{
			return _header.numFiles;
		}
		
		public function fileById( index: uint ): ByteArray
		{
			testBounds( index );
			return _library[ index ];
		}
		
		public function fileByName( fileName: String ): ByteArray
		{
			var i: int, n: uint;

			i = -1;
			n = _items.length;
			
			for (;i<n;++i)
			{
				if ( FurnaceItem( _items[ i ] ).fileName == fileName )
				{
					break;
				}
			}
			
			if ( i == -1 )
			{
				throw new Error( 'File does not exist.' );
			}
			
			return _library[ i ];
		}
		
		public function fileName( index: uint ): String
		{
			testBounds( index );
			return FurnaceItem( _items[ index ] ).fileName;	
		}
		
		public function addFile( file: ByteArray, name: String ): uint
		{
			var item: FurnaceItem = new FurnaceItem;
			item._fileName = name;
			
			_items.push( item );
			return _library.push( file );
		}
		
		protected function testBounds( index: uint ): void
		{
			if ( index < 0 || index >= _library.length )
			{
				throw new RangeError( 'index is out of bounds.' );
			}
		}
		
		public function writeExternal( output: IDataOutput ): void
		{
			var i: uint, n: uint;
			var totalLength: uint = 0;
			var headerAndItems: uint = 0;
			var item: FurnaceItem;
			var bytes: ByteArray;
			
			if ( _items.length != _library.length )
				throw new Error( 'Items and data must have the same length.' );
				
			compressLibrary();
			
			//-- BEGIN COMPUTE TOTAL LENGTH
			n = _items.length;
			totalLength += _header.computeLength();

			for ( i = 0; i < n; ++i )
			{
				totalLength += FurnaceItem( _items[ i ] ).computeLength();
			}
			
			headerAndItems = totalLength;
			
			for ( i = 0; i < n; ++i )
			{
				totalLength += ByteArray( _library[ i ] ).length;
			}
			//-- END COMPUTE TOTAL LENGTH
			
			_header._size = totalLength;
			_header._numFiles = n;
			
			_header.writeExternal( output );
			
			for ( i = 0; i < n; ++i )
			{
				var index: uint = headerAndItems;
				var j: uint = 0;
				
				for (;j<i;++j)
					index += ByteArray( _library[ j ] ).length;
					
				item = _items[ i ];
				
				item._index = index;
				item._size = ByteArray( _library[ i ] ).length;
				
				item.writeExternal( output );
			}
			
			for ( i = 0; i < n; ++i )
			{
				bytes = _library[ i ];
				bytes.position = 0;
				
				output.writeBytes( bytes, 0, bytes.length );
			}
		}
		
		public function readExternal( input: IDataInput ): void
		{
			var i: uint, n: uint;
			
			_header.readExternal( input );
			
			n = _header.numFiles;
			
			_items = new Array( n );
			_library = new Array( n );
			
			for ( i = 0; i < n; ++i )
			{
				var item: FurnaceItem = new FurnaceItem;
				
				item.readExternal( input );
				
				_items[ i ] = item;
			}
			
			for ( i = 0; i < n; ++i )
			{
				var bytes: ByteArray = new ByteArray;
				
				input.readBytes( bytes, 0, FurnaceItem( _items[ i ] )._size );
				
				_library[ i ] = bytes;
			}
			
			uncompressLibrary();
		}
		
		protected function compressLibrary(): void
		{
			var i: uint, n: uint;
			
			i = 0;
			n = _library.length;
			
			for (;i<n;++i)
			{
				ByteArray( _library[ i ] ).compress();
			}
		}
		
		protected function uncompressLibrary(): void
		{
			var i: uint, n: uint;
			
			i = 0;
			n = _library.length;
			
			for (;i<n;++i)
			{
				ByteArray( _library[ i ] ).uncompress();
				ByteArray( _library[ i ] ).position = 0;
			}
		}
		
		public function toString(): String
		{
			return '[FurnaceFormat header: ' + _header.toString() + ']';
		}
	}
}

/*
	==========================
	Furnace File Specification
	==========================

	Version: 1.0

	Description:	Furnace is a container format for ActionScript 3.
			All types are listed as ActionScript 3 types.

	### TYPES ###
	
	File format is built from types. The header occurs only once while
	items and data can appear "Number of files"-times.

	Encoding is LITTLE ENDIAN.


	Index		Length		Type		Description

	=========
	HEADER
	=========

	+ 0x0000	3b		String		Identifier (Should be "FUR")
	+ 0x0003	4b		File size	Total size of the file (including header)
	+ 0x0004	4b		Number		Version
	+ 0x0004	4b		uint		Number of files

	=========
	ITEM
	=========

	+ 0x0000	2b		uint		Length of Name (=LEN)
	+ 0x0002	LEN bytes	String		Filename
	+    LEN	4b		uint		Index of file data
	+  LEN+4	4b		uint 		Length of file

	=========
	DATA
	=========

	+ 0x00000	Length		ByteArray	GZip compressed content
			  of				of file
			 File


	### FILE LAYOUT ###
	
	HEADER
	ITEM 0
	ITEM 1
	  .
	  .
	ITEM N
	DATA 0
	DATA 1
	  .
	  .
	DATA N
*/