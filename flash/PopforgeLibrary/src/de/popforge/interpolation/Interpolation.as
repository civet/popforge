package de.popforge.interpolation
{
	import flash.geom.Point;
	import de.popforge.parameter.IMapping;
	
	public class Interpolation
	{
		protected var mapping: IMapping;
		protected var points: Array;
		protected var n: uint;
		
		public function Interpolation( mapping: IMapping ): void
		{
			this.mapping = mapping;
			points = new Array;
		}
		
		public function addControlPoint( point: Point ): void
		{
			points.push( point );
			points.sortOn( 'x' );
			
			n = points.length;
		}
		
		public function removeControlPoint( point: Point ): void
		{
			var index: int = points.indexOf( point );
			
			if ( index != -1 )
			{
				points.splice( index, 1 );
				n = points.length;
			}
		}
		
		public function getValue( x: Number ): Number
		{
			return mapping.map( interpolate( x ) );
		}
		
		protected function interpolate( x: Number ): Number
		{
			return x;
		}
	}
}