
import java.util.ArrayList;

import ibt.ortc.api.Ortc;
import ibt.ortc.extensibility.OnConnected;
import ibt.ortc.extensibility.OnDisconnected;
import ibt.ortc.extensibility.OnException;
import ibt.ortc.extensibility.OnMessage;
import ibt.ortc.extensibility.OnReconnected;
import ibt.ortc.extensibility.OnReconnecting;
import ibt.ortc.extensibility.OnRegistrationId;
import ibt.ortc.extensibility.OnSubscribed;
import ibt.ortc.extensibility.OnUnsubscribed;
import ibt.ortc.extensibility.OrtcClient;
import ibt.ortc.extensibility.OrtcFactory;

class RealtimeEvent
{
  public int _result;
  public String _channelName;
  public String _message;
  public String _error;
  
  RealtimeEvent( int result, String channel, String message, String error )
  {
    _result = result;
    _channelName = channel;
    _message = message;
    _error = error;
  }
}

class XRealtime
{
  private Activity _activity;
  private OrtcClient _client = null;
  private boolean _isInitialized = false;

  private int RT_ERROR = 1;
  private int RT_CLIENT_CONNECTED = 2;
  private int RT_CLIENT_DISCONNECTED = 3;
  private int RT_CLIENT_SUBSCRIBED = 4;
  private int RT_CLIENT_UNSUBSCRIBED = 5;
  private int RT_CLIENT_EXCEPTION = 6;
  private int RT_CLIENT_RECONNECTING = 7;
  private int RT_CLIENT_RECONNECTED = 8;
  private int RT_CLIENT_MESSAGE = 9;

  private ArrayList< RealtimeEvent > _eventList;
  
  XRealtime()
  {
    _eventList = new ArrayList< RealtimeEvent >();
    _activity = BBAndroidGame.AndroidGame().GetActivity(); 
  }
  
