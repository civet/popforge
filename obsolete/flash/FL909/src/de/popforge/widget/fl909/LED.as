package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.led.Active;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;

	public class LED extends Sprite
	{
		private const active: BitmapData = new Active(0,0);
		
		private const bitmap: Bitmap = new Bitmap( null );
		
		internal var index: int;
		
		public function LED( index: int )
		{
			this.index = index;
			
			addChild( bitmap );
			
			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0 );
			hitArea.graphics.drawRect( -2, -2, active.width + 4, active.height + 4 );
			hitArea.graphics.endFill();
			hitArea.visible = false;
			addChild( hitArea );
			
			buttonMode = true;
		}
		
		public function setValue( value: Boolean ): void
		{
			bitmap.bitmapData = value ? active : null;
		}
	}	
}