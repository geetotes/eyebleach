jQuery ->
  window.tvController = new Tv.Controller($('#tv').data('uri'), true)
window.Tv = {}

class Tv.Controller
  
  template: (message) ->
    html =
      """
      <img src='data:image/gif;base64,#{message.msg_body}' class='frame' data-frame_no='#{message.frame_no}'/>
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
    $('#next_channel').click @changeChannel

  nextFrame: (message) =>
    if ($('.frame').length == 73)
      $('.frame').remove()
    frame = @template(message)
    $('#tv').append frame
    #get the frame number
    frame_no = $('.frame').first().data('frame_no')
    #then increment
    frame_no = message.frame_no + 1
    @dispatcher.trigger 'next_frame', {frame_no: frame_no}

  appendMessage: (message) =>
    console.log(message)
    imageTemplate = @template(message)
    $('#tv').append imageTemplate
    $('#tv').append message.msg_body


  createUser: =>
    @dispatcher.trigger 'start_frame', {frame_no: 0}
    console.log('user created')


jQuery(window).load ->
  $container = $('#container')
  $container.masonry columnWidth: 500, itemSelector: '.item'
