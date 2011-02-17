package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.step.button.AccentDown;
	import de.popforge.assets.tr909.step.button.AccentUp;
	import de.popforge.assets.tr909.step.button.MediumDown;
	import de.popforge.assets.tr909.step.button.MediumUp;
	import de.popforge.assets.tr909.step.button.NoneDown;
	import de.popforge.assets.tr909.step.button.NoneUp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class StepButton extends Sprite
	{
		private const noneUp: BitmapData = new NoneUp(0,0);
		private const noneDown: BitmapData = new NoneDown(0,0);
		private const mediumUp: BitmapData = new MediumUp(0,0);
		private const mediumDown: BitmapData = new MediumDown(0,0);
		private const accentUp: BitmapData = new AccentUp(0,0);
		private const accentDown: BitmapData = new AccentDown(0,0);
		
		private const bitmap: Bitmap = new Bitmap( noneUp );
		
		private var index: int;
		private var state: int;

		public function StepButton( index: int )
		{
			this.index = index;
			
			build();
		}
		
		public function getIndex(): int
		{
			return index;
		}
		
		public function setState( state: int ): void
		{
			switch( state )
			{
				case 0: bitmap.bitmapData = noneUp; break;
				case 1: bitmap.bitmapData = mediumUp; break;
				case 2: bitmap.bitmapData = accentUp; break;
			}
			
			this.state = state;
		}
		
		public function getState(): int
		{
			return state;
		}
		
		private function build(): void
		{
			addChild( bitmap );
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			addEventListener( MouseEvent.MOUSE_OUT, onMouseOut );
			addEventListener( MouseEvent.MOUSE_OVER, onMouseOver );
			
			buttonMode = true;
			
			state = 0;	
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			switch( state )
			{
				case 0: bitmap.bitmapData = noneDown; break;
				case 1: bitmap.bitmapData = mediumDown; break;
				case 2: bitmap.bitmapData = accentDown; break;
			}
		}
		
		private function onMouseOut( event: MouseEvent ): void
		{
			switch( state )
			{
				case 0: bitmap.bitmapData = noneUp; break;
				case 1: bitmap.bitmapData = mediumUp; break;
				case 2: bitmap.bitmapData = accentUp; break;
			}
		}
		
		private function onMouseOver( event: MouseEvent ): void
		{
			if( !event.buttonDown || !( stage.focus is StepButton ) ) return;
			
			switch( state )
			{
				case 0: bitmap.bitmapData = noneDown; break;
				case 1: bitmap.bitmapData = mediumDown; break;
				case 2: bitmap.bitmapData = accentDown; break;
			}
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			if( !( stage.focus is StepButton ) ) return;
			switch( state )
			{
				case 0:
				
					if( event.shiftKey )
					{
						bitmap.bitmapData = accentUp;
						state = 2;
					}
					else
					{
						bitmap.bitmapData = mediumUp;
						state = 1;
					}
					break;

				case 1:
				
					if( event.shiftKey )
					{
						bitmap.bitmapData = accentUp;
						state = 2;
					}
					else
					{
						bitmap.bitmapData = noneUp;
						state = 0;
					}
					break;

				case 2:
				
					if( event.shiftKey )
					{
						bitmap.bitmapData = noneUp;
						state = 0;
					}
					else
					{
						bitmap.bitmapData = mediumUp;
						state = 1;
					}
					break;
			}
		}
	}
}












