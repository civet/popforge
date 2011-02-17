package de.popforge.widget.fl909
{
	import de.popforge.audio.processor.fl909.FL909;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import de.popforge.parameter.Parameter;
	import flash.utils.getTimer;

	public class LEDBar extends Sprite
	{
		private var fl909: FL909;
		
		private var leds: Array;
		private var startTimer: int;
		private var step: int;
		private var last: LED;
		
		public function LEDBar( fl909: FL909 )
		{
			this.fl909 = fl909;
			
			fl909.pause.addChangedCallbacks( onParameterChanged );
			
			build();
		}
		
		public function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			if( !parameter.getValue() )
			{
				addEventListener( Event.ENTER_FRAME, onEnterFrame );
				step = 0;
				startTimer = getTimer();
			}
			else
				removeEventListener( Event.ENTER_FRAME, onEnterFrame );
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
		}
		
		private function onEnterFrame( event: Event ): void
		{
			if( fl909.stepTimes.length == 0 ) return;
			
			var nextStepTime: int = fl909.stepTimes[0];
			
			if( getTimer() - startTimer > nextStepTime && fl909.stepTimes.length > 0 )
			{
				fl909.stepTimes.shift();
				
				if( last != null )
					last.setValue( false );
				
				( last = LED( leds[ step & 15 ] ) ).setValue( true );
				
				step++;
				
				nextStepTime = fl909.stepTimes[0];
			}
		}
	}
}