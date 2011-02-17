package de.popforge.cubicvr
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.TriangleCulling;
	/**
	 * @author Andre Michelle
	 */
	internal final class Polygon
	{
		private static const MAX_VERTICES: int = 8;

		private static const TRIANGLE_INDICES: Vector.<int> = new Vector.<int>( 3, true );
		private static const BUFFER_VERTICES: Vector.<Number> = new Vector.<Number>( MAX_VERTICES * 3, true );
		private static const BUFFER_UVT: Vector.<Number> = new Vector.<Number>( MAX_VERTICES * 3, true );

		//-- CLIPPED DATA
		private const clippedVerts: Vector.<Number> = new Vector.<Number>( MAX_VERTICES * 3, true );
		private const projectedVerts: Vector.<Number> = new Vector.<Number>( MAX_VERTICES * 2, true );
		private const clippedUVT: Vector.<Number> = new Vector.<Number>( MAX_VERTICES * 3 );
		
		//-- ORIGINAL DATA
		private var _vertices: Vector.<Number>;
		private var _vertIndices: Vector.<int>;
		private var _uv: Vector.<Number>;
		private var _uvIndices: Vector.<int>;
		private var _numVertices: int;

		public function Polygon( vertices: Vector.<Number>, vertIndices: Vector.<int>, uv: Vector.<Number>, uvIndices: Vector.<int> )
		{
			_vertices = vertices;
			_vertIndices = vertIndices;

			_uv = uv;
			_uvIndices = uvIndices;
		}

		public function project( focalLength: Number ): void
		{
			for( var i: int = 0 ; i < _numVertices ; ++i )
			{
				var i2: int = i << 1;
				var i3: int = i * 3;

				var px: Number = clippedVerts[  i3];
				var py: Number = clippedVerts[++i3];
				var tz: Number = focalLength / clippedVerts[++i3];
				
				projectedVerts[   i2 ] = px * tz;
				projectedVerts[ ++i2 ] = py * tz;

				clippedUVT[ i3 ] = tz;
			}
		}

		public function draw( graphics: Graphics, texture: BitmapData ): void
		{
			if( 2 < _numVertices )
			{
				if( null == texture )
					drawOutline( graphics );
				else
					drawTexture( graphics, texture );
			}
		}

		public function reset(): void
		{
			_numVertices = _vertIndices.length;
			
			for( var i: int = 0 ; i < _numVertices ; ++i )
			{
				var i3: int = i * 3;
				var v3: int = _vertIndices[i] * 3;
				var u3: int =   _uvIndices[i] * 3;

				clippedVerts[   i3 ] = _vertices[   v3 ];
				  clippedUVT[   i3 ] =       _uv[   u3 ];
				clippedVerts[ ++i3 ] = _vertices[ ++v3 ];
				  clippedUVT[   i3 ] =       _uv[ ++u3 ];
				clippedVerts[ ++i3 ] = _vertices[ ++v3 ];
				  clippedUVT[   i3 ] = 0.0;
			}
		}
		
		public function clip( plane: Plane ): uint
		{
			const a: Number = plane.a;
			const b: Number = plane.b;
			const c: Number = plane.c;
			const d: Number = plane.d;

			var d0: Number;
			var d1: Number;
			var dm: Number;
			
			var i0: int = _numVertices - 1;
			var j0: int = i0 * 3;

			var i1: int;
			var j1: int;
			var i3: int;
			
			var vx0: Number = clippedVerts[   j0 ];
			var tu0: Number =   clippedUVT[   j0 ];
			var vy0: Number = clippedVerts[ ++j0 ];
			var tv0: Number =   clippedUVT[   j0 ];
			var vz0: Number = clippedVerts[ ++j0 ];
			
			var vx1: Number;
			var vy1: Number;
			var vz1: Number;
			var tu1: Number;
			var tv1: Number;
			
			var index: int = 0;
			
			for( i1 = 0 ; i1 < _numVertices ; ++i1 )
			{
				j1 = i1 * 3;

				vx1 = clippedVerts[   j1 ];
				tu1 =   clippedUVT[   j1 ];
				vy1 = clippedVerts[ ++j1 ];
				tv1 =   clippedUVT[   j1 ];
				vz1 = clippedVerts[ ++j1 ];
				
				d0 = a * vx0 + b * vy0 + c * vz0 - d;
				d1 = a * vx1 + b * vy1 + c * vz1 - d;
				
				if( d0 <= 0.0 || d1 <= 0.0 )
				{
					if( d1 > 0.0 )
					{
						dm = d1 / ( d1 - d0 );
						
						i3 = index++ * 3;
						
						BUFFER_VERTICES[   i3 ] = vx1 + ( vx0 - vx1 ) * dm;
						     BUFFER_UVT[   i3 ] = tu1 + ( tu0 - tu1 ) * dm;
						BUFFER_VERTICES[ ++i3 ] = vy1 + ( vy0 - vy1 ) * dm;
						     BUFFER_UVT[   i3 ] = tv1 + ( tv0 - tv1 ) * dm;
						BUFFER_VERTICES[ ++i3 ] = vz1 + ( vz0 - vz1 ) * dm;
					}
					else
					if( d0 > 0.0 )
					{
						dm = d1 / ( d1 - d0 );
						
						i3 = index++ * 3;
						
						BUFFER_VERTICES[   i3 ] = vx1 + ( vx0 - vx1 ) * dm;
						     BUFFER_UVT[   i3 ] = tu1 + ( tu0 - tu1 ) * dm;
						BUFFER_VERTICES[ ++i3 ] = vy1 + ( vy0 - vy1 ) * dm;
						     BUFFER_UVT[   i3 ] = tv1 + ( tv0 - tv1 ) * dm;
						BUFFER_VERTICES[ ++i3 ] = vz1 + ( vz0 - vz1 ) * dm;
						
						i3 = index++ * 3;
						
						BUFFER_VERTICES[   i3 ] = vx1;
						     BUFFER_UVT[   i3 ] = tu1;
						BUFFER_VERTICES[ ++i3 ] = vy1;
						     BUFFER_UVT[   i3 ] = tv1;
						BUFFER_VERTICES[ ++i3 ] = vz1;
					}
					else
					{
						i3 = index++ * 3;
						
						BUFFER_VERTICES[   i3 ] = vx1;
						     BUFFER_UVT[   i3 ] = tu1;
						BUFFER_VERTICES[ ++i3 ] = vy1;
						     BUFFER_UVT[   i3 ] = tv1;
						BUFFER_VERTICES[ ++i3 ] = vz1;
					}
				}
				
				i0 = i1;

				vx0 = vx1;
				vy0 = vy1;
				vz0 = vz1;
				
				tu0 = tu1;
				tv0 = tv1;
			}
			
			for( i0 = 0 ; i0 < index ; ++i0 )
			{
				i3 = i0 * 3;

				clippedVerts[   i3 ] = BUFFER_VERTICES[ i3 ];
				  clippedUVT[   i3 ] = BUFFER_UVT[ i3 ];
				clippedVerts[ ++i3 ] = BUFFER_VERTICES[ i3 ];
				  clippedUVT[   i3 ] = BUFFER_UVT[ i3 ];
				clippedVerts[ ++i3 ] = BUFFER_VERTICES[ i3 ];
			}
			
			return _numVertices = index;
		}
		
		private function drawOutline( graphics: Graphics ): void
		{
			var x0: Number = projectedVerts[ 0 ];
			var y0: Number = projectedVerts[ 1 ];
			
			graphics.lineStyle( 0.0, 0xFFFFFF );
			graphics.moveTo( x0, y0 );

			for( var i: int = 1 ; i < _numVertices ; ++i )
			{
				const i2: int = i << 1;

				graphics.lineTo( projectedVerts[ i2 ], projectedVerts[ ++i2 ] );
			}

			graphics.lineTo( x0, y0 );
			graphics.lineStyle( undefined );
		}

		private function drawTexture( graphics: Graphics, texture: BitmapData ): void
		{
			var index: int = _numVertices - 1;

			while( index > 1 )
			{
				TRIANGLE_INDICES[0] = index;
				TRIANGLE_INDICES[1] = --index;
				TRIANGLE_INDICES[2] = 0;

				graphics.beginBitmapFill( texture, null, false, true );
				graphics.drawTriangles( projectedVerts, TRIANGLE_INDICES, clippedUVT, TriangleCulling.POSITIVE );
				graphics.endFill();
			}
		}
	}
}