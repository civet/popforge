package de.popforge.widget.bitboy
{
	import de.popforge.parameter.MappingBoolean;
	import de.popforge.parameter.Parameter;
	
	public class SongList
	{
		public const parameterShuffle: Parameter = new Parameter( new MappingBoolean(), false );
		
		private var list: Array;
		
		private var position: int;
		
		public function SongList( xmlList: XMLList )
		{
			parse( xmlList );
			
			position = 0;
		}
		
		public function getCurrentSong(): SongItem
		{
			return list[ position ];
		}
		
		public function next(): void
		{
			if( parameterShuffle.getValue() )
				position = int( Math.random() * list.length );
			else if( ++position == list.length )
				position = 0;
		}
		
		public function prev(): void
		{
			if( parameterShuffle.getValue() )
				position = int( Math.random() * list.length );
			else if( --position < 0 )
				position = list.length - 1;
		}
		
		private function parse( xmlList: XMLList ): void
		{
			list = new Array();
			
			var id: int = 0;
			
			for each( var xml: XML in xmlList )
			{
				list.push( new SongItem( xml, id++ ) );
			}
		}
	}
}