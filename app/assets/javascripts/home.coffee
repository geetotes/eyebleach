jQuery ->
  window.tvController = new Tv.Controller($('#tv').data('uri'), true)
window.Tv = {}

class Tv.Controller
  
  frameTemplate: (message) ->
    html =
      """
      <img src='data:image/gif;base64,#{message.msg_body}' class='frame' data-frame_no='#{message.frame_no}'/>
      """
    $(html)

  channelTemplate: (message) ->
    html =
      """
      <span>Channel Name: #{message.channel_name}</span>
      """
    $(html)

  constructor: (url, useWebSockets) ->
    @messageQueue = []
    @dispatcher = new WebSocketRails(url, useWebSockets)
    @dispatcher.on_open = @createUser
    @bindEvents()

  bindEvents: =>
    @dispatcher.bind 'greeting', @appendMessage
    @dispatcher.bind 'next_frame', @nextFrame
    @dispatcher.bind 'channel_info', @drawChannelInfo
    @dispatcher.bind 'channel_list', @setChannelList
    $('.channel').bind 'click', @changeChannel


#should set up the frame trigger and checks here?

  drawChannelInfo: (message) =>
    channelTemplate = @template(message)

  #this seems to be out true binding thing from server
  setChannelList: (message) =>
    @channelList = message.channels
    @currentChannel = @channelList[1]
    @frame_no = 0

    @dispatcher.trigger 'next_frame', {frame_no: @frame_no, channel_name: @currentChannel}

  changeChannel: (event) =>
    event.preventDefault()
    index = @channelList.indexOf(@currentChannel)
    if @channelList[index + 1] == undefined
      @currentChannel = @channelList[0]
    else
      @currentChannel = @channelList[index + 1]
    @frame_no = 0
    #clear every thing out
    $('#tv').html('')
    setTimeout ->
      console.log('waiting')
    ,1000

    #console.log($('.frame').length)
    #@dispatcher.trigger 'next_frame', {frame_no: 0, channel_name: @currentChannel}
    #change channel client side, reset fame number (just dispatch the event, dispatching the event does not work; need to find a way to send frame 0 to socket)


  nextFrame: (message) =>
    #console.log("Total frames: " + message.total_frames + " length of dom: " + $('.frame').length)
    #keep from the dom overfilling with frames
    while($('#' + message.chanel_name + ' .frame').length > (message.total_frames))
      $('#' + message.channel_name + ' .frame').first().remove()

    frame = @frameTemplate(message)

#check for existing channel container
    
    if ($('#tv').children('.' + message.channel_name).length == 0)
      $('#tv').append('<div id="' + message.channel_name '"></div>')

    $('#tv').children('#' + message.channel_name).append frame

    @frame_no = message.frame_no + 1
    @dispatcher.trigger 'next_frame', {frame_no: @frame_no, channel_name: @currentChannel}

  appendMessage: (message) =>
    console.log(message)
    imageTemplate = @frameTemplate(message)
    $('#tv').append imageTemplate
    $('#tv').append message.msg_body


  createUser: =>
    @dispatcher.trigger 'get_channels'


jQuery(window).load ->
  $container = $('#container')
  $container.masonry columnWidth: 500, itemSelector: '.item'
