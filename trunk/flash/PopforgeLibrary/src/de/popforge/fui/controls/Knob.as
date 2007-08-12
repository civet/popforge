package de.popforge.fui.controls
{
	import de.popforge.parameter.Parameter;
	import de.popforge.fui.core.IFuiParameter;
	import de.popforge.fui.core.FuiComponent;
	import flash.events.MouseEvent;
	import flash.events.IEventDispatcher;
	import de.popforge.fui.core.FuiComponentSize;
	import flash.display.DisplayObject;
	import flash.display.Shape;

	public class Knob extends FuiComponent implements IFuiParameter
	{
		/* === COMPONENT SIZE === */
		private static const COMPONENT_SIZE: FuiComponentSize = new FuiComponentSize( 1, 1 );
		override public function get size(): FuiComponentSize { return COMPONENT_SIZE; }
		/* === COMPONENT SIZE === */
		
		protected var parameter: Parameter;
		
		protected var grip: DisplayObject;
		
		protected var mouseOrigin: Number;
		protected var valueOrigin: Number;
		
		public function connectParameter( parameter: Parameter ): void
		{
			releaseParameter();
			
			this.parameter = parameter;
			
			grip.rotation = valueToRotation( parameter.getValueNormalized() ); 
			 
			parameter.addChangedCallbacks( onParameterChanged );
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
		
		override protected function createChildren(): void
		{
			var cW: Number = _skin.tileSize * size.width;
			var cH: Number = _skin.tileSize * size.height;
			
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawEllipse( 0, 0, cW, cH );
			graphics.endFill();
			
			var grip: Shape = new Shape;
			
			grip.graphics.lineStyle( 3, 0x999999 );
			grip.graphics.moveTo( cW * .5 - 6, 0 );
			grip.graphics.lineTo( cW * .5 - 2, 0 );

			grip.x = cW * .5;
			grip.y = cH * .5;
			
			addChild( grip );
			
			this.grip = grip;
		}
	
		override protected function render():void
		{
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			createChildren();
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