require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dummy
  class Application < Rails::Application
    if Rails.version.match('8.0')
      config.load_defaults 8.0
    elsif Rails.version.match('7.1')
      config.load_defaults 7.1
    elsif Rails.version.match('7.0')
      config.load_defaults 7.0
    elsif Rails.version.match('6.1')
      config.load_defaults 6.1
    elsif Rails.version.match('6.0')
      config.load_defaults 6.0
    elsif Rails.version.match('5.2')
      config.load_defaults 5.2
    elsif Rails.version.match('5.1')
      config.load_defaults 5.1
    end
  end
end
