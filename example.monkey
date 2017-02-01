Strict

Import mojo

Import realtime

Const APP_KEY:String = "QI94Ii"
Const AUTH_TOKEN:String = "Not necessary for unsecured connections!"

Class MyApp Extends App Implements IRealtimeCallback
  Field _realtime:Realtime = Null
  Field _message:String
  Field _channelName:String
  Field _messageHistory:List<String>
  Field _isInitialized:Bool
  Field _isConnected:Bool
  Field _subscribed:Bool
  Field _keyboardEnabled:Bool
  Field _text:String

  Method OnCreate:Int()
    _realtime = New Realtime( Self )
    _realtime.init( APP_KEY )
    _channelName = "MyChannel"
    _messageHistory = New List<String>()
    _messageHistory.AddLast( "Connecting..." )
    _isInitialized = False
    _isConnected = False
    _subscribed = False
    _keyboardEnabled = False
    SetUpdateRate( 30 )
    Return 0
  End Method

  Method OnUpdate:Int()
    UpdateAsyncEvents()
    
    If( Not _isInitialized )
      _isInitialized = _realtime.isInitialized()
    End If

    Local mx:Int = TouchX()
    Local my:Int = TouchY()
    If( TouchDown() )
      If( mx > 10 And mx < 110 And my > 10 And my < 40 )
        'Connect
        If( _isInitialized And Not _isConnected )
          _realtime.connect( APP_KEY )
        End If
      Else If( mx > 120 And mx < 220 And my > 10 And my < 40 )
        'Disconnect
        If( _isConnected )
          _realtime.disconnect()
        End If
      Else If( mx > 230 And mx < 330 And my > 10 And my < 40 )
        'Subscribe
        If( Not _subscribed )
          _realtime.subscribe( _channelName )
          _subscribed = True
        End If
      Else If( mx > 340 And mx < 440 And my > 10 And my < 40 )
        'Unsubscribe
        If( _subscribed )
          _realtime.unsubscribe( _channelName )
          _subscribed = False
        End If
      Else If( Not _text.Length() = 0 And _subscribed And mx > 330 And mx < 380 And my > 45 And my < 75 )
        'Send
        _realtime.send( _channelName, _text )
        _text = ""
      Else If( _subscribed And mx > 120 And mx < 320 And my > 45 And my < 75 )
        'Text field
        If( Not _keyboardEnabled )
          _keyboardEnabled = True
          EnableKeyboard()
        End If
      End If
    End If
    If( _keyboardEnabled )
      If( Not _subscribed )
        _keyboardEnabled = False
      Else
        Repeat
          Local char:Int = GetChar()
          If( Not char ) Then Exit
          If( char >= 32 )
            _text += String.FromChar( char )
          Else
            Select char
              Case 8
                _text = _text[..-1]
              Case 13
                _keyboardEnabled = False
                DisableKeyboard()
              Case 27
                _keyboardEnabled = False
                DisableKeyboard()
            End
          End If
        Forever
      End If
    End If
    Return 0
  End Method

  Method OnRender:Int()
    Cls

    'Connect button
    If( Not _isInitialized Or _isConnected )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 0, 255, 0 )
    End If
    DrawRect( 10, 10, 100, 30 )
    DrawText( "Connect", 30, 20 )

    'Disconnect button
    If( Not _isConnected )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 0, 255, 0 )
    End If
    DrawRect( 120, 10, 100, 30 )
    DrawText( "Disconnect", 130, 20 )

    'Subscribe button
    If( Not _isConnected Or _subscribed )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 0, 255, 0 )
    End If
    DrawRect( 230, 10, 100, 30 )
    DrawText( "Subscribe", 240, 20 )

    'Unsubscribe button
    If( Not _isConnected Or Not _subscribed )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 0, 255, 0 )
    End If
    DrawRect( 340, 10, 100, 30 )
    DrawText( "Unsubscribe", 350, 20 )

    'Input field
    If( Not _isConnected Or Not _subscribed )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 255, 255, 0 )
    End If
    DrawText( "Type something:", 10, 55 )
    DrawRect( 120, 45, 200, 30 )
    SetColor( 0, 0, 0 )
    DrawRect( 122, 47, 196, 26 )
    If( Not _isConnected Or Not _subscribed )
      SetColor( 128, 128, 128 )
    Else
      SetColor( 255, 255, 0 )
    End If
    Local txt:String = _text
    If( _keyboardEnabled And ( Millisecs() / 500 ) Mod 2 )
      txt += "|"
    End If
    DrawText( txt, 125, 55 )
    
    'Send button
    DrawRect( 330, 45, 50, 30 )
    DrawText( "SEND", 340, 55 )
    
    'Text field
    SetColor( 255, 255, 0 )
    DrawRect( 10, 80, 600, 200 )
    SetColor( 0, 0, 0 )
    DrawRect( 12, 82, 596, 196 )
    SetColor( 255, 255, 0 )
    Local i:Int = 0
    For Local msg:String = EachIn _messageHistory
      DrawText( msg, 15, 85+i*15 )
      i += 1
    Next
    Return 0
  End Method

  Method addMessage:Void( msg:String )
    _messageHistory.AddLast( msg )
    If( _messageHistory.Count() > 13 )
      _messageHistory.RemoveFirst()
    End If
  End Method

  '************************************************************************
  'Call back functions from Realtime.co
  '************************************************************************
  Method OnRealtimeConnected:Void()
    _message = "Connected!"
    addMessage( _message )
    _isConnected = True
    'Subscribe to the global announcement channels
    _realtime.subscribe( "ortcClientConnected" )
    _realtime.subscribe( "ortcClientDisconnected" )
    _realtime.subscribe( "ortcClientSubscribed" )
    _realtime.subscribe( "ortcClientUnsubscribed" )
  End Method
  
  Method OnRealtimeDisconnected:Void()
    _message = "Disconnected!"
    addMessage( _message )
    _isConnected = False;
    _subscribed = False;
  End Method
  
  Method OnRealtimeSubscribed:Void( channelName:String )
    _message = "Subscribed to channel " + channelName
    addMessage( _message )
  End Method
  
  Method OnRealtimeUnsubscribed:Void( channelName:String )
    _message = "Unsubscribed from channel " + channelName
    addMessage( _message )
  End Method
  
  Method OnRealtimeException:Void( exception:String )
    _message = "Exception happened: " + exception
    addMessage( _message )
  End Method
  
  Method OnRealtimeReconnecting:Void()
    _message = "Reconnecting..."
    addMessage( _message )
  End Method
  
  Method OnRealtimeReconnected:Void()
    _message = "Reconnected!"
    addMessage( _message )
  End Method
  
  Method OnRealtimeNewMessage:Void( channelName:String, message:String )
    _message = "Message " + message + " sent on channel " + channelName
    addMessage( _message )
  End Method
  
  Method OnRealtimeClientConnected:Void( metadata:String )
    _message = "Client connected (metadata): " + metadata
    addMessage( _message )
  End Method

  Method OnRealtimeClientDisconnected:Void( metadata:String, typeOfDisconnect:Int )
    _message = "Client disconnected (metadata, type): " + metadata
    If( typeOfDisconnect = 0 )
      _message += ", normal"
    Else
      _message += ", timeout"
    End If
    addMessage( _message )
  End Method

  Method OnRealtimeClientSubscribed:Void( metadata:String, channelName:String )
    _message = "Client subscribed to " + channelName + ", metadata: " + metadata
    addMessage( _message )
  End Method

  Method OnRealtimeClientUnsubscribed:Void( metadata:String, channelName:String )
    _message = "Client unsubscribed from " + channelName + ", metadata: " + metadata
    addMessage( _message )
  End Method
End Class

Function Main:Int()
  New MyApp()
  Return 0
End