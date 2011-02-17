package de.popforge.widget.bitboy
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	public class ButtonBase extends Sprite
	{
		private const bitmap: Bitmap = new Bitmap( normal );
		
		private var normal: BitmapData;
		private var over: BitmapData;
		
		public function ButtonBase( normal: BitmapData, over: BitmapData )
		{
			this.normal = normal;
			this.over = over;
			
			bitmap.bitmapData = normal;
			addChild( bitmap );
			
			buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
		}
		
		public function onRelease(): void
		{
		}
		
		private function onMouseOver( event: MouseEvent ): void
		{
			if( !event.buttonDown )
			{
				bitmap.bitmapData = over;
			}
		}
		
		private function onMouseOut( event: MouseEvent ): void
		{
			if( !event.buttonDown )
			{
				bitmap.bitmapData = normal;
			}
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			if( stage.focus == this )
				onRelease();
			else
				bitmap.bitmapData = over;

			stage.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		private function onStageMouseUp( event: MouseEvent ): void
		{
			bitmap.bitmapData = normal;
			
			Stage( event.currentTarget ).removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
	}
}