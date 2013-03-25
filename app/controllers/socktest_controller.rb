class SocktestController < WebsocketRails::BaseController
  def hallowelt
    send_message :broadcast, "this is server sending a normal message"
    WebsocketRails[:broadcast].trigger 'message', "Hallo Welt :) (client says: #{message})"
  end
end
