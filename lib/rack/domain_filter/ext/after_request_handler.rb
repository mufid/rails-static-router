module Rack
  class DomainFilter
    module AfterRequestHandler
      def run_after_request
        config.after_requests_list.each do |block|
          block.call
        end
      end
    end
  end
end
