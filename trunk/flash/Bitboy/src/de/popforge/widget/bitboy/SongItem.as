package de.popforge.widget.bitboy
{
	import de.popforge.audio.processor.bitboy.formats.mod.ModFormat;
	
	public class SongItem
	{
		private var xml: XML;
		private var id: int;
		private var format: ModFormat;
		
		public function SongItem( xml: XML, id: int )
		{
			this.xml = xml;
			this.id = id;
		}
		
		public function setModFormat( format: ModFormat ): void
		{
			this.format = format;
		}
		
		public function getModFormat(): ModFormat
		{
			return format;
		}
		
		public function getId(): int
		{
			return id;
		}
		
		public function get url(): String
		{
			return xml.@url;
		}
		
		public function get hasCredits(): Boolean
		{
			return xml.@hasCredits == 'true';
		}
	}
}