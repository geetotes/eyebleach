$(window).load ->
  $container = $('#container');
  $container.masonry columnWidth: 200, itemSelector: '.item'
