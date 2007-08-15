package de.popforge.fui.controls
{
	import flash.display.Sprite;
	
	public class SwitchButton extends Button
	{
		override protected function build(): void
		{
			super.build();
			
			graphics.lineStyle( 2, 0x333333 );
			graphics.beginFill( 0x555555 );
			graphics.drawRoundRect( 0, 0, tileSize, tileSize, tileSize * .25, tileSize * .25 );
			graphics.endFill();

			var trigger: Sprite = new Sprite;
			
			addChild( trigger );
			
			this.trigger = trigger;
		}
		
		override protected function updateButtonGraphics(): void
		{
			with ( Sprite( trigger ).graphics )
			{
				clear();
				beginFill( ( parameter.getValueNormalized() == 1 ) ? 0xbbbbbb : 0x999999 );
				drawRoundRect( 4, 4, tileSize - 8, tileSize - 8, ( tileSize - 8 ) * .25, ( tileSize - 8 ) * .25 );
				endFill();
			}
		}
		
		override protected function mouseDown():void
		{
			invertParameter();
		}
		
		override public function toString(): String
		{
			return '[SwitchButton]';
		}
	}
}