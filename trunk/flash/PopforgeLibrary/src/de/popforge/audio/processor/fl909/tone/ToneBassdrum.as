package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class ToneBassdrum
	{
		public const level: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const tune: Parameter = new Parameter( new MappingNumberLinear( 1, 6 ), 3 );
		public const attack: Parameter = new Parameter( new MappingNumberLinear( 1, 0 ), 1 );
		public const decay: Parameter = new Parameter( new MappingNumberExponential( 512, 8192 ), 4096 );
	}
}