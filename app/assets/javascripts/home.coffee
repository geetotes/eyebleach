jQuery ->
  window.tvController = new Tv.Controller($('#tv').data('uri'), true)
window.Tv = {}

class Tv.Controller
  constructor: (url, useWebSockets) ->
    @messageQueue = []
    @dispatcher = new WebSocketRails(url, useWebSockets)
    @dispatcher.on_open = @createUser
    @bindEvents()

  bindEvents: =>
    @dispatcher.bind 'greeting', @appendMessage

  appendMessage: (message) =>
    console.log(message)
    $('#tv').append message

  createUser: =>
    @dispatcher.trigger 'hello'
    console.log('user created')


jQuery(window).load ->
  $container = $('#container');
  $container.masonry columnWidth: 500, itemSelector: '.item'
