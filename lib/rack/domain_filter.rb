module Rack
  class DomainFilter
    def initialize(app, options={})
      @app = app
      @config = options[:config] || DomainFilter.global_configuration
    end

    def call(env)
      match_uri(env)

      if !@match_found && can_respond_no_match?
        result = trigger_no_match(env)
        run_after_request
        return result
      end

      result = @app.call(env)

      run_after_request

      result
    rescue => e
      result = catch_exception(e)
      run_after_request

      result
    end

    include ExceptionHandler
    include AfterRequestHandler
    include Matcher

    def self.configure
      @global_configuration ||= Configuration.new

      yield @global_configuration
    end

    def self.clear_configuration!
      @global_configuration = nil
    end

    def self.global_configuration
      @global_configuration
    end

    def config
      @config
    end
    def verify_configuration!

    end
  end
end
