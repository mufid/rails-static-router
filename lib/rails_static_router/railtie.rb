module RailsStaticRouter
  class Railtie < Rails::Railtie
    initializer 'rails_static_router.railtie' do
      require 'action_dispatch/routing/static_responder'
    end
  end
end
