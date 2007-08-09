package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public final class ToneTom extends ToneBase
	{
		public const level: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const tune: Parameter = new Parameter( new MappingNumberExponential( .75, 1.3 ), 1 );
		public const decay: Parameter = new Parameter( new MappingNumberLinear( .3, 1 ), .75 );
	}
}