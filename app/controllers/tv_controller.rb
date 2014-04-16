class TvController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session init!"
  end

  def frame_message(ev, msg)
    broadcast_message ev, { 
      msg_body: msg
    }
  end

  #needs to take frame num as param
  def next_frame(framenum)
    #image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/kitty-#{framenum}.jpg").read)
    frame_message :new_frame, image
  end

  def client_disconnected
    puts "goodbye"
  end

  def client_connected
    image = Base64.encode64(File.open("/home/lee/src/eyebleach/baby-duck.jpg").read)
    
    frame_message :greeting, image
    puts "client #{client_id} connected"
  end
end
