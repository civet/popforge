package
{
	import de.popforge.cubicvr.CubeVR;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Andre Michelle
	 */
	[SWF(backgroundColor="#000000", frameRate="31", width="800", height="500")]
	public final class DemoCubicVR extends Sprite
	{
		private const viewer: CubeVR = new CubeVR();

		public function DemoCubicVR()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, resize );
			stage.addEventListener( Event.ENTER_FRAME, enterFrame );
			stage.addEventListener( MouseEvent.MOUSE_WHEEL, mouseWheel );
	
			viewer.textures = textures;
			viewer.fieldOfView = 100.0;
			addChild( viewer );
			
			resize( null );
		}

		private function mouseWheel( event: MouseEvent ): void
		{
			viewer.fieldOfView -= event.delta;
		}

		private function enterFrame( event: Event ): void
		{
			viewer.yaw -= viewer.mouseX * 0.01;
			viewer.pitch += viewer.mouseY * 0.01;
			viewer.render();
		}

		private function resize( event: Event ): void
		{
			viewer.resizeTo( stage.stageWidth, stage.stageHeight );
			
			viewer.x = stage.stageWidth * 0.5;
			viewer.y = stage.stageHeight * 0.5;
		}

		/**
		 * CubicVR Textures
		 */
		[Embed(source="/../assets/miramar/miramar_rt.jpg", mimeType="image/jpg")]
			private static const X_NEGATIVE_CLASS: Class;
		[Embed(source="/../assets/miramar/miramar_lf.jpg", mimeType="image/jpg")]
			private static const X_POSITIVE_CLASS: Class;
		[Embed(source="/../assets/miramar/miramar_dn.jpg", mimeType="image/jpg")]
			private static const Y_NEGATIVE_CLASS: Class;
		[Embed(source="/../assets/miramar/miramar_up.jpg", mimeType="image/jpg")]
			private static const Y_POSITIVE_CLASS: Class;
		[Embed(source="/../assets/miramar/miramar_bk.jpg", mimeType="image/jpg")]
			private static const Z_NEGATIVE_CLASS: Class;
		[Embed(source="/../assets/miramar/miramar_ft.jpg", mimeType="image/jpg")]
			private static const Z_POSITIVE_CLASS: Class;
			
		private static const negativeX: BitmapData = Bitmap( new X_NEGATIVE_CLASS() ).bitmapData;
		private static const positiveX: BitmapData = Bitmap( new X_POSITIVE_CLASS() ).bitmapData;
		private static const negativeY: BitmapData = Bitmap( new Y_NEGATIVE_CLASS() ).bitmapData;
		private static const positiveY: BitmapData = Bitmap( new Y_POSITIVE_CLASS() ).bitmapData;
		private static const negativeZ: BitmapData = Bitmap( new Z_NEGATIVE_CLASS() ).bitmapData;
		private static const positiveZ: BitmapData = Bitmap( new Z_POSITIVE_CLASS() ).bitmapData;
		
		public static const textures: Vector.<BitmapData> = Vector.<BitmapData>
		([
			negativeX,
			positiveX,
			negativeY,
			positiveY,
			negativeZ,
			positiveZ
		]);
	}
}