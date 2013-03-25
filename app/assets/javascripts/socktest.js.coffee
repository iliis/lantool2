$ ->
  dispatcher = new WebSocketRails('localhost:3000/websocket')
  dispatcher.trigger('hallowelt', "Hello Rails. Yes, this is JavaScript.")

  dispatcher.bind('broadcast', (msg) -> alert('server says: '+msg))

  channel = dispatcher.subscribe('broadcast')
  channel.bind('message', (msg) -> alert('BROADCAST: server says: '+msg))
