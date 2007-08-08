package de.popforge.audio.processor.fl909.voices
{
	public class Voice
	{
		protected var start: int;
		
		protected var position: int;
		protected var length: int;
		
		public function Voice( start: int )
		{
			this.start = start;
			
			position = 0;
			length = int.MAX_VALUE;
		}
		
		public function processAudioAdd( samples: Array ): Boolean
		{
			throw new Error( 'Override processAudioAdd().' );
			
			return true;
		}

		public function isMonophone(): Boolean
		{
			return false;
		}
		
		public function stop( offset: int ): void
		{
			length = position + offset;
		}
	}
}