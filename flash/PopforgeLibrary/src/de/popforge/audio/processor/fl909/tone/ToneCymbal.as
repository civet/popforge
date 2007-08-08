package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.MappingNumberLinear;
	import de.popforge.parameter.Parameter;
	
	public class ToneCymbal
	{
		public const levelRide: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .6 );
		public const tuneRide: Parameter = new Parameter( new MappingNumberExponential( .75, 1.3 ), 1 );
		public const levelCrash: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .6 );
		public const tuneCrash: Parameter = new Parameter( new MappingNumberExponential( .75, 1.3 ), 1 );
	}
}