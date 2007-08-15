package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IParameterBindable;
	import de.popforge.parameter.Parameter;
	
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	internal class Button extends FuiComponent implements IParameterBindable
	{
		protected var parameter: Parameter;
		
		protected var trigger: InteractiveObject;
		
		public function connect( parameter: Parameter ): void
		{
			releaseParameter();
			
			this.parameter = parameter;

			updateButtonGraphics();
						 
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
			updateButtonGraphics();
		}
		
		protected function updateButtonGraphics(): void { /* OVERRIDE ME */ }
		protected function mouseDown(): void { /* OVERRIDE ME */ }
		protected function mouseUp(): void { /* OVERRIDE ME */ }

		protected function invertParameter(): void
		{
			if ( parameter.getValueNormalized() == 1 )
			{
				parameter.setValueNormalized( 0 );
			}
			else
			{
				parameter.setValueNormalized( 1 );
			}
		}
		override protected function build():void
		{	
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			if( event.altKey )
			{
				parameter.reset();
				return;
			}
			
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			mouseDown();
		}
		
		private function onStageMouseUp( event: MouseEvent ): void
		{
			var dispatcher: IEventDispatcher = IEventDispatcher( event.currentTarget );
			dispatcher.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			mouseUp();
		}
		
		override public function toString(): String
		{
			return '[Button]';
		}
	}
}