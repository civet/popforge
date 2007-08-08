package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneHighHat;
	
	public final class VoiceHiHat extends Voice
	{
		static private const sndCL: Array = Rom.convert16Bit( new Rom.HighhatClosed() );
		static private const sndOP: Array = Rom.convert8Bit( new Rom.HighhatOpen() );
		
		static private const sndCLLength: int = sndCL.length - 1;
		static private const sndOPLength: int = sndOP.length - 1;

		private var tone: ToneHighHat;
		private var closed: Boolean;
		
		public function VoiceHiHat( start: int, tone: ToneHighHat, closed: Boolean )
		{
			super( start );
			
			this.tone = tone;
			this.closed = closed;
			
			length = closed ? sndCLLength : sndOPLength;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			if( closed )
				return processClosed( samples );

			return processOpen( samples );
		}
		
		public override function isMonophone(): Boolean
		{
			return true;
		}
		
		private function processClosed( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var level: Number = 1;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				amplitude = sndCL[ position++ ] * level;

				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				if( position >= length )
					return true;
			}
			
			start = 0;
			
			return false;
		}
		
		private function processOpen( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var level: Number = 1;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				amplitude = sndOP[ position++ ] * level;

				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;

				if( position >= length )
					return true;
			}
			
			start = 0;
			
			return false;
		}
	}
}