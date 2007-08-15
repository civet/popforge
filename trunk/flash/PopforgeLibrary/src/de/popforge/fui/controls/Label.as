package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IStringBindable;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Label extends FuiComponent implements IStringBindable
	{
		protected var textField: TextField;

		public function connect( string: String ): void
		{
			textField.text = string;
		}
		
		public function disconnect(): void
		{
			textField.text = '';
		}
		
		override protected function build(): void
		{
			graphics.beginFill( 0x555555 );
			graphics.drawRect( 0, 0, targetWidth, targetHeight );
			graphics.endFill();
			
			textField = new TextField();
			
			textField.selectable = false;
			textField.wordWrap = true;
			textField.multiline = true;
			
			textField.x = 4;
			textField.width = targetWidth - 8;
			textField.height = targetHeight;
			
			var align: String = String( _tag.@align );
			
			if ( align == null || align == '' )
				align = TextFormatAlign.CENTER;
				
			var format: TextFormat = new TextFormat( 'verdana', 9, 0x999999, true );
			format.align = align;
			
			textField.defaultTextFormat = format;

			addChild( textField );
					
			maskComponent();
		}
		
		override public function dispose(): void
		{
			super.dispose();
			
			if ( contains( textField ) )
				removeChild( textField );
			
			textField = null;
		}

		override public function toString(): String
		{
			return '[Label]';
		}
	}
}