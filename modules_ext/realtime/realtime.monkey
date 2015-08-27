' Copyright 2015 Xaron aka Martin Leidel
'
' This software is provided 'as-is', without any express or implied
' warranty.  In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
' 1. The origin of this software must not be misrepresented; you must not
' claim that you wrote the original software. If you use this software
' in a product, an acknowledgment in the product documentation would be
' appreciated but is not required.
' 2. Altered source versions must be plainly marked as such, and must not be
' misrepresented as being the original software.
' 3. This notice may not be removed or altered from any source distribution.

Strict

#If( TARGET <> "html5" And TARGET <> "android" )
  #Error "Realtime is currently not available for target '${TARGET}'."
#End If

Import "native/realtime.${TARGET}.${LANG}"
#If( TARGET = "android" )
  #LIBS += "${CD}/native/json_simple-1.1.jar"
  #LIBS += "${CD}/native/messaging-android-2.1.52.jar"
#End If

Import brl.asyncevent

Extern Private

Class XRealtime
  Method init:Void( appKey:String, authToken:String )
  Method isInitialized:Bool()
  Method connect:Void( appKey:String, authToken:String )
  Method disconnect:Void()
  Method getAnnouncementSubChannel:String()
  Method getClusterUrl:String()
  Method getConnectionMetadata:String()
  Method getConnectionTimeout:Int()
  Method getHeartbeatActive:Bool()
  Method getHeartbeatFails:Int()
  Method getHeartbeatTime:Int()
  Method getId:String()
  Method getProtocol:String()
  Method getSessionId:String()
  Method getUrl:String()
  Method getIsConnected:Bool()
  Method isSubscribed:Bool( channelName:String )
  Method send:Void( channelName:String, message:String )
  Method setAnnouncementSubChannel:Void( channelName:String )
  Method setClusterUrl:Void( clusterUrl:String )
  Method setConnectionMetadata:Void( connectionMetadata:String )
  Method setConnectionTimeout:Void( connectionTimeout:Int )
  Method setHeartbeatActive:Void( active:Bool )
  Method setHeartbeatFails:Void( newHeartbeatFails:Int )
  Method setHeartbeatTime:Void( newHeartbeatTime:Int )
  Method setId:Void( id:String )
  Method setProtocol:Void( protocol:String )
  Method setUrl:Void( url:String )
  Method subscribe:Void( channelName:String, subscribeOnReconnected:Bool )
  Method unsubscribe:Void( channelName:String )
  
  'Internal functions
  Method getNumberOfEvents:Int()
  Method fetchLastEvent:Void()
  Method getLastResult:Int()          'Returns the last overall result in terms of if there were errors or not
  Method getLastError:Int()           'Returns the last error code
  Method getLastChannelName:String()  'Returns the last channel name an event happened for
  Method getLastMessage:String()
End

Public

Const RT_ERROR:Int = 1
Const RT_CLIENT_CONNECTED:Int = 2
Const RT_CLIENT_DISCONNECTED:Int = 3
Const RT_CLIENT_SUBSCRIBED:Int = 4
Const RT_CLIENT_UNSUBSCRIBED:Int = 5
Const RT_CLIENT_EXCEPTION:Int = 6
Const RT_CLIENT_RECONNECTING:Int = 7
Const RT_CLIENT_RECONNECTED:Int = 8
Const RT_CLIENT_MESSAGE:Int = 9

Interface IRealtimeCallback
  Method OnRealtimeConnected:Void()
  Method OnRealtimeDisconnected:Void()
  Method OnRealtimeSubscribed:Void( channelName:String )
  Method OnRealtimeUnsubscribed:Void( channelName:String )
  Method OnRealtimeException:Void( exception:String )
  Method OnRealtimeReconnecting:Void()
  Method OnRealtimeReconnected:Void()
  Method OnRealtimeNewMessage:Void( channelName:String, message:String )
  Method OnRealtimeClientConnected:Void( metadata:String )
  Method OnRealtimeClientDisconnected:Void( metadata:String, typeOfDisconnect:Int )
  Method OnRealtimeClientSubscribed:Void( metadata:String, channelName:String )
  Method OnRealtimeClientUnsubscribed:Void( metadata:String, channelName:String )
