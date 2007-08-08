package de.popforge.audio.processor.fl909.voices
{
	import de.popforge.audio.output.Sample;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Rom
	{
		/**
		 * All sounds are converted in 44.1 Khz as raw data
		 */
		//-- These are mostlikely the original sounds of the TR909 rom (8Bit)
		[Embed(source="/rom/909.ri.raw", mimeType="application/octet-stream")]
			static public const Ride: Class;
		[Embed(source="/rom/909.cr.raw", mimeType="application/octet-stream")]
			static public const Crash: Class;

		//-- These are sampled pieces I collect and convert to raw (16Bit)
		[Embed(source="/rom/909.ch.raw", mimeType="application/octet-stream")]
			static public const HighhatClosed: Class;
		[Embed(source="/rom/909.oh.raw", mimeType="application/octet-stream")]
			static public const HighhatOpen: Class;		
		[Embed(source="/rom/909.rim.raw", mimeType="application/octet-stream")]
			static public const Rimshot: Class;
		[Embed(source="/rom/909.clap.raw", mimeType="application/octet-stream")]
			static public const Clap: Class;
		[Embed(source="/rom/909.tl.raw", mimeType="application/octet-stream")]
			static public const TomLow: Class;
		[Embed(source="/rom/909.tm.raw", mimeType="application/octet-stream")]
			static public const TomMid: Class;
		[Embed(source="/rom/909.th.raw", mimeType="application/octet-stream")]
			static public const TomHigh: Class;
		[Embed(source="/rom/909.bd.noise.raw", mimeType="application/octet-stream")]
			static public const BassDrumNoise: Class;
		[Embed(source="/rom/909.bd.body.raw", mimeType="application/octet-stream")]
			static public const BassDrumBody: Class;
		[Embed(source="/rom/909.sd.raw", mimeType="application/octet-stream")]
			static public const SnareDrumBody: Class;

		static public function convert8Bit( data: ByteArray ): Array
		{
			var amplitudes: Array = new Array();
			
			var n: int = data.length;
			
			for( var i: int = 0 ; i < n ; i++ )
			{
				//-- RAW is encoded in Unsigned8Bit Mono
				amplitudes.push( ( 127 - data[i] ) / 127 );
			}
			
			//-- extra to clamp around
			amplitudes.push( amplitudes[0] );
			
			return amplitudes;
		}
		
		static public function convert16Bit( data: ByteArray ): Array
		{
			data.endian = Endian.LITTLE_ENDIAN;
			
			var amplitudes: Array = new Array();
			
			var n: int = data.length >> 1;
			
			for( var i: int = 0 ; i < n ; i++ )
			{
				//-- RAW is encoded in signed16Bit Mono
				amplitudes.push( data.readShort() / 0x7fff );
			}
			
			//-- extra to clamp around
			amplitudes.push( amplitudes[0] );
			
			return amplitudes;
		}
	}
}