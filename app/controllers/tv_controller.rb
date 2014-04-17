class TvController < WebsocketRails::BaseController
  include ActionView::Helpers::SanitizeHelper

  def initialize_session
    puts "Session init!"

  end

  def create_channel_list
    @channels = {}
    Dir.foreach('/home/lee/src/eyebleach/test_images/') do |filename|
      if filename !~ /[a-z0-9]*frame\d*.gif/i #no frames!!!
        if filename != "." && filename != ".." #no directories!
        @channels[File.basename("/home/lee/src/eyebleach/test_images/#{filename}", '.gif')] = 0
        end
      end
    end
    #lets make our lists
  end

  def do_frame_lookup
    @channels.each_key do |channel|
      #re = Regexp.new("#{channel}\d")
      totalFrames = -1
      Dir.foreach('/home/lee/src/eyebleach/test_images/') do |filename|
        if filename.match(/#{channel}-frame\d*/) != nil
          totalFrames += 1
        end
      end
      @channels[channel] = totalFrames
    end
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
    #populate our @channels instance vaiable
    create_channel_list
    do_frame_lookup

    if File.exist?("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}-frame#{message[:frame_no]}.gif")
      image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}-frame#{message[:frame_no]}.gif").read)
      frame_message :next_frame, image, message[:frame_no], @channels[message[:channel_name]], message[:channel_name]
    else
      image = Base64.encode64(File.open("/home/lee/src/eyebleach/test_images/#{message[:channel_name]}-frame0.gif").read)
      frame_message :next_frame, image, 0, @channels[message[:channel_name]], message[:channel_name]
    end
  end

  def get_channels
    create_channel_list
    chan_list = []
    @channels.each_key do |channel|
      chan_list << channel
    end
    channel_list :channel_list, chan_list
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
