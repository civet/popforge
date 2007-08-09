package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.start.button.ActiveDown;
	import de.popforge.assets.tr909.start.button.ActiveUp;
	import de.popforge.assets.tr909.start.button.NormalDown;
	import de.popforge.assets.tr909.start.button.NormalUp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class StartButton extends Sprite
	{
		private const normalUp: BitmapData = new NormalUp(0,0);
		private const normalDown: BitmapData = new NormalDown(0,0);
		private const activeUp: BitmapData = new ActiveUp(0,0);
		private const activeDown: BitmapData = new ActiveDown(0,0);
		
		private const bitmap: Bitmap = new Bitmap( normalUp );
		
		private var value: Boolean;
		
		public function StartButton()
		{
			build();
		}
		
		public function getValue(): Boolean
		{
			return value;
		}
		
		private function build(): void
		{
			addChild( bitmap );
			
			alpha = .75;
			
			value = false;
			
			buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			bitmap.bitmapData = value ? activeDown : normalDown;
		}
		
		private function onMouseOver( event: MouseEvent ): void
		{
			if( event.buttonDown && stage.focus == this )
				bitmap.bitmapData = value ? activeDown : normalDown;
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			if( stage.focus == this )
			{
				value = !value;
				bitmap.bitmapData = value ? activeUp : normalUp;
			}
		}
		
		private function onMouseOut( event: MouseEvent ): void
		{
			if( event.buttonDown )
				bitmap.bitmapData = value ? activeUp : normalUp;
		}
	}
}