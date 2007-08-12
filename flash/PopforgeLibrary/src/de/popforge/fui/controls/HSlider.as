package de.popforge.fui.controls
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	
	public class HSlider extends Slider
	{
		override protected function build(): void
		{
			super.build();
			
			length = targetWidth;
						
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawRoundRect( 0, 0, length, tileSize, tileSize, tileSize );
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
			knob.x = knobOffsetX + parameter.getValueNormalized() * ( length - 2 * knobOffsetX );
		}
		
		override protected function onMouseDown( event: MouseEvent ): void
		{
			if( event.target == knob )
				dragOffset = knob.mouseX;
			else
				dragOffset = 0;

			super.onMouseDown( event );
		}
		
		override protected function onStageMouseMove( event: MouseEvent ): void
		{
			var ratio: Number = ( mouseX - dragOffset - knobOffsetX ) / ( length - 2 * knobOffsetX );
			
			if( ratio < 0 ) ratio = 0;
			else if( ratio > 1 ) ratio = 1;
			
			if ( parameter != null )
			{
				parameter.setValueNormalized( ratio );
			}
		}
		
		override public function toString(): String
		{
			return '[HSlider]';
		}
	}
}