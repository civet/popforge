import java.io.ByteArrayOutputStream;
import java.io.IOException;

import processing.core.PApplet;
import processing.net.Client;
import processing.net.Server;
import procontroll.*;

public class AS3ProControll extends PApplet
{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static private final char ACTION_GET_DEVICES = 1;
	static private final char ACTION_UPDATE_DEVICES = 2;
	
	Server myServer;
	ControllIO controll;
	
	DeviceHandler handlers[];
	int numDevices;
	
	static public void main( String args[] )
	{
		PApplet.main( new String[]{ "AS3ProControll" } );
	}

	public void setup()
	{
		myServer = new Server( this, 10002 );
		controll = ControllIO.getInstance( this );
		
		numDevices = controll.getNumberOfDevices();
		
		ControllDevice device;
		
		handlers = new DeviceHandler[numDevices];
		
		for( int i = 2 ; i < numDevices ; i++ )
		{
			device = controll.getDevice( i );
			
			handlers[i] = new DeviceHandler( device, i );
		}
	}
	
	public void draw()
	{
		Client thisClient = myServer.available();
		
		char action;
		
		if( thisClient != null )
		{
			//-- receive message, if any
			for( int i = 0 ; i < thisClient.available() ; i++ )
			{
				action = thisClient.readChar();
				
				switch( action )
				{
					case ACTION_GET_DEVICES:
						
						sendAvailableDevices( thisClient );
						break;
					
					case ACTION_UPDATE_DEVICES:
						
						sendUpdatedDevices( thisClient );
						break;
				}
			}
		}
	}
	
	private void sendAvailableDevices( Client receiver )
	{
		DeviceHandler handler;
		
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		
		stream.write( ACTION_GET_DEVICES );
		
		for( int i = 2 ; i < numDevices ; i++ )
		{
			handler = handlers[i];
			
			try
			{
				stream.write( handler.toByteArray() );
			}
			catch( IOException e )
			{
				println(e.toString());
			}
		}
		
		receiver.write( stream.toByteArray() );
	}
	
	private void sendUpdatedDevices( Client receiver )
	{
		DeviceHandler handler;
		
		ByteArrayOutputStream stream = new ByteArrayOutputStream();
		
		stream.write( ACTION_UPDATE_DEVICES );
		
		for( int i = 2 ; i < numDevices ; i++ )
		{
			handler = handlers[i];
			
			try
			{
				stream.write( handler.valuesToByteArray() );
			}
			catch( IOException e )
			{
				println(e.toString());
			}
		}
		
		receiver.write( stream.toByteArray() );
	}
}
