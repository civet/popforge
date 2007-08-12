package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IParameterBindable;
	import de.popforge.parameter.Parameter;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	internal class Slider extends FuiComponent implements IParameterBindable
	{
		protected var parameter: Parameter;
		
		protected var knob: InteractiveObject;
		
		protected var knobOffsetX: Number;
		protected var knobOffsetY: Number;
		
		protected var length: Number;
		protected var dragOffset: Number;
		
		public function connect( parameter: Parameter ): void
		{
			releaseParameter();
			
			this.parameter = parameter;

			updateKnobPosition();
						 
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
			updateKnobPosition();
		}

		protected function updateKnobPosition(): void { /* OVERRIDE ME */ }
		
		override protected function build():void
		{	
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		protected function onMouseDown( event: MouseEvent ): void
		{
			if( event.altKey )
			{
				parameter.reset();
				return;
			}
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			onStageMouseMove( null );
		}
		
		protected function onStageMouseMove( event: MouseEvent ): void { /* OVERRIDE ME */ }
		
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
			
			removeChild( knob );
			
			knob = null;
			
			super.dispose();
		}

		override public function toString(): String
		{
			return '[Slider]';
		}
	}
}