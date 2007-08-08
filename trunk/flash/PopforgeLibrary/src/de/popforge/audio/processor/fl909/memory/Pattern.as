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
	}
}