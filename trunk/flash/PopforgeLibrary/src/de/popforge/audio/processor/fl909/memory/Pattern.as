package de.popforge.audio.processor.fl909.memory
{
	public final class Pattern
	{
		public const steps: Array = new Array();
		
		public var length: uint;
		
		public function Pattern( length: uint = 16 )
		{
			this.length = length;
		}
		
		public function clone(): Pattern
		{
			var copy: Pattern = new Pattern( length );
			
			var trigger: Trigger;
			var triggers: Array;
			
			for( var i: int = 0 ; i < length ; i++ )
			{
				triggers = copy.steps[i] = new Array();
				
				for each( trigger in steps[i] )
				{
					triggers.push( trigger.clone() );
				}
			}
			
			return copy;
		}
	}
}