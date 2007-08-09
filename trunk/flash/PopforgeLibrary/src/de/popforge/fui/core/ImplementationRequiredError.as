package de.popforge.fui.core
{
	public class ImplementationRequiredError extends Error
	{
		public function ImplementationRequiredError()
		{
			super( 'Method has to be overriden' );
		}
	}
}