End Interface

Class Realtime Implements IAsyncEventSource
Protected
  Field _realTime:XRealtime = Null
  Field _callback:IRealtimeCallback

Private
  'Prohibit usage of default constructor
  Method New()
  End Method

Public
  Method New( callback:IRealtimeCallback )
    _realTime = New XRealtime()
'    _realTime.init()
    _callback = callback
  End Method

  Method init:Void( appKey:String, authToken:String = "DUMMY" )
    _realTime.init( appKey, authToken )
    AddAsyncEventSource( Self )
  End Method
  
  Method isInitialized:Bool()
    Return _realTime.isInitialized()
  End Method

  Method connect:Void( appKey:String, authToken:String = "DUMMY" )
    _realTime.connect( appKey, authToken )
  End Method

  Method disconnect:Void()
    _realTime.disconnect()
  End Method

  Method getAnnouncementSubChannel:String()
    Return _realTime.getAnnouncementSubChannel()
  End Method

  Method getClusterUrl:String()
    Return _realTime.getClusterUrl()
  End Method
  
  Method getConnectionMetadata:String()
    Return _realTime.getConnectionMetadata()
  End Method
  
  Method getConnectionTimeout:Int()
    Return _realTime.getConnectionTimeout()
  End Method
  
  Method getHeartbeatActive:Bool()
    Return _realTime.getHeartbeatActive()
  End Method
  
  Method getHeartbeatFails:Int()
    Return _realTime.getHeartbeatFails()
  End Method
  
  Method getHeartbeatTime:Int()
    Return _realTime.getHeartbeatTime()
  End Method
  
  Method getId:String()
    Return _realTime.getId()
  End Method
  
  Method getProtocol:String()
    Return _realTime.getProtocol()
  End Method
  
  Method getSessionId:String()
    Return _realTime.getSessionId()
  End Method
  
  Method getUrl:String()
    Return _realTime.getUrl()
  End Method
  
  Method isConnected:Bool()
    Return _realTime.getIsConnected()
  End Method
  
  Method isSubscribed:Bool( channelName:String )
    Return _realTime.isSubscribed( channelName )
  End Method
  
  Method send:Void( channelName:String, message:String )
    _realTime.send( channelName, message )
  End Method
  
  Method setAnnouncementSubChannel:Void( channelName:String )
    _realTime.setAnnouncementSubChannel( channelName )
  End Method
  
  Method setClusterUrl:Void( clusterUrl:String )
    _realTime.setClusterUrl( clusterUrl )
  End Method
  
  Method setConnectionMetadata:Void( connectionMetadata:String )
    _realTime.setConnectionMetadata( connectionMetadata )
  End Method
  
  Method setConnectionTimeout:Void( connectionTimeout:Int )
    _realTime.setConnectionTimeout( connectionTimeout )
  End Method
  
  Method setHeartbeatActive:Void( active:Bool )
    _realTime.setHeartbeatActive( active )
  End Method
  
  Method setHeartbeatFails:Void( newHeartbeatFails:Int )
    _realTime.setHeartbeatFails( newHeartbeatFails )
  End Method
  
  Method setHeartbeatTime:Void( newHeartbeatTime:Int )
    _realTime.setHeartbeatTime( newHeartbeatTime )
  End Method
  
  Method setId:Void( id:String )
    _realTime.setId( id )
  End Method
  
  Method setProtocol:Void( protocol:String )
    _realTime.setProtocol( protocol )
  End Method
  
  Method setUrl:Void( url:String )
    _realTime.setUrl( url )
  End Method
  
  Method subscribe:Void( channelName:String, subscribeOnReconnected:Bool = True )
    _realTime.subscribe( channelName, subscribeOnReconnected )
  End Method
  
  Method unsubscribe:Void( channelName:String )
    _realTime.unsubscribe( channelName )
  End Method

