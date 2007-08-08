package de.popforge.audio.processor.fl909.memory
{
	public final class Trigger
	{
		public var voiceIndex: uint;
		public var accent: Boolean;
		
		public function Trigger( voiceIndex: uint, accent: Boolean = false )
		{
			this.voiceIndex = voiceIndex;
			this.accent = accent;
		}
	}
}