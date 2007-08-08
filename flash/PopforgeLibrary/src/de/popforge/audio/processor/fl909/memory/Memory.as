package de.popforge.audio.processor.fl909.memory
{
	public final class Memory
	{
		private var pattern: Pattern;
		private var stepIndex: int;

		public function Memory()
		{
			pattern = new Pattern( 16 );
		}
		
		public function stepComplete(): void
		{
			if( ++stepIndex == pattern.length )
				stepIndex = 0;
		}
		
		public function getTriggers(): Array
		{
			return pattern.steps[ stepIndex ];
		}
		
		public function getPattern(): Pattern
		{
			return pattern;
		}
		
		public function createTriggerAt( pattern: Pattern, stepIndex: int, voiceIndex: int, accent: Boolean ): void
		{
			if( pattern.steps[ stepIndex ] == null )
				pattern.steps[ stepIndex ] = new Array();

			var triggers: Array = pattern.steps[ stepIndex ];
			triggers.push( new Trigger( voiceIndex, accent ) );
		}
		
		public function removeTriggerAt( pattern: Pattern, stepIndex: int, voiceIndex: int ): void
		{
			var triggers: Array = pattern.steps[ stepIndex ];
			
			if( triggers == null ) return;
			
			var i: int = triggers.length;
			
			while( --i > -1 )
			{
				if( Trigger( triggers[i] ).voiceIndex == voiceIndex )
				{
					triggers.splice( i, 1 );
					return;
				}
			}
		}
	}
}