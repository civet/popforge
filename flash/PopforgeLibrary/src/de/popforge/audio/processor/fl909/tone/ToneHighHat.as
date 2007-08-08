package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.Parameter;
	import de.popforge.parameter.MappingNumberLinear;
	
	public class ToneHighHat
	{
		public const level: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		
		public const decayCL: Parameter = new Parameter( new MappingNumberLinear( 0, 7978 ), 1024 );
		public const decayOP: Parameter = new Parameter( new MappingNumberLinear( 0, 33777 ), 16888 );
	}
}