package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class ToneRimshot extends ToneBase
	{
		public const level: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .7 );
	}
}