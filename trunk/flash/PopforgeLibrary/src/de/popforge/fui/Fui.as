package de.popforge.fui
{
	import de.popforge.format.furnace.FurnaceFormat;
	import de.popforge.fui.core.Component;
	import de.popforge.fui.core.IFuiFactory;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
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
			var fui: Fui = new Fui();
			
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
		
		private var xml: XML;
		private var swf: ByteArray;
		
		private var factory: IFuiFactory;
		
		private var components: Array;
		private var numComponents: uint;
		
		/**
		 * Creates a new Fui object.
		 * The constructor should never be called. Use <code>Fui.build()</code> instead.
		 */		
		public function Fui() {}
		
		/**
		 * Returns a component for the given name.
		 * 
		 * @param name The name of the component.
		 * @return The component corresponding to the given name
		 * @throws TypeError If no component with given name exists.
		 * 
		 */		
		public function getElementById( name: String ): Component
		{
			return Component( getChildByName( name ) );
		}
		
		/**
		 * Removes all references recursive. This way a Fui object should be
		 * collected by the GC if it is no longer needed.
		 */		
		public function dispose(): void
		{
			var i: int = 0;
			var n: int = numComponents;
			
			var component: Component;
			
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
			
			var factoryLoader: Loader = new Loader();
			
			factoryLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onFactoryComplete );
			factoryLoader.loadBytes( swf, new LoaderContext( false, ApplicationDomain.currentDomain ) );
		}
		
		/**
		 * Builds all components based on their entry in the config.
		 */		
		private function buildComponents(): void
		{
			var list: XMLList = xml.component;
			var params: XML;
			var component: Component;
			var clazz: Class;
			
			for each ( params in list )
			{
				switch ( String( params.@type ).toLowerCase() )
				{
					default:
						clazz = Component;
				}
				
				component = new clazz;
				
				component.x = uint( params.@x );
				component.y = uint( params.@y );
				
				component.name = String( params.@name );
				
				component.tag = params;
				
				addChild( component );
				components.push( component );
			}
			
			numComponents = components.length;
			
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
			
			var component: Component;
			
			for (;i<n;++i)
			{
				component = components[ i ];
				
				component.x *= factory.tileWidth; 
				component.y *= factory.tileHeight;
				
				component.factory = factory;
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

			factory = IFuiFactory( new manifest[ 'FACTORY_CLASS' ] );
			
			renderComponents();
			
			// Free some memory. We do not need that ByteArray again.
			swf = null;
		}
	}
}