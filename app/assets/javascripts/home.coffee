$(window).load ->
  $container = $('#container');
  $container.masonry columnWidth: 500, itemSelector: '.item'
