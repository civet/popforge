package de.popforge.audio.processor.fl909.memory
{
	public final class Memory
	{
		private var patternBank: Array;
		
		private var patternRun: Pattern;
		private var patternNext: Pattern;
		
		private var stepIndex: int;

		public function Memory()
		{
			patternBank = [ patternRun = patternNext = new Pattern() ];
		}
		
		public function changePatternByIndex( index: int ): void
		{
			if( patternBank[ index ] == null )
				patternBank[ index ] = new Pattern();
			
			patternNext = patternBank[ index ];
		}
		
		public function stepComplete(): void
		{
			if( ++stepIndex == patternRun.length )
			{
				patternRun = patternNext;
				stepIndex = 0;
			}
		}
		
		public function getTriggers(): Array
		{
			return patternRun.steps[ stepIndex ];
		}
		
		public function getPatternRun(): Pattern
		{
			return patternRun;
		}
		
		public function getPatternNext(): Pattern
		{
			return patternNext;
		}
		
		public function createTriggerAt( stepIndex: int, voiceIndex: int, accent: Boolean ): void
		{
			if( patternNext.steps[ stepIndex ] == null )
				patternNext.steps[ stepIndex ] = new Array();

			var triggers: Array = patternNext.steps[ stepIndex ];
			triggers.push( new Trigger( voiceIndex, accent ) );
		}
		
		public function removeTriggerAt( stepIndex: int, voiceIndex: int ): void
		{
			var triggers: Array = patternNext.steps[ stepIndex ];
			
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
		
		public function copyPattern( sourceIndex: int, targetIndex: int ): void
		{
			if( sourceIndex == targetIndex ) return;
			
			patternBank[ targetIndex ] = Pattern( patternBank[ sourceIndex ] ).clone();
		}
	}
}