package de.popforge.fui.core
{
	import de.popforge.parameter.Parameter;
	
	public interface IParameterBindable
	{
		function connect( parameter: Parameter ): void;
		function disconnect(): void;
	}
}