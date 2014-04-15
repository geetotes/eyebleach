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
    image = Base64.encode64(File.open("/home/lee/src/eyebleach/baby-duck.jpg").read)
    
    system_msg :greeting, image
    puts "client #{client_id} connected"
  end
end
