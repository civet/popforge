package de.popforge.audio.processor.fl909.memory
{
	public final class Memory
	{
		private var pattern: Pattern;
		private var stepIndex: int;

		public function Memory()
		{
			test();
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
		
		private function test(): void
		{
			pattern = new Pattern( 8 );
			
			pattern.steps[0] = [ new Trigger( 0, false ) ];
			pattern.steps[2] = [ new Trigger( 2, false ) ];
			pattern.steps[3] = [ new Trigger( 1, false ) ];
			pattern.steps[4] = [ new Trigger( 0, false ), new Trigger( 3, false ) ];
			pattern.steps[6] = [ new Trigger( 2, false ) ];
		}
	}
}