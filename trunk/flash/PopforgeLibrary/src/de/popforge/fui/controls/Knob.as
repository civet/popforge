package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IParameterBindable;
	import de.popforge.parameter.Parameter;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class Knob extends FuiComponent implements IParameterBindable
	{
		protected var parameter: Parameter;
		
		protected var grip: DisplayObject;
		
		protected var mouseOrigin: Number;
		protected var valueOrigin: Number;
		
		public function connect( parameter: Parameter ): void
		{
			releaseParameter();
			
			this.parameter = parameter;
			
			grip.rotation = valueToRotation( parameter.getValueNormalized() ); 
			 
			parameter.addChangedCallbacks( onParameterChanged );
		}
		
		public function disconnect(): void
		{
			releaseParameter();
		}
		
		protected function releaseParameter(): void
		{
			if ( parameter != null )
			{
				parameter.removeChangedCallbacks( onParameterChanged );
			}
			
			parameter = null;
		}
		
		protected function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			grip.rotation = valueToRotation( parameter.getValueNormalized() );
		}
		
		protected function valueToRotation( normalizedValue: Number ): Number
		{
			return -225 + normalizedValue * 270;
		}
		
		override protected function build(): void
		{
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawEllipse( 0, 0, targetWidth, targetHeight );
			graphics.endFill();
			
			var grip: Shape = new Shape;
			
			grip.graphics.lineStyle( 3, 0x999999 );
			grip.graphics.moveTo( targetWidth * .5 - 6, 0 );
			grip.graphics.lineTo( targetHeight * .5 - 2, 0 );

			grip.x = targetWidth * .5;
			grip.y = targetHeight * .5;
			
			addChild( grip );
			
			this.grip = grip;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		protected function onMouseDown( event: MouseEvent ): void
		{
			if( event.altKey )
			{
				parameter.reset();
				return;
			}
			
			mouseOrigin = event.stageY;
			valueOrigin = parameter.getValueNormalized();
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			onStageMouseMove( event );
		}
		
		protected function onStageMouseMove( event: MouseEvent ): void
		{
			var ratio: Number = valueOrigin + ( mouseOrigin - event.stageY ) / ( event.shiftKey ? 1000 : 75 );
			
			if( ratio < 0 ) ratio = 0;
			else if( ratio > 1 ) ratio = 1;
			
			if ( parameter != null )
			{
				parameter.setValueNormalized( ratio );
			}
		}
		
		protected function onStageMouseUp( event: MouseEvent ): void
		{
			var dispatcher: IEventDispatcher = IEventDispatcher( event.currentTarget );
			
			dispatcher.removeEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			dispatcher.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		override public function dispose(): void
		{
			releaseParameter();
			
			removeEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			
			removeChild( grip );
			
			grip = null;
			
			super.dispose();
		}

		override public function toString(): String
		{
			return '[Knob]';
		}
	}
}