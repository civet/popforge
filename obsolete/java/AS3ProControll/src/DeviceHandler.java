import java.io.ByteArrayOutputStream;
import java.io.IOException;

import procontroll.ControllButton;
import procontroll.ControllDevice;
import procontroll.ControllStick;

public class DeviceHandler
{
	ControllDevice device;
	int id;
	
	public DeviceHandler( ControllDevice device, int id )
	{
		this.device = device;
		this.id = id;
	}
	
	public byte[] valuesToByteArray()
	{
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		
		ControllButton button;
		
		//-- write id
		stream.write( id );
		
		//-- BUTTONS
		int buttonByte = 0;
		
		for( int i = 0 ; i < device.getNumberOfButtons() && i < 31 ; i++ )
		{
			button = device.getButton( i );
			
			if( button.pressed() )
			{
				buttonByte |= ( 1 << i );
			}
		}
		
		//-- write int
		stream.write( (byte)( buttonByte >> 0 & 0xff ) );
		stream.write( (byte)( buttonByte >> 8 & 0xff ) );
		stream.write( (byte)( buttonByte >> 16 & 0xff ) );
		stream.write( (byte)( buttonByte >> 24 & 0xff ) );
		
		//-- SLIDER
		ControllStick stick;
		
		int stickValue;
		
		for( int i = 0 ; i < device.getNumberOfSticks() ; i++ )
		{
			stick = device.getStick( i );
			
			stickValue = (int)(stick.getX() * 0x7fff + 0x8000 );
			
			stream.write( (byte)( stickValue >> 0 & 0xff ) );
			stream.write( (byte)( stickValue >> 8 & 0xff ) );
			stream.write( (byte)( stickValue >> 16 & 0xff ) );
			stream.write( (byte)( stickValue >> 24 & 0xff ) );
			
			stickValue = (int)(stick.getY() * 0x7fff + 0x8000 );
			
			stream.write( (byte)( stickValue >> 0 & 0xff ) );
			stream.write( (byte)( stickValue >> 8 & 0xff ) );
			stream.write( (byte)( stickValue >> 16 & 0xff ) );
			stream.write( (byte)( stickValue >> 24 & 0xff ) );
		}
		
		return stream.toByteArray();
	}
	
	public byte[] toByteArray()
	{
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		
		try
		{
			//-- write id
			stream.write( id );
			
			//-- write name (ends with zero byte)
			stream.write( device.getName().getBytes() );
			stream.write( 0 );
			
			//-- write number of inputs
			stream.write( device.getNumberOfSliders() );
			stream.write( device.getNumberOfButtons() );
			stream.write( device.getNumberOfSticks() );
		}
		catch( IOException e )
		{
		}
		
		return stream.toByteArray();
	}
}
