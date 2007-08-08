package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public final class ToneTom
	{
		public const level: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const tune: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const decay: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
	}
}