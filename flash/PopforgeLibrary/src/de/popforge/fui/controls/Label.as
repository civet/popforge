package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Label extends FuiComponent
	{
		protected var textField: TextField;

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
			
			textField.text = 'Test';
					
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