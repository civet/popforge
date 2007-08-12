package de.popforge.widget.fl909
{
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Knob extends Sprite
	{
		private var large: Boolean;
		private var lastPosition: int;
		private var parameter: Parameter;
		
		public function Knob( parameter: Parameter, large: Boolean = false )
		{
			this.parameter = parameter;
			this.large = large;
			
			build();
		}
		
		public function getParameter(): Parameter
		{
			return parameter;
		}
		
		private function build(): void
		{
			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0xff0000 );
			hitArea.graphics.drawCircle( 0, 0, large ? 16 : 8 );
			hitArea.graphics.endFill();
			hitArea.visible = false;
			addChild( hitArea );
			
			cacheAsBitmap = true;
			
			update();
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.DOUBLE_CLICK, onDoubleClick );
			
			doubleClickEnabled = true;
			buttonMode = true;
		}
		
		private function onParameterChanged( param: Parameter, oldValue: *, newValue: * ): void
		{
			update();
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			lastPosition = mouseY;
		}
		
		private function onDoubleClick( event: MouseEvent ): void
		{
			parameter.reset();
			update();
		}
		
		private function onMouseMove( event: MouseEvent ): void
		{
			var value: Number = parameter.getValueNormalized();
			
			value -= ( mouseY - lastPosition ) / ( event.shiftKey ? 400 : 100 );
			
			if( value < 0 )
				value = 0;
			else if( value > 1 )
				value = 1;
			
			parameter.setValueNormalized( value );
			
			lastPosition = mouseY;
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.removeEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		private function update(): void
		{
			var angle: Number = ( Math.PI / 4 * 3 ) + parameter.getValueNormalized() * ( Math.PI / 4 * 6 );
			
			var cs: Number = Math.cos( angle );
			var sn: Number = Math.sin( angle );
			
			var r0: Number = large ? 11 : 4.5;
			var r1: Number = large ? 14 : 7.5;
			
			graphics.clear();
			graphics.lineStyle( 1, 0xBA8050 );
			graphics.moveTo( cs * r0, sn * r0 );
			graphics.lineTo( cs * r1, sn * r1 );
		}
	}
}