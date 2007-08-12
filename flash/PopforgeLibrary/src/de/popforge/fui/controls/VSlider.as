package de.popforge.fui.controls
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class VSlider extends Slider
	{
		override protected function build(): void
		{
			super.build();
			
			length = targetHeight;
						
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawRoundRect( 0, 0, tileSize, length, tileSize, tileSize );
			graphics.endFill();

			var knob: Sprite = new Sprite;
			
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
		}
		
		override protected function updateKnobPosition(): void
		{
			knob.y = knobOffsetY + ( 1 - parameter.getValueNormalized() ) * ( length - 2 * knobOffsetY );
		}
		
		override protected function onMouseDown( event: MouseEvent ): void
		{
			if( event.target == knob )
				dragOffset = knob.mouseY;
			else
				dragOffset = 0;

			super.onMouseDown( event );
		}
		
		override protected function onStageMouseMove( event: MouseEvent ): void
		{
			var ratio: Number = ( ( length - mouseY ) + dragOffset - knobOffsetY ) / ( length - 2 * knobOffsetY );
			
			if( ratio < 0 ) ratio = 0;
			else if( ratio > 1 ) ratio = 1;
			
			if ( parameter != null )
			{
				parameter.setValueNormalized( ratio );
			}
		}
		
		override public function toString(): String
		{
			return '[VSlider]';
		}
	}
}