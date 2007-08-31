package de.popforge.fui.controls
{
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IFormatterBindable;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import de.popforge.utils.Formatter;
	import de.popforge.utils.Formatter;

	public class Label extends FuiComponent implements IFormatterBindable
	{
		protected var textField: TextField;
		protected var formatter: Formatter;
		
		public function connect( formatter: Formatter ): void
		{
			releaseFormatter();
			
			this.formatter = formatter;
			
			textField.text = formatter.getValue();
			 
			formatter.addChangedCallbacks( onFormatterChanged );
		}
		
		public function disconnect(): void
		{
			releaseFormatter();
		}
		
		protected function releaseFormatter(): void
		{
			if ( formatter != null )
			{
				formatter.removeChangedCallbacks( onFormatterChanged );
			}
			
			formatter = null;
		}
		
		protected function onFormatterChanged( formatter: Formatter, oldValue: String, newValue: String ): void
		{
			textField.text = newValue;
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