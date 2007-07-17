package de.popforge.widget.bitboy
{
	import de.popforge.bitboy.assets.ButtonMuteOff;
	import de.popforge.bitboy.assets.ButtonMuteOn;
	import de.popforge.parameter.MappingBoolean;
	import de.popforge.parameter.Parameter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class MuteButton extends Sprite
	{
		private const bOn: BitmapData = new ButtonMuteOn(0,0);
		private const bOff: BitmapData = new ButtonMuteOff(0,0);
		private const bitmap: Bitmap = new Bitmap( bOff );
		
		private var parameter: Parameter;
		
		public function MuteButton( parameter: Parameter )
		{
			this.parameter = parameter;
			
			addChild( bitmap );
			
			buttonMode = true;
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			addEventListener( MouseEvent.CLICK, onClick );
		}
		
		private function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			bitmap.bitmapData = newValue ? bOn : bOff;
		}
		
		private function onClick( event: MouseEvent ): void
		{
			parameter.setValue( !parameter.getValue() );
		}
	}
}