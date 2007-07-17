package de.popforge.widget.bitboy
{
	import de.popforge.parameter.Parameter;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class VolumeSlider extends Sprite
	{
		private var parameter: Parameter;
		
		private var bar: BitmapData;
		private var value: Number;
		
		private var textfield: TextField;
		private var textformat: TextFormat;
		
		public function VolumeSlider( parameter: Parameter )
		{
			this.parameter = parameter;
			
			init();
		}
		
		private function init(): void
		{
			textformat = new TextFormat();
			textformat.font = BitboyPlayer.FONT_NAME;
			textformat.size = 8;
			textformat.color = 0x0000ff;
			
			textfield = new TextField();
			textfield.x = 52;
			textfield.y = -3;
			textfield.embedFonts = true;
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.selectable = false;
			textfield.defaultTextFormat = textformat;
			
			addChild( textfield );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			addChild( new Bitmap( bar = new BitmapData( 45, 5, true, 0xff0000ff ) ) );
			
			buttonMode = true;
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			updateValue( parameter.getValueNormalized() );
		}
		
		private function onMouseDown( event: MouseEvent ): void
		{
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			
			onMouseMove( null );
		}
		
		private function onMouseMove( event: MouseEvent ): void
		{
			var value: Number = mouseX / 45;
			
			if( value < 0 ) value = 0;
			else if( value > 1 ) value = 1;
			
			parameter.setValueNormalized( value );
		}
		
		private function onMouseUp( event: MouseEvent ): void
		{
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
		}
		
		private function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			updateValue( parameter.getValueNormalized() );
		}
		
		private function updateValue( value: Number ): void
		{
			var x: int = value * 45;
			
			bar.fillRect( bar.rect, 0 );
			bar.fillRect( new Rectangle( 0, 0, x, 5 ), 0xff0000ff );
			
			textfield.text = int( x / 45 * 100 ).toString();
			
			textfield.x = textfield.text == '100' ? 51 : 52;
		}		
	}
}