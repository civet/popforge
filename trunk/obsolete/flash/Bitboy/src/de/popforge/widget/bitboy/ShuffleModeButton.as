package de.popforge.widget.bitboy
{
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ShuffleModeButton extends Sprite
	{
		private const normalButton: NormalButton = new NormalButton();
		private const shuffleButton: ShuffleButton = new ShuffleButton();
		
		private var parameter: Parameter;
		
		public function ShuffleModeButton( parameter: Parameter )
		{
			this.parameter = parameter;
			
			addChild( normalButton );
			
			addEventListener( MouseEvent.CLICK, onClick );
			
			parameter.addChangedCallbacks( onParameterChanged );
		}
		
		private function onClick( event: MouseEvent ): void
		{
			var button: ButtonBase = event.target as ButtonBase;
			
			if( button == normalButton )
			{
				parameter.setValue( true );
			}
			else
			{
				parameter.setValue( false );
			}
		}
		
		private function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			if( newValue )
			{
				if( contains( normalButton ) )
					removeChild( normalButton );
				addChild( shuffleButton );
			}
			else
			{
				if( contains( shuffleButton ) )
					removeChild( shuffleButton );
				addChild( normalButton );
			}
		}
	}
}