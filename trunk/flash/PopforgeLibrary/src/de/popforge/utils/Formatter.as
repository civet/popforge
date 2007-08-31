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
				else
				if ( argument is Formatter )
				{
					Formatter( argument ).addChangedCallbacks( onFormatterChanged );
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
		
		protected function onFormatterChanged( formatter: Formatter, oldValue: String, newValue: String ): void
		{
			var oldValue: String = value;
			
			updateValue();
			
			valueChanged( oldValue );
		}
		
		protected function updateValue(): void
		{
			var argsBaked: Array = [ format ];
			
			var i: int = 0;
			var n: int = args.length;
			var argument:*;
			
			for (;i<n;++i)
			{
				argument = args[i];
				
				if ( argument is Parameter )
				{
					argsBaked.push( Parameter( argument ).getValue() );
				}
				else
				if ( argument is Formatter )
				{
					argsBaked.push( Formatter( argument ).getValue() );
				}
				else
				{
					argsBaked.push( argument );
				}
			}
			
			value = sprintf.apply( null, argsBaked );
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
		
		public function toString(): String
		{
			return '[Formatter format: ' + format + ', arguments: ' + args.toString() + ']';
		}
	}
}