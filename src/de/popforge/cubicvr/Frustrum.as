package de.popforge.cubicvr
{
	/**
	 * @author Andre Michelle
	 */
	public final class Frustrum
	{
		public const top: Plane = new Plane();
		public const left: Plane = new Plane();
		public const bottom: Plane = new Plane();
		public const right: Plane = new Plane();

		public function Frustrum() {}
		
		public function update( width: Number, height: Number, focalLength: Number ): void
		{
			var w2e: Number = ( width  * 0.5 ) / focalLength;
			var h2e: Number = ( height * 0.5 ) / focalLength;
			
			top.setVertices( 0.0, 0.0, 0.0, w2e, -h2e, 1.0, -w2e, -h2e, 1.0 );
			left.setVertices( 0.0, 0.0, 0.0, -w2e, -h2e, 1.0, -w2e, h2e, 1.0 );
			bottom.setVertices( 0.0, 0.0, 0.0, -w2e, h2e, 1.0, w2e, h2e, 1.0 );
			right.setVertices( 0.0, 0.0, 0.0, w2e, h2e, 1.0, w2e, -h2e, 1.0 );
		}
	}
}