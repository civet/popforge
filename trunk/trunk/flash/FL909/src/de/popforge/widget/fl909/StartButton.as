package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.start.button.ActiveDown;
	import de.popforge.assets.tr909.start.button.ActiveUp;
	import de.popforge.assets.tr909.start.button.NormalDown;
	import de.popforge.assets.tr909.start.button.NormalUp;
	import de.popforge.audio.processor.fl909.FL909;
	import de.popforge.parameter.Parameter;
	
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
		
		private var player: FL909Player;
		private var fl909: FL909;
		private var parameter: Parameter;
		
		public function StartButton( player: FL909Player )
		{
			this.player = player;
			
			fl909 = player.getFL909();
			
			parameter = fl909.pause;
			
			build();
		}

		private function build(): void
		{
			addChild( bitmap );
			
			alpha = .75;
			
			buttonMode = true;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			bitmap.bitmapData = parameter.getValue() ? normalDown : activeDown;
		}
		
		private function onMouseOver( event: MouseEvent ): void
		{
			if( event.buttonDown && stage.focus == this )
				bitmap.bitmapData = parameter.getValue() ? normalDown : activeDown;
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			if( stage.focus == this )
			{
				if( parameter.getValue() )
					fl909.reset();
				
				parameter.setValue( !parameter.getValue() );
				bitmap.bitmapData = parameter.getValue() ? normalUp : activeUp;
			}
		}
		
		private function onMouseOut( event: MouseEvent ): void
		{
			if( event.buttonDown )
				bitmap.bitmapData = parameter.getValue() ? normalUp : activeUp;
		}
	}
}