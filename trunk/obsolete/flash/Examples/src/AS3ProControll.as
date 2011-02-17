package
{
	import de.popforge.ui.procontroll.ProcontrollControl;
	
	import flash.display.Sprite;

	public class AS3ProControll extends Sprite
	{
		private var pcc: ProcontrollControl;
		
		public function AS3ProControll()
		{
			pcc = new ProcontrollControl( 'localhost', 10002 );
		}
	}
}