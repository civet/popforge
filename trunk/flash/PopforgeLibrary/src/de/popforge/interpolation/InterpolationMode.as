package de.popforge.interpolation
{
	/**
	 * The InterpolationMode class is an enumeration of constant values that indicate which way an Interpolation object should act.
	 * @author Joa Ebert
 	 */
	public final class InterpolationMode
	{
		/** Calculate all values at runtime. */
		public static const RUNTIME: uint = 0;
		
		/** Use pre-calculated values from internal look-up table. */		
		public static const BAKED: uint = 1;
	}
}