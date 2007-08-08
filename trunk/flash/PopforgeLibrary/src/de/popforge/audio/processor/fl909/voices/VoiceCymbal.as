package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.fl909.tone.ToneCymbal;
	
	public final class VoiceCymbal extends Voice
	{
		static public const RIDE: uint = 0;
		static public const CRASH: uint = 1;
		
		static private const snd0: Array = Rom.convert8Bit( new Rom.Ride() );
		static private const snd1: Array = Rom.convert8Bit( new Rom.Crash() );
		
		private var snd: Array;

		private var levelValue: Number;
		private var tuneValue: Number;
		
		public function VoiceCymbal( start: int, volume: Number, tone: ToneCymbal, size: uint )
		{
			super( start );
			
			switch( size )
			{
				case RIDE:
				
					snd = snd0;
					tuneValue = tone.tuneRide.getValue();
					levelValue = tone.levelRide.getValue() * volume;
					break;
					
				case CRASH:
				
					snd = snd1;
					tuneValue = tone.tuneCrash.getValue();
					levelValue = tone.levelCrash.getValue() * volume;					
					break;
					
				default:
				
					throw new Error( 'Sound is not known.' ); return;
			}
			
			length = snd.length - 1;
		}
		
		public override function processAudioAdd( samples: Array ): Boolean
		{
			var n: int = samples.length;
			
			var sample: Sample;
			var amplitude: Number;
			
			var tunePos: Number;
			var tunePosInt: int;
			var alpha: Number;
			
			for( var i: int = start ; i < n ; i++ )
			{
				sample = samples[i];
				
				//-- LINEAR INTERPOLATION
				tunePos = ( position++ ) * tuneValue;
				tunePosInt = tunePos;
				
				if( tunePosInt >= length )
					return true;
				
				alpha = tunePos - tunePosInt;
				
				amplitude = snd[ tunePosInt ] * ( 1 - alpha );
				amplitude += snd[ tunePosInt + 1 ] * alpha;
				amplitude *= levelValue;

				//-- ADD AMPLITUDE (MONO)
				sample.left += amplitude;
				sample.right += amplitude;
			}
			
			start = 0;
			
			return false;
		}
		
		public override function isMonophone(): Boolean
		{
			return true;
		}
	}
}