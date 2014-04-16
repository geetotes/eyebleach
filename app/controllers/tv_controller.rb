class TvController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session init!"
  end

  def frame_message(ev, msg, frame_no)
    broadcast_message ev, { 
      msg_body: msg,
      frame_no: frame_no
    }
  end

  #needs to take frame num as param
  def next_frame
    image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/frame#{message[:frame_no]}.gif").read)
    frame_message :next_frame, image, message[:frame_no]
  end

  def hello
    puts "hello"
  end

  def client_disconnected
    puts "goodbye"
  end

  def client_connected
    #image = Base64.#encode64(File.open("/home/lee/src/eyebleach/baby-duck.jpg").read)
    
    #frame_message :greeting, image, 0u
    puts "client #{client_id} connected"
  end
end
