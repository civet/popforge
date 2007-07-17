package de.popforge.widget.bitboy
{
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class PlayPauseButton extends Sprite
	{
		private const playButton: PlayButton = new PlayButton();
		private const pauseButton: PauseButton = new PauseButton();
		
		private var parameter: Parameter;
		
		public function PlayPauseButton( parameter: Parameter )
		{
			this.parameter = parameter;
			
			addChild( pauseButton );
			
			addEventListener( MouseEvent.CLICK, onClick );
			
			parameter.addChangedCallbacks( onParameterChanged );
		}
		
		private function onClick( event: MouseEvent ): void
		{
			var button: ButtonBase = event.target as ButtonBase;
			
			if( button == pauseButton )
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
				if( contains( pauseButton ) )
					removeChild( pauseButton );
				addChild( playButton );
			}
			else
			{
				if( contains( playButton ) )
					removeChild( playButton );
				addChild( pauseButton );
			}
		}
	}
}