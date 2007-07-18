package de.popforge.audio.processor.bitboy.channels
{
	import de.popforge.audio.processor.bitboy.BitBoy;
	import de.popforge.audio.processor.bitboy.formats.TriggerBase;
	
	public class ChannelBase
	{
		protected var bitboy: BitBoy;
		protected var id: int;
		
		protected var defaultPanning: Number;
		
		protected var trigger: TriggerBase;
		
		/* WAVE */
		
		protected var wave: Array;
		protected var repeatStart: int;
		protected var repeatEnd: int;
		protected var volume: int;
		protected var position: int;
		
		protected var sampleOffset: int = 0;
		
		/* PITCH */
		protected var tone: int;
		protected var period: int;
		
		/* EFFECT */
		protected var effect: int;
		protected var effectParam: int;
		
		protected var mute: Boolean;
		
		public function ChannelBase( bitboy: BitBoy, id: int, defaultPanning: Number )
		{
			this.bitboy = bitboy;
			this.defaultPanning = defaultPanning;
			this.id = id;
		}
		
		public function setMute( value: Boolean ): void
		{
			mute = value;
		}
		
		public function reset(): void
		{
			
		}
		
		public function onTrigger( trigger: TriggerBase ): void
		{
			
		}
		
		public function processAudioAdd( samples: Array ): void
		{
			
		}
			
		public function toString(): String
		{
			return '[ChannelBase]';
		}
	}
}