package de.popforge.audio.processor.fl909.tone
{
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.Parameter;
	import de.popforge.parameter.MappingNumberLinear;
	
	public class ToneHighHat
	{
		public const levelCL: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .75 );
		public const levelOP: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), .6 );
		
		public const decayCL: Parameter = new Parameter( new MappingNumberExponential( 1, 7978 ), 1024 );
		public const decayOP: Parameter = new Parameter( new MappingNumberExponential( 1, 33777 ), 7168 );
	}
}