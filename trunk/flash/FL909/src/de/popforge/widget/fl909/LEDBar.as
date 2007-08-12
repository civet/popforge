package de.popforge.widget.fl909
{
	import de.popforge.audio.processor.fl909.memory.Memory;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LEDBar extends Sprite
	{
		private var memory: Memory;
		
		private var leds: Array;
		
		public function LEDBar( memory: Memory )
		{
			this.memory = memory;
			
			build();
		}
		
		public function update(): void
		{
			var led: LED;
			
			var currentLength: int = memory.getPatternRun().length;
			
			for( var i: int = 0 ; i < 16 ; i++ )
			{
				led = leds[i];

				if( led.index == currentLength - 1 )
					led.setValue( true );
				else
					led.setValue( false );
			}
		}

		private function build(): void
		{
			leds = new Array();
			
			var led: LED;
			
			for( var i: int = 0 ; i < 16 ; i++ )
			{
				led = new LED( i );
				led.x = 112 + i * 27;
				led.y = 231;
				addChild( led );
				
				leds.push( led );
			}
			
			update();
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			var led: LED = event.target as LED;
			
			memory.getPatternRun().length = led.index + 1;
			
			trace( memory.getPatternRun().length );
			
			update();
		}
	}
}