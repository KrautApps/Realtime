#include <stdio.h>
#include "lib/libortc.h"
#include <deque>
 
#if defined(WIN32) || defined(_WIN32) || defined(__WIN32)
  #include "Windows.h"
#endif

class RealtimeEvent
{
public:
  int _result;
  String _channelName;
  String _message;
  String _error;
  
  RealtimeEvent::RealtimeEvent( int result, String channel, String message, String error )
  {
    _result = result;
    _channelName = channel;
    _message = message;
    _error = error;
  }
  
  RealtimeEvent::~RealtimeEvent()
  {
  }
};

ortc_context *_RTcontext;
bool _RTisInitialized;

int RT_ERROR = 1;
int RT_CLIENT_CONNECTED = 2;
int RT_CLIENT_DISCONNECTED = 3;
int RT_CLIENT_SUBSCRIBED = 4;
int RT_CLIENT_UNSUBSCRIBED = 5;
int RT_CLIENT_EXCEPTION = 6;
int RT_CLIENT_RECONNECTING = 7;
int RT_CLIENT_RECONNECTED = 8;
int RT_CLIENT_MESSAGE = 9;

std::deque< RealtimeEvent > _RTeventList;

void RTonConnected( ortc_context *context )
{
  RealtimeEvent ev( RT_CLIENT_CONNECTED, "", "", "" );
  _RTeventList.push_back( ev );
}

void RTonDisconnected( ortc_context *context )
{
  RealtimeEvent ev( RT_CLIENT_DISCONNECTED, "", "", "" );
  _RTeventList.push_back( ev );
}

void RTonSubscribed( ortc_context *context, char* channel )
{
  RealtimeEvent ev( RT_CLIENT_SUBSCRIBED, channel, "", "" );
  _RTeventList.push_back( ev );
}

void RTonUnsubscribed( ortc_context *context, char* channel )
{
  RealtimeEvent ev( RT_CLIENT_UNSUBSCRIBED, channel, "", "" );
  _RTeventList.push_back( ev );
}

void RTonException( ortc_context *context, char* exception )
{
  RealtimeEvent ev( RT_CLIENT_EXCEPTION, "", "", exception );
  _RTeventList.push_back( ev );
}

void RTonReconnecting( ortc_context *context )
{
  RealtimeEvent ev( RT_CLIENT_RECONNECTING, "", "", "" );
  _RTeventList.push_back( ev );
}

void RTonReconnected( ortc_context *context )
{
  RealtimeEvent ev( RT_CLIENT_RECONNECTED, "", "", "" );
  _RTeventList.push_back( ev );
}

void RTonMessage( ortc_context *context, char* channel, char* message )
{
  RealtimeEvent ev( RT_CLIENT_MESSAGE, channel, message, "" );
  _RTeventList.push_back( ev );
}

void RTinit( String &appKey, String &appToken )
{
  _RTcontext = ortc_create_context();
  ortc_set_cluster( _RTcontext, "http://ortc-developers.realtime.co/server/2.1" );
  ortc_set_onConnected   ( _RTcontext, RTonConnected );
  ortc_set_onDisconnected( _RTcontext, RTonDisconnected );
  ortc_set_onSubscribed  ( _RTcontext, RTonSubscribed );
  ortc_set_onUnsubscribed( _RTcontext, RTonUnsubscribed );
  ortc_set_onReconnecting( _RTcontext, RTonReconnecting );
  ortc_set_onReconnected ( _RTcontext, RTonReconnected );
  ortc_set_onException   ( _RTcontext, RTonException );

  ortc_connect( _RTcontext, (char*)appKey.Data(), (char*)appToken.Data() );
  _RTisInitialized = true;
}

void RTdestroy()
{
  ortc_free_context( _RTcontext );
}

bool RTisInitialized()
{
  return _RTisInitialized;
}

void RTconnect( String appKey, String appToken )
{
  if( _RTcontext )
  {
    if( !ortc_is_connected( _RTcontext ) )
      ortc_connect( _RTcontext, (char*)appKey.Data(), (char*)appToken.Data() );
  }
}

