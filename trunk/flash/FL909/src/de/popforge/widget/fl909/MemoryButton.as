package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.button.TinyActive;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MemoryButton extends Sprite
	{
		private const active: BitmapData = new TinyActive(0,0);
		
		private const bitmap: Bitmap = new Bitmap( active );
		
		public function MemoryButton()
		{
			build();
		}
		
		private function build(): void
		{
			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0xffcc00 );
			hitArea.graphics.drawRect( 0, 0, 10, 10 );
			hitArea.graphics.endFill();
			hitArea.visible = false;
			addChild( hitArea );
			
			buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			addChild( bitmap );
			
			stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		private function onStageMouseUp( event: MouseEvent ): void
		{
			removeChild( bitmap );
			
			stage.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
	}
}