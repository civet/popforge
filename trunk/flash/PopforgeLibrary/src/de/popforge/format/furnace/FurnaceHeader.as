package de.popforge.format.furnace
{
	import flash.utils.IExternalizable;
	import flash.utils.IDataOutput;
	import flash.utils.IDataInput;
	
	internal class FurnaceHeader implements IExternalizable
	{
		public static const IDENTIFIER: String = 'FUR';
		
		internal var _id: String;
		internal var _size: uint;
		internal var _numFiles: uint;
		
		public function FurnaceHeader() {}
		
		public function get id(): String
		{
			 return _id;
		}
		
		public function get size(): uint
		{
			return _size;
		}
		
		public function get numFiles(): uint
		{
			return _numFiles;
		}
		
		public function writeExternal( output: IDataOutput ): void
		{
			output.writeMultiByte( IDENTIFIER, 'us-ascii' );
			
			output.writeUnsignedInt( _size );
			
			output.writeFloat( FurnaceFormat.VERSION );
			
			output.writeUnsignedInt( _numFiles );
		}
		
		public function readExternal( input: IDataInput ): void
		{
			if ( input.readMultiByte( 3, 'us-ascii' ) != IDENTIFIER )
				throw new Error( 'Can not parse FurnaceHeader (identifier invalid)' );
				
			_size = input.readUnsignedInt();
			
			if ( input.readFloat() > FurnaceFormat.VERSION )
				throw new Error( 'Can not parse FurnaceHeader (unsupported version)' );
			
			_numFiles = input.readUnsignedInt();
		}
		
		public function computeLength(): uint
		{
			return	3 + // id
					4 + // size
					4 + // version
					4;  // numFiles
		}
		
		public function toString(): String
		{
			return '[FurnaceHeader id:' + id + ', size: ' + size + ', numFiles: ' + numFiles + ']';
		}
	}
}