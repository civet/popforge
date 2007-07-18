package de.popforge.audio.processor.bitboy
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.audio.processor.bitboy.channels.ChannelBase;
	import de.popforge.audio.processor.bitboy.formats.FormatBase;
	import de.popforge.audio.processor.bitboy.formats.TriggerBase;
	import de.popforge.parameter.MappingBoolean;
	import de.popforge.parameter.MappingIntLinear;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	import flash.utils.getTimer;
	
	public class BitBoy
		implements IAudioProcessor
	{
		static private const RATIO: Number = 2.5;
		
		public const parameterGain: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const parameterMute: Parameter = new Parameter( new MappingBoolean(), false );
		public const parameterPause: Parameter = new Parameter( new MappingBoolean(), false );
		public const parameterChannel: Parameter = new Parameter( new MappingIntLinear( 0, 0xf ), 0xf );
		public const parameterLoopMode: Parameter = new Parameter( new MappingBoolean(), false );
				
		private var length: int;
		
		private var format: FormatBase;
		private var channels: Array;

		private var rate: Number;
		private var bpm: Number;
		private var speed: int;

		private var tick: int;
		private var rowIndex: int;
		private var patIndex: int;
		
		private var incrementPatIndex: Boolean;

		private var samplesPerTick: int;		
		private var rest: int = 0;
		
		private var complete: Boolean;
		private var lastRow: Boolean;
		private var idle: Boolean;
		private var loop: Boolean;
		
		/**
		 * Create a Bitboy instance
		 */
		public function BitBoy()
		{
			//init();
		}
		
		/**
		 * Returns true is lastRow
		 */
		public function isIdle(): Boolean
		{
			return idle;
		}
		
		/**
		 * set the mod format
		 */
		public function setFormat( format: FormatBase ): void
		{
			this.format = format;
			
			init();
			
			length = computeLengthInSeconds();
			
			reset();
		}
		
		/**
		 * returns song length in seconds. returns -1 if the loop is looped
		 */
		public function getLengthSeconds(): int
		{
			return length;
		}
		
		/**
		 * process audio stream
		 * 
		 * param samples The samples Array to be filled
		 */
		public function processAudio( samples: Array ): void
		{
			if( complete )
			{
				idle = true;
				return;
			}
			
			var samplesAvailable: int = samples.length;
			var sampleIndex: int = rest;

			var channel: ModChannel;

			var subset: Array;
			
			//-- process rest, if any
			if( rest > 0 )
			{
				subset = samples.slice( 0, rest );
				for each( channel in channels )
					channel.processAudioAdd( subset );

				samplesAvailable -= rest;
				
				nextTick();
			}
			
			//-- procees complete tick duration
			while( samplesAvailable >= samplesPerTick )
			{
				nextTick();
				
				subset = samples.slice( sampleIndex, sampleIndex + samplesPerTick );

				for each( channel in channels )
					channel.processAudioAdd( subset );

				samplesAvailable -= samplesPerTick;
				sampleIndex += samplesPerTick;
			}
			
			//-- procees remaining samples
			subset = samples.slice( -samplesAvailable );
			for each( channel in channels )
				channel.processAudioAdd( subset );
			
			rest = samplesPerTick - samplesAvailable;
		}
		
		public function reset(): void
		{
			rate = Audio.RATE22050;
			speed = format.defaultSpeed;
			tick = 0;

			setBPM( format.defaultBpm );

			rowIndex = 0;
			patIndex = 0;
			
			complete = false;
			lastRow = false;
			idle = false;
			loop = false;
			incrementPatIndex = false;
			
			var channel: ModChannel;
			
			for each( channel in channels )
				channel.reset();
		}
		
		internal function setBPM( bpm: int ): void
		{
			samplesPerTick = rate * RATIO / bpm;
			
			this.bpm = bpm;
		}
		
		internal function setSpeed( speed: int ): void
		{
			this.speed = speed;
		}
		
		internal function setRowIndex( rowIndex: int ): void
		{
			this.rowIndex = rowIndex;
		}
		
		internal function getRowIndex(): int
		{
			return rowIndex;
		}
		
		internal function getRate(): Number
		{
			return rate;
		}
		
		internal function patternJump( patIndex: int ): void
		{
			if( patIndex <= this.patIndex )
			{
				loop = true;
			}
			
			this.patIndex = patIndex;
			
			setRowIndex( 0 );
		}
		
		internal function patternBreak( rowIndex: int ): void
		{
			setRowIndex( rowIndex );
			
			incrementPatIndex = true;
		}

		private function init(): void
		{
			channels = format.getChannels( this );
			/*[
				new ModChannel( this, 0, -1 ),
				new ModChannel( this, 1, 1 ),
				new ModChannel( this, 2, 1 ),
				new ModChannel( this, 3, -1 )
			];*/
		}
		
		private function nextTick(): void
		{
			if( --tick <= 0 )
			{
				if( lastRow )
				{
					complete = true;
				}
				else
				{
					rowComplete();
					
					tick = speed;
				}
			}
			else
			{
				for each( var channel: ModChannel in channels )
					channel.onTick( tick );
			}
		}
		
		private function rowComplete(): void
		{
			var channel: ChannelBase;
			//-- sync all parameter changes for smooth cuttings
			//
			
			if( !parameterPause.getValue() )
			{
				var mutes: int;
				
				if( parameterMute.getValue() )
					mutes = 0;
				else
					mutes = parameterChannel.getValue();
				
				for ( var i: int = 0; i < format.numChannels; ++i )
				{
					channel = channels[i];
					
					channel.setMute( ( mutes & ( 1 << i ) ) == 0 );
				}
				/*
				ModChannel( channels[0] ).setMute( ( mutes & 0x1 ) == 0 );
				ModChannel( channels[1] ).setMute( ( mutes & 0x2 ) == 0 );
				ModChannel( channels[2] ).setMute( ( mutes & 0x4 ) == 0 );
				ModChannel( channels[3] ).setMute( ( mutes & 0x8 ) == 0 );
				*/
				nextRow();
			}
			else
			{
				for each ( channel in channels )
					channel.setMute( true );
			}		
		}
		
		private function nextRow(): void
		{
			var channel: ModChannel;
			var channelIndex: int;
			
			var currentPatIndex: int = patIndex;
			var currentRowIndex: int = rowIndex++;
			
			incrementPatIndex = false;
			
			for ( channelIndex = 0; channelIndex < format.numChannels; ++channelIndex )
			{
				channel = channels[ channelIndex ];
				
				//UPDATE channel.modTrigger( modFormat.patterns[ modFormat.sequence[ currentPatIndex ] ][ currentRowIndex ][ channelIndex ] );
				channel.onTrigger( TriggerBase( format.getTriggerAt( format.getSequenceAt( currentPatIndex ), currentRowIndex, channelIndex ) ) );
			}
			
			if( incrementPatIndex )
			{
				nextPattern();
			}
			//UPDATE else if( rowIndex > 63 )
			else if ( rowIndex == format.getPatternLength( format.getSequenceAt( currentPatIndex ) ) )
			{
				rowIndex = 0;
				nextPattern();
			}
		}
		
		private function nextPattern(): void
		{
			//UPDATE if( ++patIndex == modFormat.sequence.length )
			if( ++patIndex == format.length )
			{
				if( parameterLoopMode.getValue() )
					//UPDATE patIndex = 0;
					patIndex = format.restartPosition;
				else
					lastRow = true;
			}
		}
		
		private function computeLengthInSeconds(): int
		{
			reset();
			
			var channel: ModChannel;
			var channelIndex: int;
			
			var currentPatIndex: int;
			var currentRowIndex: int;
			
			var samplesTotal: Number = 0;
			
			var ms: uint = getTimer();
			
			while( getTimer() - ms < 1000 ) // just be save
			{
				if( lastRow )
					break;

				currentPatIndex = patIndex;
				currentRowIndex = rowIndex++;
				incrementPatIndex = false;
				
				//UPDATE for( channelIndex = 0; channelIndex < 4; ++channelIndex )
				for ( channelIndex = 0; channelIndex < format.numChannels; ++channelIndex )				
				{
					channel = channels[ channelIndex ];
					//UPDATE channel.modTrigger( modFormat.patterns[ modFormat.sequence[ currentPatIndex ] ][ currentRowIndex ][ channelIndex ] );
					channel.onTrigger( TriggerBase( format.getTriggerAt( format.getSequenceAt( currentPatIndex ), currentRowIndex, channelIndex ) ) );
				}
				
				if ( loop )
					return -1;
				
				if ( incrementPatIndex )
					nextPattern();
				
				//UPDATE if( rowIndex > 63 )
				if ( rowIndex == format.getPatternLength( format.getSequenceAt( currentPatIndex ) ) )
				{
					rowIndex = 0;
					nextPattern();
				}
				
				samplesTotal += samplesPerTick * speed;
			}
			
			return samplesTotal / rate;
		}
	}
}