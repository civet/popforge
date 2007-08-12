package de.popforge.fui.core
{
	public interface IFormatterBindable
	{
		function connect( /*formatter: Formatter*/ ): void;
		function disconnect(): void;
	}
}