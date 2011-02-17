package de.popforge.widget.fl909
{
	import de.popforge.assets.tr909.mute.button.Active;
	import de.popforge.parameter.Parameter;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MuteButton extends Sprite
	{
		private const active: Bitmap = new Bitmap( new Active(0,0) );
		
		private var parameter: Parameter;
		
		public function MuteButton( parameter: Parameter )
		{
			this.parameter = parameter;
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			build();
			update();
		}
		
		private function build(): void
		{
			hitArea = new Sprite();
			hitArea.graphics.beginFill( 0xffcc00 );
			hitArea.graphics.drawRect( 0, 0, 12, 12 );
			hitArea.graphics.endFill();
			hitArea.visible = false;
			addChild( hitArea );
			
			buttonMode = true;
			
			addEventListener( MouseEvent.CLICK, onClick );
		}
		
		private function onClick( event: MouseEvent ): void
		{
			parameter.setValue( !parameter.getValue() );
		}
		
		private function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			update();
		}
		
		private function update(): void
		{
			if( parameter.getValue() )
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