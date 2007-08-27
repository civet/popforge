package de.popforge.fui.core
{
	import de.popforge.interpolation.Interpolation;
	
	public interface IInterpolationBindable
	{
		function connect( interpolation: Interpolation ): void;
		function disconnect(): void;
	}
}