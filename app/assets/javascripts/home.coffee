jQuery ->
  window.tvController = new Tv.Controller($('#tv').data('uri'), true)
window.Tv = {}

class Tv.Controller
  
  template: (message) ->
    html =
      """
      <img src='data:image/jpg;base64,#{message.msg_body}'/>
      """
    $(html)

  constructor: (url, useWebSockets) ->
    @messageQueue = []
    @dispatcher = new WebSocketRails(url, useWebSockets)
    @dispatcher.on_open = @createUser
    @bindEvents()

  bindEvents: =>
    @dispatcher.bind 'greeting', @appendMessage

  appendMessage: (message) =>
    console.log(message)
    imageTemplate = @template(message)
    $('#tv').append imageTemplate
    $('#tv').append message.msg_body


  createUser: =>
    @dispatcher.trigger 'hello'
    console.log('user created')


jQuery(window).load ->
  $container = $('#container');
  $container.masonry columnWidth: 500, itemSelector: '.item'
