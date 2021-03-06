WebsocketRails.setup do |config|
  config.log_internal_events = true
  config.standalone = false
  config.synchronize = false
end

WebsocketRails::EventMap.describe do
  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
  subscribe :client_connected, :to => TvController, :with_method => :client_connected
  subscribe :client_disconnected, :to => TvController, :with_method => :client_disconnected
  subscribe :next_frame, :to => TvController, :with_method => :next_frame
  subscribe :change_channel, :to => TvController, :with_method => :change_channel
  subscribe :get_channels, :to => TvController, :with_method => :get_channels
end
