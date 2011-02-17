package de.popforge.cubicvr
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * @author Andre Michelle
	 */
	public final class CubeVR extends Shape
	{
		private const cube: Cube = new Cube();
		private const matrix: Matrix3D = new Matrix3D();
		private const frustrum: Frustrum = new Frustrum();

		private var _yaw: Number;
		private var _pitch: Number;
		private var _width: Number;
		private var _height: Number;
		private var _fieldOfView: Number;
		private var _focalLength: Number;
		private var _textures: Vector.<BitmapData>;
		
		public function CubeVR()
		{
			opaqueBackground = 0;
			
			fieldOfView = 90.0;

			_yaw = 0.0;
			_pitch = 0.0;
		}
		
		public function resizeTo( width: Number, height: Number ): void
		{
			if( _width != width || _height != height )
			{
				_width = width;
				_height = height;
				
				updatePerspective();
			}
		}

		public function get fieldOfView(): Number
		{
			return _fieldOfView;
		}

		public function set fieldOfView( value: Number ): void
		{
			if( value > 179.0 )
				value = 179.0;
			else
			if( value < 45.0 )
				value = 45.0;
			
			if( _fieldOfView != value )
			{
				_fieldOfView = value;
				
				updatePerspective();
			}
		}

		public function get textures(): Vector.<BitmapData>
		{
			return _textures;
		}

		public function set textures( value: Vector.<BitmapData> ): void
		{
			if( _textures != value )
			{
				_textures = value;
			}
		}
		
		public function get yaw(): Number
		{
			return _yaw;
		}

		/**
		 * Sets the yaw of the cube view, zero is positive Z
		 */
		public function set yaw( value: Number ): void
		{
			if( value < -180.0 )
				value += 360.0;
			else
			if( value > 180.0 )
				value -= 360.0;

			if( _yaw != value )
			{
				_yaw = value;
			}
		}

		public function get pitch(): Number
		{
			return _pitch;
		}

		/**
		 * Sets the pitch of the cube view from -90 to +90 degress
		 */
		public function set pitch( value: Number ): void
		{
			if( value < -90.0 )
				value = -90.0;
			else
			if( value > 90.0 )
				value = 90.0;
							
			if( _pitch != value )
			{
				_pitch = value;
			}
		}
		
		public function render(): void
		{
			graphics.clear();

			matrix.identity();
			matrix.appendRotation( _yaw, Vector3D.Y_AXIS );
			matrix.appendRotation( _pitch, Vector3D.X_AXIS );

			cube.transform( matrix );

			const sides: Vector.<Polygon> = cube.sides;
			
			var numVertices: uint;

			for( var i: int = 0 ; i < 6 ; ++i )
			{
				const side: Polygon = sides[i];
				
				side.reset();
				
				numVertices = side.clip( frustrum.left );
				
				if( 3 > numVertices )
					continue;
				
				numVertices = side.clip( frustrum.right );
				
				if( 3 > numVertices )
					continue;
				
				numVertices = side.clip( frustrum.top );
				
				if( 3 > numVertices )
					continue;
				
				numVertices = side.clip( frustrum.bottom );
				
				if( 3 > numVertices )
					continue;
	
				side.project( _focalLength );
				side.draw( graphics, _textures[i] );
			}
		}
		
		private function updatePerspective(): void
		{
			_focalLength = ( _width * 0.5 ) / Math.tan( _fieldOfView / 360.0 * Math.PI );

			 frustrum.update( _width, _height, _focalLength );
		}
	}
}