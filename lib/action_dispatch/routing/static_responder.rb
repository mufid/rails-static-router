# Example use:
#
# Rails.application.routes.draw do
#   ...
#   # This route will serve public/index.html at the /login URL path, and have
#   # URL helper named `login_path`:
#   get "/login", to: static("index.html")
#
#   # This route will serve public/index.html at the /register URL path, and
#   # have URL helper named `new_user_registration_path`:
#   get "/register", to: static("index.html"), as: :new_user_registration
#   ...
# end
#
# `bin/rake routes` output for the above routes:
#
#                Prefix  Verb  URI Pattern          Controller#Action
#                 login  GET   /login(.:format)     static('index.html')
# new_user_registration  GET   /register(.:format)  static('index.html')
#
#
# Why?
#
# static(path_to_file) helper method used to route to static files
# from within routes.rb. Inspired by Rails' existing redirect(...) method.
#
# Some benefits of this technique over alternatives (such as rack-rewrite,
# nginx/httpd-configured rewrites):
#
# - Named URL helper method for static file available throughout app, for
#   example in mail templates, view templates, and tests.
#
# - Route discoverable via `bin/rake routes` and Routing Error page in development.
#
# - Takes advantage of ActionDispatch's built-in gzip handling. Controller action
#   based solutions for rendering static files tend to not use this.
#
# - Handy for Single Page Apps that serve the same static HTML file for multiple
#   paths, as is often the case with Ember & Angular apps.
#
# - Heroku-like production environments work with this that do use the Rails app
#   to serve static files.
#
# - Leaves door open for nginx, Apache, Varnish and friends to serve the static
#   files directly for improved performance in production environments via symlinks
#   and/or other artifacts generated at deploy time.
#
module ActionDispatch
  module Routing
    if Gem::Version.new(Rails.version) >= Gem::Version.new('4.2')
      class StaticResponder < Endpoint; end
    else
      class StaticResponder; end
    end

    if Gem::Version.new(Rails.version) >= Gem::Version.new('5.0')
      class StaticResponder
        def file_handler
          @file_handler ||= ActionDispatch::FileHandler.new(
            Rails.configuration.paths["public"].first
          )
        end
      end
    else
      class StaticResponder
        def file_handler
          @file_handler ||= ActionDispatch::FileHandler.new(
            Rails.configuration.paths["public"].first,
            Rails.configuration.static_cache_control
          )
        end
      end
    end

    class StaticResponder

      attr_accessor :path

      def initialize(path)
        self.path = path
        self.trigger_file_handler_initialization
      end

      def trigger_file_handler_initialization
        file_handler
      end

      def call(env)
        env["PATH_INFO"] = @file_handler.match?(path)
        @file_handler.call(env)
      end

      def inspect
        "static('#{path}')"
      end

    end

    class Mapper
      def static(path)
        StaticResponder.new(path)
      end
    end
  end
end
