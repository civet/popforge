package de.popforge.utils
{
	import de.popforge.parameter.Parameter;
	import de.popforge.utils.sprintf;
	
	public class Formatter
	{
		protected var format: String;
		protected var args: Array;
		
		protected var value: String;
		protected var changedCallbacks: Array;
		
		public function Formatter( format: String, ... args )
		{
			this.format = format;
			
			this.args = new Array;
			
			var i: int = 0;
			var n: int = args.length;
			var argument:*;
			
			for (;i<n;++i)
			{
				argument = args[i];
				
				if ( argument is Parameter )
				{
					Parameter( argument ).addChangedCallbacks( onParameterChanged );
				}
				
				this.args.push( argument );
			}
			
			updateValue();
			
			changedCallbacks = new Array();
		}
		
		public function getValue(): String
		{
			return value;
		}
		
		protected function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			var oldValue: String = value;
			
			updateValue();
			
			valueChanged( oldValue );
		}
		
		protected function updateValue(): void
		{
			var fargs: Array = [ format ];
			
			var i: int = 0;
			var n: int = args.length;
			var argument:*;
			
			for (;i<n;++i)
			{
				argument = args[i];
				
				if ( argument is Parameter )
				{
					fargs.push( Parameter( argument ).getValue() );
				}
				else
				{
					fargs.push( argument );
				}
			}
			
			value = sprintf.apply( null, fargs );
		}
		
		public function addChangedCallbacks( callback: Function ): void
		{
			changedCallbacks.push( callback );
		}
		
		public function removeChangedCallbacks( callback: Function ): void
		{
			var index: int = changedCallbacks.indexOf( callback );
			
			if( index > -1 )
				changedCallbacks.splice( index, 1 );
		}
		
		private function valueChanged( oldValue: String ): void
		{
			if( oldValue == value )
				return;
			
			try
			{
				for each( var callback: Function in changedCallbacks )
					callback( this, oldValue, value );
			}
			catch( e: ArgumentError )
			{
				throw new ArgumentError( 'Make sure callbacks have the following signature: (formatter: Formatter, oldValue: String, newValue: String)' );
			}
		}
	}
}