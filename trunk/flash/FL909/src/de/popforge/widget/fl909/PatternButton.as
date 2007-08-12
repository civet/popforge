package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.button.TinyActive;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PatternButton extends Sprite
	{
		private const active: Bitmap = new Bitmap( new TinyActive(0,0) );
		
		private var gui: FL909GUI;
		private var index: int;
		private var value: Boolean;
		
		public function PatternButton( gui: FL909GUI, index: int )
		{
			this.gui = gui;
			this.index = index;
			
			build();
		}
		
		public function setValue( value: Boolean ): void
		{
			this.value = value;
			
			update();
		}
		
		public function getValue(): Boolean
		{
			return value;
		}
		
		public function getIndex(): int
		{
			return index;
		}
		
		private function build(): void
		{
			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0xffcc00 );
			hitArea.graphics.drawRect( 0, 0, 12, 12 );
			hitArea.graphics.endFill();
			hitArea.visible = false;
			addChild( hitArea );
			
			value = false;
			
			buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
		}
		
		private function onMouseOut( event: MouseEvent ): void
		{
			if( event.buttonDown && stage.focus == this )
			{
				gui.startCopyPattern( this );
			}
		}
		
		private function update(): void
		{
			if( value )
			{
				if( !contains( active ) )
					addChild( active );
			}
			else
			{
				if( contains( active ) )
					removeChild( active );
			}
		}
	}
}