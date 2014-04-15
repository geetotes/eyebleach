class TvController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session init!"
  end

  def system_msg(ev, msg)
    broadcast_message ev, { 
      user_name: 'system', 
      received: Time.now.to_s(:short), 
      msg_body: msg
    }
  end

  def hello
    puts "hello"
  end

  def client_disconnected
    puts "goodbye"
  end

  def client_connected
    system_msg :greeting, "client #{client_id} connected"
    puts "client #{client_id} connected"
  end
end