  public void init( String appKey, String appToken )
  {
    try
    {
      Ortc ortc = new Ortc();
      OrtcFactory factory = ortc.loadOrtcFactory( "IbtRealtimeSJ" );
      _client = factory.createClient();
      _client.setConnectionMetadata( "AndroidApp" );
      _client.setClusterUrl( "http://ortc-developers.realtime.co/server/2.1/" );
    }
    catch( Exception e )
    {
    }
    if( _client != null )
    {
      try
      {
        _client.onConnected = new OnConnected()
        {
          public void run( final OrtcClient sender )
          {
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_CONNECTED, "", "", "" ) );
              }
            } );
          }
        };

        _client.onDisconnected = new OnDisconnected()
        {
          public void run( OrtcClient arg0 )
          {
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_DISCONNECTED, "", "", "" ) );
              }
            } );
          }
        };

        _client.onSubscribed = new OnSubscribed()
        {
          public void run( OrtcClient sender, String channel )
          {
            final String subscribedChannel = channel;
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_SUBSCRIBED, subscribedChannel, "", "" ) );
              }
            } );
          }
        };

        _client.onUnsubscribed = new OnUnsubscribed()
        {
          public void run( OrtcClient sender, String channel )
          {
            final String subscribedChannel = channel;
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_UNSUBSCRIBED, subscribedChannel, "", "" ) );
              }
            } );
          }
        };

        _client.onException = new OnException()
        {
          public void run( OrtcClient send, Exception ex )
          {
            final Exception exception = ex;
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_EXCEPTION, "", "", exception.getMessage() ) );
              }
            } );
          }
        };

        _client.onReconnecting = new OnReconnecting()
        {
          public void run( OrtcClient sender )
          {
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_RECONNECTING, "", "", "" ) );
              }
            } );
          }
        };
        
        _client.onReconnected = new OnReconnected()
        {
          public void run( final OrtcClient sender )
          {
            _activity.runOnUiThread( new Runnable()
            {
              public void run()
              {
                _eventList.add( new RealtimeEvent( RT_CLIENT_RECONNECTED, "", "", "" ) );
              }
            } );
          }
        };

        _client.connect( appKey, appToken );
        _isInitialized = true;
      }
      catch( Exception e )
      {
      }
    }
  }

  public boolean isInitialized()
  {
    return _isInitialized;
  }
  
  public void connect( String appKey, String appToken )
  {
    if( _client != null )
    {
      if( !_client.getIsConnected() )
        _client.connect( appKey, appToken );
    }
  }

  public void disconnect()
  {
    if( _client != null )
    {
      if( _client.getIsConnected() )
        _client.disconnect();
    }
  }
  
  public String getAnnouncementSubChannel()
  {
    if( _client != null )
      return _client.getAnnouncementSubChannel();
    return "ERROR";
  }

  public String getClusterUrl()
  {
    if( _client != null )
      return _client.getClusterUrl();
    return "ERROR";
  }

  public String getConnectionMetadata()
  {
    if( _client != null )
      return _client.getConnectionMetadata();
    return "ERROR";
  }

  public int getConnectionTimeout()
  {
    if( _client != null )
      return _client.getConnectionTimeout();
    return -1;
  }

  public boolean getHeartbeatActive()
  {
    if( _client != null )
      return _client.getHeartbeatActive();
    return false;
  }

  public int getHeartbeatFails()
  {
    if( _client != null )
      return _client.getHeartbeatFails();
    return -1;
  }

  public int getHeartbeatTime()
  {
    if( _client != null )
      return _client.getHeartbeatTime();
    return -1;
  }

  public int getId()
  {
    if( _client != null )
      return _client.getId();
    return -1;
  }

  public boolean getIsConnected()
  {
    if( _client != null )
      return _client.getIsConnected();
    return false;
  }
  
  public String getUrl()
  {
    if( _client != null )
      return _client.getUrl();
    return "ERROR";
  }

  public boolean isSubscribed( String channelName )
  {
    if( _client != null )
      return _client.isSubscribed( channelName );
    return false;
  }
 
  public void send( String channelName, String message )
  {
    if( _client != null )
      _client.send( channelName, message );
  }
  
  public void setAnnouncementSubChannel( String channelName )
  {
    if( _client != null )
      _client.setAnnouncementSubChannel( channelName );
  }

  public void setClusterUrl( String clusterUrl )
  {
    if( _client != null )
      _client.setClusterUrl( clusterUrl );
  }

  public void setConnectionMetadata( String connectionMetadata )
  {
    if( _client != null )
      _client.setConnectionMetadata( connectionMetadata );
  }

  public void setConnectionTimeout( int connectionTimeout )
  {
    if( _client != null )
      _client.setConnectionTimeout( connectionTimeout );
  }

  public void setHeartbeatActive( boolean active )
  {
    if( _client != null )
      _client.setHeartbeatActive( active );
  }

  public void setHeartbeatFails( int newHeartbeatFails )
  {
    if( _client != null )
      _client.setHeartbeatFails( newHeartbeatFails );
  }

  public void setHeartbeatTime( int newHeartbeatTime )
  {
    if( _client != null )
      _client.setHeartbeatTime( newHeartbeatTime );
  }

  public void setId( int id )
  {
    if( _client != null )
      _client.setId( id );
  }

  public void setUrl( String url )
  {
    if( _client != null )
      _client.setUrl( url );
  }

  public void subscribe( String channelName, boolean subscribeOnReconnected )
  {
    _client.subscribe( channelName, subscribeOnReconnected, new OnMessage()
    {
      public void run( OrtcClient sender, String channel, String message )
      {
        final String subscribedChannel = channel;
        final String messageReceived = message;
        _activity.runOnUiThread( new Runnable()
        {
          public void run()
          {
            _eventList.add( new RealtimeEvent( RT_CLIENT_MESSAGE, subscribedChannel, messageReceived, "" ) );
          }
        } );
      }
    } );
  }

  public void unsubscribe( String channelName )
  {
    if( _client != null )
      _client.unsubscribe( channelName );
  } 

  public int getNumberOfEvents()
  {
    return _eventList.size();
  }
  
  public void fetchLastEvent()
  {
    _eventList.remove(0);
  }
  
  public int getLastResult()
  {
    if( _eventList.size() > 0 )
      return _eventList.get(0)._result;
    return -1;
  }
  
  public String getLastError()
  {
    if( _eventList.size() > 0 )
      return _eventList.get(0)._error;
    return "ERROR";
  }

  public String getLastChannelName()
  {
    if( _eventList.size() > 0 )
      return _eventList.get(0)._channelName;
    return "ERROR";
  }

  public String getLastMessage()
  {
    if( _eventList.size() > 0 )
      return _eventList.get(0)._message;
    return "ERROR";
  }
}
