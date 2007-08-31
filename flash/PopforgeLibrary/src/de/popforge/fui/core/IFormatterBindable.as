package de.popforge.fui.core
{
	import de.popforge.utils.Formatter;
	
	public interface IFormatterBindable
	{
		function connect( formatter: Formatter ): void;
		function disconnect(): void;
	}
}