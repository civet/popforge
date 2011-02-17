package de.popforge.widget.fl909
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.display.BlendMode;

	public class VoiceSwitchBar extends Sprite
	{
		private var onVoiceSwitched: Function;
		
		private var index: int;
		private var marker: Shape;
		
		public function VoiceSwitchBar( onVoiceSwitched: Function )
		{
			this.onVoiceSwitched = onVoiceSwitched;
			
			build();
		}
		
		public function getIndex(): int
		{
			return index;
		}
		
		private function build(): void
		{
			createHitButton( 101, 68, 53, 9 );
			createHitButton( 155, 68, 53, 9 );
			createHitButton( 209, 68, 53, 9 );
			createHitButton( 263, 68, 53, 9 );
			createHitButton( 317, 68, 53, 9 );
			createHitButton( 371, 68, 26, 9 );
			createHitButton( 398, 68, 26, 9 );
			createHitButton( 425, 68, 26, 9 );
			createHitButton( 452, 68, 26, 9 );
			createHitButton( 479, 68, 26, 9 );
			createHitButton( 506, 68, 26, 9 );
			
			marker = new Shape();
			marker.blendMode = BlendMode.MULTIPLY;
			addChild( marker );
			
			buttonMode = true;
			
			index = 0;
			
			positionMaker( index );
			
			addEventListener( MouseEvent.CLICK, onMouseClick );
		}
		
		private function onMouseClick( event: MouseEvent ): void
		{
			var sprite: Sprite = event.target as Sprite;
			
			if( sprite is VoiceSwitchBar ) return;
			
			var newIndex: int = getChildIndex( sprite );
			
			if( newIndex != index )
			{
				index = newIndex;
				
				positionMaker( index );
				
				onVoiceSwitched();
			}
		}
		
		private function positionMaker( index: int ): void
		{
			var sprite: Sprite = Sprite( getChildAt( index ) );
			
			marker.x = sprite.x + ( ( sprite.width - 6 ) >> 1 );
			marker.y = sprite.y - 3;
			
			marker.graphics.clear();
			marker.graphics.beginFill( 0xCE6920 );
			marker.graphics.drawRect( 0, 0, 6, 2 );
			marker.graphics.endFill();
		}
		
		private function createHitButton( x: int, y: int, width: int, height: int ): void
		{
			var button: Sprite = new Sprite();
			button.x = x;
			button.y = y;
			button.hitArea = new Sprite();
			button.hitArea.graphics.beginFill( 0xff0000 );
			button.hitArea.graphics.drawRect( 0, 0, width, height );
			button.hitArea.graphics.endFill();
			button.hitArea.visible = false;
			button.addChild( button.hitArea );
			addChild( button );
		}
	}
}