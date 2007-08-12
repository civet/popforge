package de.popforge.fui
{
	import de.popforge.format.furnace.FurnaceFormat;
	import de.popforge.fui.core.FuiComponent;
	import de.popforge.fui.core.IFuiSkin
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import de.popforge.fui.core.IFuiParameter;
	import de.popforge.parameter.Parameter;
	import de.popforge.fui.controls.Slider;
	import de.popforge.fui.controls.Knob;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * The Fui class is able to read and parse special Furnace files that contain
	 * a skin plus configuration. Such a file is basically generated in an external
	 * editor.
	 * 
	 * The rendering of all components may not be done synchronous since there is an
	 * asynchronous call involved in this process. However the delay should be max one
	 * frame.
	 * 
	 * @author Joa Ebert
	 */	
	public class Fui extends Sprite
	{
		/**
		 * Builds and returns a <code>Fui</code> object.
		 * 
		 * @param furnaceFile A <code>ByteArray</code> object containing a Furnace file.
		 * @return A Fui object containing all components.
		 */		
		public static function build( furnaceFile: ByteArray ): Fui
		{
			var fui: Fui = new Fui;
			
			var assets: FurnaceFormat = new FurnaceFormat;
			assets.readExternal( furnaceFile );
			
			if ( assets.numFiles != 2 )
			{
				throw new Error( 'Invalid Furnace file.' );
			}
		
			fui.xml = XML( assets.fileByName( 'config' ) );
			fui.swf = assets.fileByName( 'factory' );
			
			fui.buildInternal();
			
			return fui;
		}
		
		public static function buildManual( xml: XML, skin: IFuiSkin ): Fui
		{
			var fui: Fui = new Fui;
			
			fui.xml = xml;
			fui.skin = skin;
			
			fui.buildInternal();
			fui.renderComponents();
			
			return fui;
		}
		
		private var xml: XML;
		private var swf: ByteArray;
		
		private var skin: IFuiSkin;
		
		private var components: Array;
		private var numComponents: uint;
		
		private var debugGraphics: Graphics;
		
		/**
		 * Creates a new Fui object.
		 * The constructor should never be called. Use <code>Fui.build()</code> instead.
		 */		
		public function Fui()
		{
			components = new Array;
		}
		
		/**
		 * Returns a component for the given name.
		 * 
		 * @param name The name of the component.
		 * @return The component corresponding to the given name
		 * @throws TypeError If no component with given name exists.
		 * 
		 */		
		public function getElementById( name: String ): FuiComponent
		{
			return FuiComponent( getChildByName( name ) );
		}
		
		public function connect( name: String, value: * ): void
		{
			var component: FuiComponent = getElementById( name );
			
			if ( component is IFuiParameter )
			{
				IFuiParameter( component ).connectParameter( Parameter( value ) );
			}
			/*else
			if ( component is Something else )
			{

			}*/
			else
			{
				throw new Error( 'Unknown FuiComponent type.' );
			}
		}
		
		/**
		 * Removes all references recursive. This way a Fui object should be
		 * collected by the GC if it is no longer needed.
		 */		
		public function dispose(): void
		{
			var i: int = 0;
			var n: int = numComponents;
			
			var component: FuiComponent;
			
			for (;i<n;++i)
			{
				component = components[ i ];
				
				component.dispose();
				
				removeChild( component );
				
				components[ i ] = null;
			}
			
			component = null;
			components[ i ] = null;
		}
		
		/**
		 * Initializes parsing of the config and loading of the assets.
		 */		
		private function buildInternal(): void
		{
			buildComponents();
			
			if ( swf != null )
			{
				var factoryLoader: Loader = new Loader();
			
				factoryLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onFactoryComplete );
				factoryLoader.loadBytes( swf, new LoaderContext( false, ApplicationDomain.currentDomain ) );
			}
		}
		
		/**
		 * Builds all components based on their entry in the config.
		 */		
		private function buildComponents(): void
		{
			var list: XMLList = xml.component;
			var params: XML;
			var component: FuiComponent;
			var clazz: Class;
			
			for each ( params in list )
			{
				switch ( String( params.@type ).toLowerCase() )
				{
					case 'slider':
						component = skin.createSlider();
						break;
					
					case 'knob':
						component = skin.createKnob();
						break;
						
					default:
						component = new FuiComponent;
				}
				
				component.x = uint( params.@x );
				component.y = uint( params.@y );
				
				component.name = String( params.@name );
				
				component.tag = params;
				
				addChild( component );
				components.push( component );
			}
			
			numComponents = components.length;
			
			var debugShape: Shape = new Shape;
			debugShape.name = '__FUI__DEBUG__SHAPE__';
			addChild( debugShape );
			
			debugGraphics = debugShape.graphics;
			
			// Free some memory here. We will never use the XML again.
			xml = null;
		}
		
		/**
		 * Renders all components.
		 */		
		private function renderComponents(): void
		{
			var i: int = 0;
			var n: int = numComponents;
			
			var component: FuiComponent;
			
			for (;i<n;++i)
			{
				component = components[ i ];
				
				component.x *= skin.tileSize; 
				component.y *= skin.tileSize;
				
				component.skin = skin;
			}
		}
		
		/**
		 * Draws the bounding box of every <code>DisplayObject</code> object and its registration point
		 * that belongs to the current <code>Fui</code> object.
		 */		
		public function debugComponents(): void
		{
			var i: int = 0;
			var n: int = numComponents;
			
			var component: FuiComponent;
			
			for (;i<n;++i)
			{
				component = components[ i ];
				debugInternal( component );
			}
		}
		
		private function debugInternal( displayObject: DisplayObject ): void
		{
			var rect: Rectangle = displayObject.getRect( this );
			var regPoint: Point = globalToLocal( displayObject.localToGlobal( new Point( 0, 0 ) ) );
			
			debugGraphics.lineStyle( 1, 0xff00ff );
			debugGraphics.drawRect( rect.x, rect.y, rect.width, rect.height );
			
			debugGraphics.lineStyle( 1, 0xff0000 );
			debugGraphics.moveTo( regPoint.x - 2, regPoint.y );
			debugGraphics.lineTo( regPoint.x + 3, regPoint.y );
			debugGraphics.moveTo( regPoint.x, regPoint.y - 2 );
			debugGraphics.lineTo( regPoint.x, regPoint.y + 3 );
			
			if ( displayObject is DisplayObjectContainer )
			{
				var container: DisplayObjectContainer = DisplayObjectContainer( displayObject );
				
				for ( var i: int = 0; i < container.numChildren; ++i )
				{
					debugInternal( container.getChildAt( i ) );
				}
			}
		}
		
		/**
		 * A listener for the completion of the asset factory.
		 * Once this listener gets executed the <code>Manifest</code> definition
		 * is pulled from the loaded SWF and a new object of a factory
		 * will be created using <code>Manifest.FACTORY_CLASS</code>.
		 * 
		 * @param event An <code>Event</code> object dispatched by the Adobe Flash Player.
		 */		
		private function onFactoryComplete( event: Event ): void
		{
			var factoryLoader: Loader = LoaderInfo( event.target ).loader;
			factoryLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onFactoryComplete );
			
			var manifest: Class = Class( factoryLoader.contentLoaderInfo.applicationDomain.getDefinition( 'Manifest' ) );

			skin = IFuiSkin( new manifest[ 'FACTORY_CLASS' ] );
			
			renderComponents();
			
			// Free some memory. We do not need that ByteArray again.
			swf = null;
		}
	}
}