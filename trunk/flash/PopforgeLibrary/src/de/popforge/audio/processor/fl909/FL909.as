package de.popforge.audio.processor.fl909
{
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.processor.fl909.memory.Memory;
	import de.popforge.audio.processor.fl909.memory.Trigger;
	import de.popforge.audio.processor.fl909.tone.ToneBassdrum;
	import de.popforge.audio.processor.fl909.tone.ToneClap;
	import de.popforge.audio.processor.fl909.tone.ToneHighHat;
	import de.popforge.audio.processor.fl909.tone.ToneRimshot;
	import de.popforge.audio.processor.fl909.tone.ToneSnaredrum;
	import de.popforge.audio.processor.fl909.tone.ToneTom;
	import de.popforge.audio.processor.fl909.voices.Voice;
	import de.popforge.audio.processor.fl909.voices.VoiceBassdrum;
	import de.popforge.audio.processor.fl909.voices.VoiceClap;
	import de.popforge.audio.processor.fl909.voices.VoiceHiHat;
	import de.popforge.parameter.MappingIntLinear;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	import flash.utils.getQualifiedClassName;
	import de.popforge.audio.processor.fl909.voices.VoiceRimshot;
	
	/**
	 * UNDER DEVELOPMENT
	 */

	public final class FL909
		implements IAudioProcessor
	{
		/**
		 * FL909 PARAMETER
		 */
		public const volume: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .8 );
		public const accent: Parameter = new Parameter( new MappingNumberLinear( .2, .8 ), .5 );
		public const tempo: Parameter = new Parameter( new MappingNumberLinear( 30, 180 ), 127 );
		public const shuffle: Parameter = new Parameter( new MappingNumberLinear( 1, 1.5 ), 1 );

		/**
		 * VOICE TONE COLORS (adjustable parameters each voice)
		 */
		public const toneBassdrum: ToneBassdrum = new ToneBassdrum();
		public const toneSnaredrum: ToneSnaredrum = new ToneSnaredrum();
		public const toneTomLow: ToneTom = new ToneTom();
		public const toneTomMid: ToneTom = new ToneTom();
		public const toneTomHigh: ToneTom = new ToneTom();
		public const toneRimshot: ToneRimshot = new ToneRimshot();
		public const toneClap: ToneClap = new ToneClap();
		public const toneHighHat: ToneHighHat = new ToneHighHat();

		/**
		 * SEQUENCER
		 */
		public const memory: Memory = new Memory();
		
		/**
		 * AUDIO
		 */
		private const activeVoices: Array = new Array();
		
		private var sampleOffset: int;

		public function FL909()
		{
			sampleOffset = 0;
		}
		
		/**
		 * PROCESS AUDIO
		 */
		public function processAudio( samples: Array ): void
		{
			advancePattern( samples.length );
			
			advanceVoices( samples );
		}
		
		/**
		 * RESET MACHINE
		 */
		public function reset(): void
		{
			activeVoices.splice( 0, activeVoices.length );
		}
		
		/**
		 * ADVANCE IN PATTERN STRUCTURE
		 */
		private function advancePattern( samplesNum: int ): void
		{
			var stepSampleNum: int = int( 15 * 44100 / tempo.getValue() );
			
			var triggers: Array;
			var trigger: Trigger;

			//-- Collect all triggers within buffer length
			while( sampleOffset < samplesNum )
			{
				triggers = memory.getTriggers();
				
				if( triggers )
				{
					for each( trigger in triggers )
					{
						switch( trigger.voiceIndex )
						{
							case 0: addVoice( new VoiceBassdrum( sampleOffset, toneBassdrum ) ); break;
							case 1:	addVoice( new VoiceHiHat( sampleOffset, toneHighHat, true ) ); break;
							case 2: addVoice( new VoiceHiHat( sampleOffset, toneHighHat, false ) ); break;
							case 3: addVoice( new VoiceClap( sampleOffset, toneClap ) ); break;
							case 4: addVoice( new VoiceRimshot( sampleOffset, toneRimshot ) ); break;
						}
					}
				}
				
				memory.stepComplete();

				sampleOffset += stepSampleNum;
			}
			
			sampleOffset -= samplesNum;
		}

		/**
		 * PROCESS AUDIO VOICES
		 */
		private function advanceVoices( samples: Array ): void
		{
			var complete: Boolean;
			
			var i: int = activeVoices.length;
			
			while( --i > -1 )
			{
				complete = Voice( activeVoices[i] ).processAudioAdd( samples );

				if( complete )
					activeVoices.splice( i, 1 );
			}
		}
		
		/**
		 * ADD VOICE FOR PROCESS AUDIO > MANAGE MONOPHONE
		 */
		private function addVoice( voice: Voice ): void
		{
			//-- CHECK MONOPHONE
			if( voice.isMonophone() )
			{
				var i: int = activeVoices.length;
				
				while( --i > -1 )
				{
					//-- check if type is active
					if( getQualifiedClassName( activeVoices[i] ) == getQualifiedClassName( voice ) )
					{
						//-- stop current voice, when new voice starts
						Voice( activeVoices[i] ).stop( sampleOffset );
						break;
					}
				}
			}
			
			activeVoices.push( voice );
		}
	}
}