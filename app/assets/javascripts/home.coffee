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

  drawChannelInfo: (message) =>
    channelTemplate = @template(message)

  setChannelList: (message) =>
    @channelList = message.channels
    @currentChannel = @channelList[0]
    @dispatcher.trigger 'next_frame', {frame_no: 0, channel_name: @currentChannel}
    console.log('user created')

  changeChannel: (event) =>
    event.preventDefault()
    index = @channelList.indexOf(@currentChannel)
    if @channelList[index + 1] == undefined
      @currentChannel = @channelList[0]
    else
      @currentChannel = @channelList[index + 1]
    #clear every thing out
    $('.frame').remove()
    @dispatcher.trigger 'next_frame', {frame_no: 0, channel_name: @currentChannel}
#change channel client side, reset fame number (just dispatch the event)


  nextFrame: (message) =>
    console.log(message.total_frames)
    #keep from the dom overfilling with frames
    
    while($('.frame').length > message.total_frames)
      $('.frame').first().remove()
    #if ($('.frame').length == 146)
      #$('.frame').remove()
    frame = @frameTemplate(message)
    $('#tv').append frame
    #get the frame number
    frame_no = $('.frame').first().data('frame_no')
    #then increment
    frame_no = message.frame_no + 1
    @dispatcher.trigger 'next_frame', {frame_no: frame_no, channel_name: @currentChannel}

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
