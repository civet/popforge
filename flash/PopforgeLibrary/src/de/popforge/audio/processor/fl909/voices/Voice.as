package de.popforge.audio.processor.fl909.voices
{
	public class Voice
	{
		protected var $start: int;
		protected var start: int;
		protected var volume: Number;
		
		protected var position: int;
		protected var length: int;
		protected var maxLength: int;
		
		protected var monophone: Boolean;
		
		public function Voice( start: int, volume: Number = 0 )
		{
			this.start = $start = start;
			this.volume = volume;
			
			position = 0;
			length = int.MAX_VALUE;
			maxLength = int.MAX_VALUE;
		}
		
		public function processAudioAdd( samples: Array ): Boolean
		{
			throw new Error( 'Override processAudioAdd().' );
			
			return true;
		}

		public function isMonophone(): Boolean
		{
			return monophone;
		}
		
		public function cut( offset: int ): void
		{
			if( position == 0 )
				length = offset - $start;
			else
				length = position + offset;
			
			if( length > maxLength )
				length = maxLength;
		}
	}
}