void RTdisconnect()
{
  if( _RTcontext )
  {
    if( ortc_is_connected( _RTcontext ) )
      ortc_disconnect( _RTcontext );
  }
}

String RTgetAnnouncementSubChannel()
{
  if( _RTcontext )
    return ortc_get_announcementSubChannel( _RTcontext );
  return "ERROR";
}

String RTgetClusterUrl()
{
  if( _RTcontext )
    return ortc_get_cluster( _RTcontext );
  return "ERROR";
}

String RTgetConnectionMetadata()
{
  if( _RTcontext )
    return ortc_get_connection_metadata( _RTcontext );
  return "ERROR";
}

int RTgetConnectionTimeout()
{
  // not implemented
  return -1;
}

bool RTgetHeartbeatActive()
{
  // not implemented
  return false;
}

int RTgetHeartbeatFails()
{
  // not implemented
  return -1;
}

int RTgetHeartbeatTime()
{
  // not implemented
  return -1;
}

int RTgetId()
{
  // not implemented
  return -1;
}

bool RTgetIsConnected()
{
  if( _RTcontext )
    return ortc_is_connected( _RTcontext );
  return false;
}

String RTgetUrl()
{
  if( _RTcontext )
    return ortc_get_url( _RTcontext );
  return "ERROR";
}

bool RTisSubscribed( String channelName )
{
  if( _RTcontext )
    return ortc_is_subscribed( _RTcontext, (char*)channelName.Data() );
  return false;
}

void RTsend( String channelName, String message )
{
  if( _RTcontext )
    ortc_send( _RTcontext, (char*)channelName.Data(), (char*)message.Data() );
}

void RTsetAnnouncementSubChannel( String channelName )
{
  if( _RTcontext )
    ortc_set_announcementSubChannel( _RTcontext, (char*)channelName.Data() );
}

void RTsetClusterUrl( String clusterUrl )
{
  if( _RTcontext )
    ortc_set_cluster( _RTcontext, (char*)clusterUrl.Data() );
}

void RTsetConnectionMetadata( String connectionMetadata )
{
  if( _RTcontext )
    ortc_set_connection_metadata( _RTcontext, (char*)connectionMetadata.Data() );
}

void RTsetConnectionTimeout( int connectionTimeout )
{
  // not implemented
}

void RTsetHeartbeatActive( bool active )
{
  // not implemented
}

void RTsetHeartbeatFails( int newHeartbeatFails )
{
  // not implemented
}

void RTsetHeartbeatTime( int newHeartbeatTime )
{
  // not implemented
}

void RTsetId( int id )
{
  // not implemented
}

void RTsetUrl( String url )
{
  if( _RTcontext )
    ortc_set_url( _RTcontext, (char*)url.Data() );
}

void RTsubscribe( String channelName, bool subscribeOnReconnected )
{
  if( _RTcontext )
    ortc_subscribe( _RTcontext, (char*)channelName.Data(), (int)subscribeOnReconnected, RTonMessage );
}

void RTunsubscribe( String channelName )
{
  if( _RTcontext )
    ortc_unsubscribe( _RTcontext, (char*)channelName.Data() );
} 

int RTgetNumberOfEvents()
{
  return _RTeventList.size();
}

void RTfetchLastEvent()
{
  _RTeventList.pop_front();
}

int RTgetLastResult()
{
  if( _RTeventList.size() > 0 )
    return _RTeventList.front()._result;
  return -1;
}

String RTgetLastError()
{
  if( _RTeventList.size() > 0 )
    return _RTeventList.front()._error;
  return "ERROR";
}

String RTgetLastChannelName()
{
  if( _RTeventList.size() > 0 )
    return _RTeventList.front()._channelName;
  return "ERROR";
}

String RTgetLastMessage()
{
  if( _RTeventList.size() > 0 )
    return _RTeventList.front()._message;
  return "ERROR";
}