Private
  Method UpdateAsyncEvents:Void()
    If( Not _realTime ) Then Return
    Local numberOfEvents:Int = _realTime.getNumberOfEvents()
    If( numberOfEvents = 0 ) Then Return
    
    'Fetch all events!
    Local lastResult:Int = _realTime.getLastResult()
    
    Select lastResult
      Case RT_CLIENT_CONNECTED
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeConnected()
      Case RT_CLIENT_DISCONNECTED
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeDisconnected()
      Case RT_CLIENT_SUBSCRIBED
        Local channelName:String = _realTime.getLastChannelName()
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeSubscribed( channelName )
      Case RT_CLIENT_UNSUBSCRIBED
        Local channelName:String = _realTime.getLastChannelName()
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeUnsubscribed( channelName )
      Case RT_CLIENT_EXCEPTION
        Local exception:String = _realTime.getLastError()
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeException( exception )
      Case RT_CLIENT_RECONNECTING
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeReconnecting()
      Case RT_CLIENT_RECONNECTED
        _realTime.fetchLastEvent()  'Remove event from list of events
        _callback.OnRealtimeReconnected()
      Case RT_CLIENT_MESSAGE
        Local channelName:String = _realTime.getLastChannelName()
        Local message:String = _realTime.getLastMessage()
        _realTime.fetchLastEvent()  'Remove event from list of events
        'Check if we have a message from an announcement channel
        Select( channelName )
          Case "ortcClientConnected"
            Local pos:Int = message.Find( ":" )
            If( pos > 0 )
              'get the metadata
              Local metadata:String = message[..message.Length()-2]
              metadata = metadata[pos+2..]
              _callback.OnRealtimeClientConnected( metadata )
            End If
          Case "ortcClientDisconnected"
            Local pos:Int = message.Find( ":" )
            If( pos > 0 )
              'get the metadata
              Local metadata:String = message[..message.Length()-8]
              metadata = metadata[pos+2..]
              Local reason:String = message[message.Length()-2..]
              reason = reason[..1]
              _callback.OnRealtimeClientDisconnected( metadata, Int( reason ) )
            End If
          Case "ortcClientSubscribed"
            Local str:String[] = message.Split( ":" )
            Print str.Length()
            If( str.Length() = 3 )
              'Check for the channelName. If it's "ortcClientSubscribed" we ignore it because it's the announcement channel
              Local channel:String = str[2]
              channel = channel[..channel.Length()-2]
              channel = channel[1..]
              If( channel <> "ortcClientConnected" And channel <> "ortcClientDisconnected" And channel <> "ortcClientSubscribed" And channel <> "ortcClientUnsubscribed" )
                Local metadata:String = str[1]
                metadata = metadata[..metadata.Length()-6]
                metadata = metadata[1..]
                _callback.OnRealtimeClientSubscribed( metadata, channel )
              End If
            End If
          Case "ortcClientUnsubscribed"
            Local str:String[] = message.Split( ":" )
            Print str.Length()
            If( str.Length() = 3 )
              'Check for the channelName. If it's "ortcClientUnsubscribed" we ignore it because it's the announcement channel
              Local channel:String = str[2]
              channel = channel[..channel.Length()-2]
              channel = channel[1..]
              If( channel <> "ortcClientConnected" And channel <> "ortcClientDisconnected" And channel <> "ortcClientSubscribed" And channel <> "ortcClientUnsubscribed" )
                Local metadata:String = str[1]
                metadata = metadata[..metadata.Length()-6]
                metadata = metadata[1..]
                _callback.OnRealtimeClientUnsubscribed( metadata, channel )
              End If
            End If
          Default
            'No announcement channel, just proceed normally
            _callback.OnRealtimeNewMessage( channelName, message )
        End Select
    End Select
  End Method
End Class
