function XRealtime()
{
}

var _ortcClient;
var _isInitialized = false;
var _channels = [];

function Event( result, channel, message, error )
{
  this.result = result;
  this.channelName = channel;
  this.message = message;
  this.error = error;
};

var _eventList = [];

var RT_ERROR = 1;
var RT_CLIENT_CONNECTED = 2;
var RT_CLIENT_DISCONNECTED = 3;
var RT_CLIENT_SUBSCRIBED = 4;
var RT_CLIENT_UNSUBSCRIBED = 5;
var RT_CLIENT_EXCEPTION = 6;
var RT_CLIENT_RECONNECTING = 7;
var RT_CLIENT_RECONNECTED = 8;
var RT_CLIENT_MESSAGE = 9;

XRealtime.prototype.init = function( appKey, appToken )
{
  // add the pusher dependency to the html file
  var head = document.getElementsByTagName( 'head' )[0];
  var script = document.createElement( 'script' );
  script.type = 'text/javascript';
  script.src = "http://dfdbz2tdq3k01.cloudfront.net/js/2.1.0/ortc.js";
  head.appendChild( script );
  _isInitialized = false;

  script.onload = function()
  {
    loadOrtcFactory( IbtRealTimeSJType, function( factory, error )
    {
      if( error != null )
      {
        alert( "Factory error: " + error.message );
      }
      else
      {
        if( factory != null )
        {
          // Create ORTC client
          _ortcClient = factory.createClient();

          // Set ORTC client properties
          _ortcClient.setConnectionMetadata( 'clientConnMeta' );
          _ortcClient.setClusterUrl( 'http://ortc-developers.realtime.co/server/2.1/' );

          _ortcClient.onConnected = function( ortc )
          {
            // Connected
            _eventList.push( new Event( RT_CLIENT_CONNECTED, '', '', '' ) );
          };
 
          _ortcClient.onDisconnected = function( ortc )
          { 
            // Disconnected
            _eventList.push( new Event( RT_CLIENT_DISCONNECTED, '', '', '' ) );
          };

          _ortcClient.onSubscribed = function( ortc, channel )
          { 
            // Subscribed to the channel 'channel'
            _eventList.push( new Event( RT_CLIENT_SUBSCRIBED, channel, '', '' ) );
          };

          _ortcClient.onUnsubscribed = function( ortc, channel )
          { 
            // Unsubscribed to the channel 'channel'
            _eventList.push( new Event( RT_CLIENT_UNSUBSCRIBED, channel, '', '' ) );
          };

          _ortcClient.onException = function( ortc, exception )
          {
            // Exception occurred: 'exception'
            _eventList.push( new Event( RT_CLIENT_EXCEPTION, '', '', exception ) );
          };

          _ortcClient.onReconnecting = function( ortc )
          {
            // Reconnecting
            _eventList.push( new Event( RT_CLIENT_RECONNECTING, '', '', '' ) );
          };

          _ortcClient.onReconnected = function( ortc )
          {
            // Reconnected
            _eventList.push( new Event( RT_CLIENT_RECONNECTED, '', '', '' ) );
          };
        }
        _ortcClient.connect( appKey, appToken );
        _isInitialized = true;
      }
    });
  }
}

XRealtime.prototype.isInitialized = function()
{
  return _isInitialized;
}

XRealtime.prototype.connect = function( appKey, appToken )
{
  if( _ortcClient )
  {
    if( !_ortcClient.getIsConnected() )
      _ortcClient.connect( appKey, appToken );
  }
}

XRealtime.prototype.disconnect = function()
{
  if( _ortcClient )
  {
    if( _ortcClient.getIsConnected() )
      _ortcClient.disconnect();
  }
}

XRealtime.prototype.getAnnouncementSubChannel = function()
{
  if( _ortcClient )
    return _ortcClient.getAnnouncementSubChannel();
  return "ERROR";
}

XRealtime.prototype.getClusterUrl = function()
{
  if( _ortcClient )
    return _ortcClient.getClusterUrl();
  return "ERROR";
}

XRealtime.prototype.getConnectionMetadata = function()
{
  if( _ortcClient )
    return _ortcClient.getConnectionMetadata();
  return "ERROR";
}

