package
{
	import de.popforge.audio.output.Audio;
	import de.popforge.audio.output.Sample;
	import de.popforge.audio.output.SoundFactory;
	
	import flash.display.Sprite;
	import flash.media.Sound;
	
	/**
	 * Example CreateASound
	 * Creates one second of dynamic audio and converts it to a flash.media.Sound object
	 * 
	 * @author Andre Michelle
	 */

	public class CreateASound extends Sprite
	{
		public function CreateASound()
		{
			init();
		}
		
		private function init(): void
		{
			//-- Create Array to store Samples
			var samples: Array = new Array();
			
			//-- some locals
			var sample: Sample;
			var amplitude: Number;
			var phase: Number = 0;
			var freq: Number = 220;
			
			//-- CREATE ONE SECOND OF AUDIO (SINUS WAVE)
			for( var i: int = 0 ; i < 44100 ; i++ )
			{
				//-- create an amplitude [-1,1]
				amplitude = Math.sin( phase * Math.PI * 2 );
				
				//-- create a sample
				sample = new Sample( amplitude, amplitude );
				
				//-- push in array
				samples.push( sample );
				
				//-- increase phase
				phase += freq / Audio.RATE44100;
			}
			
			//-- create a Sound object from samples array
			SoundFactory.fromArray( samples, Audio.STEREO, Audio.BIT16, Audio.RATE44100, onSoundGenerated );
		}
		
		private function onSoundGenerated( sound: Sound ): void
		{
			//-- play the shit
			sound.play();
		}
	}
}