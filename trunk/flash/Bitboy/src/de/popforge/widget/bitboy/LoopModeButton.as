package de.popforge.widget.bitboy
{
	import de.popforge.parameter.Parameter;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class LoopModeButton extends Sprite
	{
		private const linearButton: LinearButton = new LinearButton();
		private const loopButton: LoopButton = new LoopButton();
		
		private var parameter: Parameter;
		
		public function LoopModeButton( parameter: Parameter )
		{
			this.parameter = parameter;
			
			addChild( linearButton );
			
			addEventListener( MouseEvent.CLICK, onClick );
			
			parameter.addChangedCallbacks( onParameterChanged );
		}
		
		private function onClick( event: MouseEvent ): void
		{
			var button: ButtonBase = event.target as ButtonBase;
			
			if( button == linearButton )
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
				if( contains( linearButton ) )
					removeChild( linearButton );
				addChild( loopButton );
			}
			else
			{
				if( contains( loopButton ) )
					removeChild( loopButton );
				addChild( linearButton );
			}
		}
	}
}