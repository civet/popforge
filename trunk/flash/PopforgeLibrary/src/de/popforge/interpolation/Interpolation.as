package de.popforge.interpolation
{
	import de.popforge.parameter.IMapping;
	
	import flash.geom.Point;
	import flash.net.registerClassAlias;
	
	/**
	 * The Interpolation class represents a interpolation between given control points.
	 * Control points work on a normalized range from <em>0</em> to <em>1</em>.
	 * 
	 * Depending on the given IMapping an Interpolation object
	 * can store different types of values.
	 * 
	 * @author Joa Ebert
	 */	
	public class Interpolation
	{
		{
			registerClassAlias( 'Interpolation', Interpolation );
		}
		
		private var mapping: IMapping;
		
		/**
		 * An array of control points.
		 * The control points are always sorted on their <em>x</em> value.
		 */		
		protected var points: Array;
		
		/**
		 * The number of control points.
		 */		
		protected var numPoints: uint;
		
		/**
		 * Creates a new Interpolation object.
		 * 
		 * @param mapping The IMapping object used to map the normalized value.
		 */		
		public function Interpolation( mapping: IMapping = null )
		{
			this.mapping = mapping;
			points = new Array;
		}
		
		/**
		 * Adds a control point.
		 * 
		 * @param point The control point to add.
		 */		
		public function addControlPoint( point: Point ): void
		{
			points.push( point );
			points.sortOn( 'x', Array.NUMERIC );
			
			numPoints = points.length;
		}
		
		/**
		 * Removes a control point by reference.
		 * This is not done by a value check.
		 * 
		 * @param point The control point to remove.
		 * 
		 */		
		public function removeControlPoint( point: Point ): void
		{
			var index: int = points.indexOf( point );
			
			if ( index != -1 )
			{
				points.splice( index, 1 );
				numPoints = points.length;
			}
		}
		
		/**
		 * Retrievs the interpolated value at position <em>x</em> and returns the mapped value.
		 * If no control points are added a default value of <em>0</em> is used as the interpolated value.
		 * 
		 * @param x A normalized value from <em>0</em> to <em>1</em>.
		 * @return The mapped value at interpolated position <em>x</em>.
		 * 
		 */		
		public function getValueAt( x: Number ):*
		{
			if ( numPoints == 0 )
				return mapping.map( 0 );
				
			return mapping.map( interpolate( x ) );
		}
		
		/**
		 * Searches for a point that is prior to <em>x</em>.
		 * 
		 * @param x The position on the <em>x</em>-axis to search for.
		 * @return The index of the point that has been found.
		 * 
		 */		
		protected function findPointBefore( x: Number ): uint
		{
			var p0: Point;
			var p1: Point;
			
			var p0x: Number;
			var p1x: Number;
			
			var index: uint = numPoints >> 1;
			
			while ( true )
			{
				p0 = points[ index ];
				p0x = p0.x;
				
				if ( int( index + 1 ) != numPoints )
				{
					p1 = points[ int( index + 1 ) ];
					p1x = p1.x;
				}
				else // Precheck: There is no next point. We reached the end but x is still greater than p0. So we found the last point before x.
					return index;
				
				if ( p0x == x )
				{ // x is on a point. Return point before x if possible.
					if ( index > 0 )
						return ( index - 1 );
					return 0;
				}
				else if ( ( p0x <= x ) && ( x <= p1x ) )
				{ // We have a perfect match (p0 <= x <= p1)
					return index;
				}
				else if ( p0x > x )
				{ // We have to walk backwards because p0 > x
					index--;
				}
				else if ( p0x < x && p1x < x )
				{ // We have to walk forwards because both p0 and p1 are < x
					index++;
				}
			}
			
			return 0;
		}
		
		/**
		 * Calculates the interpolated value <em>y</em> for <em>x</em> based on the control points.
		 * 
		 * This function has to be overriden.
		 * 
		 * @param x Normalized position on the <em>x</em>-axis.
		 * @return The <em>y</em> value at given position <em>x</em>.
		 * 
		 */		
		protected function interpolate( x: Number ): Number
		{
			return x;
		}
		
		public function toString(): String
		{
			return '[Interpolation]';
		}
	}
}