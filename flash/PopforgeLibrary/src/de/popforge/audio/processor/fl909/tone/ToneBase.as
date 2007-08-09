package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingBoolean;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class ToneBase
	{
		public const mute: Parameter = new Parameter( new MappingBoolean(), false );
		public const pan: Parameter = new Parameter( new MappingNumberLinear( -1, 1 ), 0 );
	}
}