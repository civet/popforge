/*
Copyright(C) 2007 Andre Michelle and Joa Ebert

PopForge is an ActionScript3 code sandbox developed by Andre Michelle and Joa Ebert
http://sandbox.popforge.de

This file is part of PopforgeAS3Audio.

PopforgeAS3Audio is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

PopforgeAS3Audio is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>
*/
package de.popforge.audio.processor.effects
{
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.processor.IAudioProcessor;
	import de.popforge.parameter.MappingNumberExponential;
	import de.popforge.parameter.Parameter;
	import de.popforge.parameter.MappingNumberLinear;
	
	public class QuirkFilter
		implements IAudioProcessor
	{
		public const parameterX: Parameter = new Parameter( new MappingNumberLinear( -1, 1 ), 0 );
		public const parameterY: Parameter = new Parameter( new MappingNumberLinear( 0, 1 ), 0 );
		
		private var outL: Number;
		private var outR: Number;
		
		private var x: Number;
		
		public function QuirkFilter()
		{
			reset();
		}
		
		public function reset(): void
		{
			outL = outR = 0;
			
			x = 0;
		}

		public function processAudio( samples: Array ): void
		{
			var n: int = samples.length;
			
			var input: Sample;
			
			var x: Number = parameterX.getValue();
			
			var highpass: Boolean;
			
			var c: Number;
			
			for( var i: int = 0 ; i < n ; i++ )
			{
				input = samples[i];
				
				if( this.x < 0 )
				{
					highpass = false;
					c = .005 * Math.exp( ( this.x + 1 ) * Math.log( .8 / .005 ) );
				}
				else
				{
					highpass = true;
					c = .005 * Math.exp( this.x * Math.log( .8 / .005 ) );
				}
				
				outL += ( input.left - outL ) * c;
				outR += ( input.right - outR ) * c;

				if( highpass )
				{
					input.left -= outL;
					input.right -= outR;
				}
				else
				{
					input.left = outL;
					input.right = outR;
				}
				
				//-- interpolate
				this.x += ( x - this.x ) * .0004;
			}
		}
	}
}