XRealtime.prototype.getConnectionTimeout = function()
{
  if( _ortcClient )
    return _ortcClient.getConnectionTimeout();
  return -1;
}

XRealtime.prototype.getHeartbeatActive = function()
{
  if( _ortcClient )
    return _ortcClient.getHeartbeatActive();
  return false;
}

XRealtime.prototype.getHeartbeatFails = function()
{
  if( _ortcClient )
    return _ortcClient.getHeartbeatFails();
  return -1;
}

XRealtime.prototype.getHeartbeatTime = function()
{
  if( _ortcClient )
    return _ortcClient.getHeartbeatTime();
  return -1;
}

XRealtime.prototype.getId = function()
{
  if( _ortcClient )
    return _ortcClient.getId();
  return -1;
}

XRealtime.prototype.getUrl = function()
{
  if( _ortcClient )
    return _ortcClient.getUrl();
  return "ERROR";
}

XRealtime.prototype.getIsConnected = function()
{
  if( _ortcClient )
    return _ortcClient.getIsConnected();
  return false;
}

XRealtime.prototype.isSubscribed = function( channelName )
{
  if( _ortcClient )
    return _ortcClient.isSubscribed( channelName );
  return false;
}

XRealtime.prototype.send = function( channelName, message )
{
  if( _ortcClient )
    _ortcClient.send( channelName, message );
}

XRealtime.prototype.setAnnouncementSubChannel = function( channelName )
{
  if( _ortcClient )
    _ortcClient.setAnnouncementSubChannel( channelName );
}

XRealtime.prototype.setClusterUrl = function( clusterUrl )
{
  if( _ortcClient )
    _ortcClient.setClusterUrl( clusterUrl );
}

XRealtime.prototype.setConnectionMetadata = function( connectionMetadata )
{
  if( _ortcClient )
    _ortcClient.setConnectionMetadata( connectionMetadata );
}

XRealtime.prototype.setConnectionTimeout = function( connectionTimeout )
{
  if( _ortcClient )
    _ortcClient.setConnectionTimeout( connectionTimeout );
}

XRealtime.prototype.setHeartbeatActive = function( active )
{
  if( _ortcClient )
    _ortcClient.setHeartbeatActive( active );
}

XRealtime.prototype.setHeartbeatFails = function( newHeartbeatFails )
{
  if( _ortcClient )
    _ortcClient.setHeartbeatFails( newHeartbeatFails );
}

XRealtime.prototype.setHeartbeatTime = function( newHeartbeatTime )
{
  if( _ortcClient )
    _ortcClient.setHeartbeatTime( newHeartbeatTime );
}

XRealtime.prototype.setId = function( id )
{
  if( _ortcClient )
    _ortcClient.setId( id );
}

XRealtime.prototype.setUrl = function( url )
{
  if( _ortcClient )
    _ortcClient.setUrl( url );
}

XRealtime.prototype.subscribe = function( channelName, subscribeOnReconnected )
{
  if( _ortcClient )
  {
    _ortcClient.subscribe( channelName, subscribeOnReconnected,
      function( ortc, channel, message )
      {
        _eventList.push( new Event( RT_CLIENT_MESSAGE, channel, message, '' ) );
      }
    );
  }
}

XRealtime.prototype.unsubscribe = function( channelName )
{
  if( _ortcClient )
    _ortcClient.unsubscribe( channelName );
}

XRealtime.prototype.getNumberOfEvents = function()
{
  return _eventList.length;
}

XRealtime.prototype.fetchLastEvent = function()
{
  if( _eventList.length > 0 )
    _eventList.shift();
}

XRealtime.prototype.getLastResult = function()
{
  if( _eventList.length > 0 )
    return _eventList[0].result;
}

XRealtime.prototype.getLastError = function()
{
  if( _eventList.length > 0 )
    return _eventList[0].error;
}

XRealtime.prototype.getLastChannelName = function()
{
  if( _eventList.length > 0 )
  {
    return _eventList[0].channelName;
  }
}

XRealtime.prototype.getLastMessage = function()
{
  if( _eventList.length > 0 )
    return _eventList[0].message;
}
