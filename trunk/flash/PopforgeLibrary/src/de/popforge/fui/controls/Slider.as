package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IParameterBindable;
	import de.popforge.parameter.Parameter;
	
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class Slider extends FuiComponent implements IParameterBindable
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
			
			knob.x = knobOffsetX + parameter.getValueNormalized() * ( length - 2 * knobOffsetX );
			 
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
			knob.x = knobOffsetX + parameter.getValueNormalized() * ( length - 2 * knobOffsetX );
		}

		override protected function build():void
		{
			length = targetWidth;
			
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawRoundRect( 0, 0, length, tileSize, tileSize, tileSize );
			graphics.endFill();

			
			var knob: Sprite = new Sprite
			
			with ( knob.graphics )
			{
				lineStyle( 2, 0x333333 );
				beginFill( 0x999999 );
				drawCircle( 0, 0, tileSize * .5 );
				endFill();
			}
			
			addChild( knob );

			knobOffsetX = knob.x = tileSize * .5;
			knobOffsetY = knob.y = tileSize * .5;
			
			this.knob = knob;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		protected function onMouseDown( event: MouseEvent ): void
		{
			if( event.altKey )
			{
				parameter.reset();
				return;
			}
			
			if( event.target == knob )
				dragOffset = knob.mouseX;
			else
				dragOffset = 0;
			
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onStageMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
			
			onStageMouseMove( null );
		}
		
		protected function onStageMouseMove( event: MouseEvent ): void
		{
			var ratio: Number = ( mouseX - dragOffset - knobOffsetX ) / ( length - 2 * knobOffsetX );
			
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