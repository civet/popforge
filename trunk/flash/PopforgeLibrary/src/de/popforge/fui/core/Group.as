/**
 * Copyright(C) 2007 Andre Michelle and Joa Ebert
 *
 * PopForge is an ActionScript3 code sandbox developed by Andre Michelle and Joa Ebert
 * http://sandbox.popforge.de
 * 
 * This file is part of PopforgeAS3Audio.
 * 
 * PopforgeAS3Audio is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * PopforgeAS3Audio is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 */
package de.popforge.fui.core
{
	import de.popforge.fui.Fui;
	import de.popforge.parameter.MappingBoolean;
	import de.popforge.parameter.Parameter;
	
	public class Group implements IParameterBindable
	{
		protected var fui: Fui;
		protected var parameter: Parameter;
		
		protected var components: Array;
		protected var parameters: Array;
		protected var values: Array;
		protected var internalChange: Boolean;
		
		public function Group( fui: Fui )
		{
			this.fui = fui;
			
			components = new Array;
			parameters = new Array;
			values = new Array;
		}
		
		public function addComponent( name: String, value: * ): Boolean
		{
			var component: FuiComponent = fui.getElementById( name );
			var parameter: Parameter = new Parameter( new MappingBoolean, false );
			
			if ( components.indexOf( component ) != -1 )
			{
				return false;
			}
			
			if (!( component is IParameterBindable ))
			{
				throw new Error( 'Groups may only contain objects that implement IParameterBindable.' );
			}
			
			parameter.addChangedCallbacks( onGroupParameterChanged );
			
			components.push( component );
			parameters.push( parameter );
			values.push( value );
			
			IParameterBindable( component ).connect( parameter );
			
			if ( this.parameter != null )
			{
				{ internalChange = true;
					parameter.setValue( value == this.parameter.getValue() );
				internalChange = false; }
			}
			
			return true;
		}
		
		public function removeComponent( name: String ): Boolean
		{
			var component: FuiComponent = fui.getElementById( name );
			var index: int = components.indexOf( component );
			
			if ( index == -1 )
				return false;
			
			var parameter: Parameter = parameters[ index ];
			
			parameter.removeChangedCallbacks( onGroupParameterChanged );
			
			IParameterBindable( component ).disconnect();
			
			components.splice( index, 1 );
			parameters.splice( index, 1 );
			values.splice( index, 1 );
			
			return true;
		}
		
		public function connect( parameter: Parameter ): void
		{
			releaseParameter();
			
			this.parameter = parameter;
			
			parameter.addChangedCallbacks( onParameterChanged );
			
			initGroup();
		}
		
		public function disconnect(): void
		{
			releaseParameter();
		}
		
		protected function releaseParameter(): void
		{
			if ( parameter != null )
			{
				parameter.removeChangedCallbacks( onParameterChanged );
			}
			
			parameter = null;
		}
		
		protected function initGroup(): void
		{
			var index: int = values.indexOf( parameter.getValue() );

			if  ( index == -1 )
				return;
				
			var i: int = 0;
			var n: int = parameters.length;
			
			{ internalChange = true;
				for (;i<n;++i)
				{
					Parameter( parameters[ i ] ).setValue( i == index );
				}
			internalChange = false; }
		}
		
		protected function onGroupParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			var index: int = parameters.indexOf( parameter );

			if ( index == -1 )
				return;
			
			if ( Boolean( newValue ) == true )
			{
				this.parameter.setValue( values[ index ] );
			}
			else
			{
				if ( !internalChange )
				{
					parameter.setValue( true );
				}
			}
		}
		
		protected function onParameterChanged( parameter: Parameter, oldValue: *, newValue: * ): void
		{
			var index: int = values.indexOf( newValue );

			if ( index == -1 )
				return;
				
			var i: int = 0;
			var n: int = parameters.length;
			
			{ internalChange = true;
				for (;i<n;++i)
				{
					Parameter( parameters[ i ] ).setValue( i == index );
				}
			internalChange = false; }
		}
		
		public function toString(): String
		{
			return '[Group]';
		}
	}
}