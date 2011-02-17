package de.popforge.cubicvr
{
	import flash.geom.Matrix3D;
	/**
	 * @author Andre Michelle
	 */
	public final class Cube
	{
		private static const QUAD_UV: Vector.<Number> = Vector.<Number>( [ 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, 0.0 ] );
		private static const QUAD_UV_INDICES: Vector.<int> = Vector.<int>( [ 0, 1, 2, 3 ] );
		private static const SIZE_HALF: Number = 0.5;
		
		internal const sides: Vector.<Polygon> = new Vector.<Polygon>( 6, true );

		private const w_vertices: Vector.<Number> = new Vector.<Number>( 8 * 3, true );
		private const t_vertices: Vector.<Number> = new Vector.<Number>( 8 * 3, true );

		public function Cube()
		{
			init();
		}

		public function transform( matrix: Matrix3D ): void
		{
			matrix.transformVectors( w_vertices, t_vertices );
		}

		private function init(): void
		{
			// Vertices
			createVertex( 0, -SIZE_HALF, -SIZE_HALF,  SIZE_HALF );
			createVertex( 1,  SIZE_HALF, -SIZE_HALF,  SIZE_HALF );
			createVertex( 2,  SIZE_HALF,  SIZE_HALF,  SIZE_HALF );
			createVertex( 3, -SIZE_HALF,  SIZE_HALF,  SIZE_HALF );
			
			createVertex( 4,  SIZE_HALF, -SIZE_HALF, -SIZE_HALF );
			createVertex( 5, -SIZE_HALF, -SIZE_HALF, -SIZE_HALF );
			createVertex( 6, -SIZE_HALF,  SIZE_HALF, -SIZE_HALF );
			createVertex( 7,  SIZE_HALF,  SIZE_HALF, -SIZE_HALF );
			
			// Faces
			sides[0] = createCubeSide( 5, 0, 3, 6 ); // X-
			sides[1] = createCubeSide( 1, 4, 7, 2 ); // X+
			sides[3] = createCubeSide( 5, 4, 1, 0 ); // Y-
			sides[2] = createCubeSide( 3, 2, 7, 6 ); // Y+
			sides[4] = createCubeSide( 4, 5, 6, 7 ); // Z-
			sides[5] = createCubeSide( 0, 1, 2, 3 ); // Z+
		}
		
		private function createVertex( index: int, x: Number, y: Number, z: Number ): void
		{
			index *= 3;

			w_vertices[   index ] = x;
			w_vertices[ ++index ] = y;
			w_vertices[ ++index ] = z;
		}
		
		private function createCubeSide( v0: int, v1: int, v2: int, v3: int ): Polygon
		{
			const indices: Vector.<int> = new Vector.<int>( 4, true );
			
			indices[0] = v0;
			indices[1] = v1;
			indices[2] = v2;
			indices[3] = v3;
			
			return new Polygon( t_vertices, indices, QUAD_UV, QUAD_UV_INDICES );
		}
	}
}