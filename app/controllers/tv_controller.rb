class TvController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session init!"

  end

  def create_channel_list
    @channels = []
    Dir.foreach('/home/lee/src/eyebleach/test_images/') do |filename|
      if filename.match(/[a-z].gif/) != nil #no digits!!!
        @channels << File.basename("/home/lee/src/eyebleach/test_images/#{filename}", '.gif')
      end
    end
    #lets make our lists
  end

  def frame_message(ev, msg, frame_no, total_frames, channel_name)
    broadcast_message ev, { 
      msg_body: msg,
      frame_no: frame_no,
      total_frames: total_frames,
      channel_name: channel_name
    }
  end

  def channel_list(ev, channels)
    broadcast_message ev, {
      channels: channels
    }
  end

  #needs to take frame num as param
  def next_frame
    #we should also look at channel number
    if File.exist?("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}#{message[:frame_no]}.gif")
      image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}#{message[:frame_no]}.gif").read)
      frame_message :next_frame, image, message[:frame_no], 72, 'kitty'
    else
      image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}0.gif").read)
      frame_message :next_frame, image, 0, 72, 'kitty'
    end
  end

  def get_channels
    create_channel_list
    channel_list :channel_list, @channels
  end

  def change_channel
    puts 'changing channel'
    #need to store current channel in connection data
    
  end

  def client_disconnected
    puts "goodbye"
  end

  def client_connected
    puts "client #{client_id} connected"
    #lets make our lists

  end
end
