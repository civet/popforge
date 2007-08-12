package de.popforge.widget.fl909
{
	import de.popforge.audio.processor.fl909.memory.Memory;
	
	import flash.events.MouseEvent;
	
	public class CopyPatternHandler
	{
		private var source: PatternButton;
		private var memory: Memory;
		private var gui: FL909GUI;
		
		public function CopyPatternHandler( source: PatternButton, memory: Memory, gui: FL909GUI )
		{
			this.source = source;
			this.memory = memory;
			this.gui = gui;
			
			init();
		}
		
		private function init(): void
		{
			source.stage.addEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
		
		private function onStageMouseUp( event: MouseEvent ): void
		{
			var target: PatternButton = event.target as PatternButton;
			
			if( target != null )
			{
				if( source.getIndex() == target.getIndex() )
					return;
				
				memory.copyPattern( source.getIndex(), target.getIndex() );
				memory.changePatternByIndex( target.getIndex() );
				
				source.setValue( false );
				target.setValue( true );
				
				gui.lastPatternButton.setValue( false );
				gui.lastPatternButton = target;
			}
			
			source.stage.removeEventListener( MouseEvent.MOUSE_UP, onStageMouseUp );
		}
	}
}