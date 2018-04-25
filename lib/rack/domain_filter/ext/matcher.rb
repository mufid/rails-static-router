module Rack
  module DomainFilter
    module Matcher
      # See https://www.youtube.com/watch?v=b77V0rkr5rk
      # Use host_with_port for better performance
      # See: https://github.com/rack/rack/blob/master/lib/rack/request.rb
      def match_uri(env)
        req = Rack::Request.new(env)
        config.uri_mapping.each_pair do |pattern, block|
          if pattern.is_a?(String)
            break if match_string(pattern, req, block)
          elsif pattern.is_a?(Regexp)
            break if match_regex(pattern, req, block)
          else
            raise "Unknown pattern: #{pattern}. It must be a regex or a string!"
          end
        end
      end

      def can_respond_no_match?
        !config.no_match_block.nil?
      end

      def trigger_no_match(env)
        config.no_match_block.call(env)
      end

      def match_regex(regex, req, block)
        matchdata = req.host_with_port.match(regex)
        return if matchdata.nil?

        block.call(matchdata[1], req.env)

        @match_found = true

        true
      end

      def match_string(string, req, block)
        return if string != req.host_with_port

        block.call(req.env)

        @match_found = true

        true
      end
    end
  end
end
