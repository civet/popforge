package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.lcd.Digit;
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;

	public class LCD extends Sprite
	{
		private var parameter: Parameter;
		
		private const digit0: Digit = new Digit();
		private const digit1: Digit = new Digit();
		private const digit2: Digit = new Digit();
		
		public function LCD( parameter: Parameter )
		{
			this.parameter = parameter;
			
			build();
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			update();
		}
		
		private function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			update();
		}
		
		public function update(): void
		{
			var value: int = parameter.getValue();
			
			var d0: int = int( value / 10 ) * 10;
			var d1: int = value / 100;
			
			digit2.gotoAndStop( value - d0 + 1 );
			digit1.gotoAndStop( ( d0 - d1 * 100 ) / 10 + 1 );
			digit0.gotoAndStop( d1 + 1 );
		}
		
		private function build(): void
		{
			digit0.x = 0;
			addChild( digit0 );
			digit1.x = 13;
			addChild( digit1 );
			digit2.x = 26;
			addChild( digit2 );
		}
	}
}