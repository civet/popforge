package
{
	import de.popforge.ui.KeyboardShortcut;
	import de.popforge.widget.bitboy.BitboyPlayer;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	
	[SWF( backgroundColor='0xffffff', frameRate='30', width='150', height='57')]
	
	public class BitboyApp extends Sprite
	{
		private var player: BitboyPlayer;
		
		public function BitboyApp()
		{
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			KeyboardShortcut.createInstance( stage );
			
			player = new BitboyPlayer();
			addChild( player );
		}
	}
}
