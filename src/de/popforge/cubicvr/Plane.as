package de.popforge.cubicvr
{
	/**
	 * @author Andre Michelle
	 */
	public final class Plane
	{
		internal var a: Number;
		internal var b: Number;
		internal var c: Number;
		internal var d: Number;
		
		public function Plane() {}
		
		public function setVertices
		(
			x0: Number, y0: Number, z0: Number,
			x1: Number, y1: Number, z1: Number,
			x2: Number, y2: Number, z2: Number
		): void
		{
			const dx1: Number = x1 - x0;
			const dy1: Number = y1 - y0;
			const dz1: Number = z1 - z0;
			
			const dx2: Number = x2 - x0;
			const dy2: Number = y2 - y0;
			const dz2: Number = z2 - z0;

			a = dy1 * dz2 - dy2 * dz1;
			b = dz1 * dx2 - dz2 * dx1;
			c = dx1 * dy2 - dx2 * dy1;
			
			const coefInv: Number = 1.0 / Math.sqrt( a * a + b * b + c * c );
			
			d = a * coefInv * x1 + b * coefInv * y1 + c * coefInv * z1;
		}
		
		public function toString(): String
		{
			return '[Plane a: ' + a + ', b: ' + b + ', c: ' + c + ', d: ' + d + ']';
		}
	}
}
