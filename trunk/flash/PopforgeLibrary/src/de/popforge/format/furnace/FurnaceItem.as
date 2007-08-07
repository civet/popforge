package de.popforge.format.furnace
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	internal class FurnaceItem implements IExternalizable
	{
		internal var _fileName: String;
		internal var _index: uint;
		internal var _size: uint;
	
		public function FurnaceItem() {}
		
		public function get fileName(): String
		{
			return _fileName;
		}
		
		public function get index(): uint
		{
			return _index;
		}
		
		public function get fileSize(): uint
		{
			return _size;
		}
		
		public function writeExternal( output: IDataOutput ): void
		{
			//-- get correct length of utf bytes
			var name: ByteArray = new ByteArray;
			name.writeUTFBytes( _fileName );
			name.position = 0;
			
			output.writeShort( name.length );
			
			output.writeBytes( name, 0, name.length );
			
			output.writeUnsignedInt( _index );
			
			output.writeUnsignedInt( _size );
		}
		
		public function readExternal( input: IDataInput ): void
		{
			_fileName = input.readUTFBytes( input.readUnsignedShort() );
			
			_index = input.readUnsignedInt();
			
			_size = input.readUnsignedInt();
		}
		
		public function computeLength(): uint
		{
			//-- get correct length of utf bytes
			var name: ByteArray = new ByteArray;
			name.writeUTFBytes( _fileName );
			
			return	2 +  // length of name
					name.length +  // name
					4 +  // index
					4;   // file size
		}
		
		public function toString(): String
		{
			return '[FurnaceItem fileName: ' + fileName + ', index: 0x' + index.toString(0x10) + ', size:' + fileSize + ']';
		}
	}
}