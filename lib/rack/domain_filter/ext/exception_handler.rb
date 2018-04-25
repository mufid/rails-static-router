module Rack
  class DomainFilter
    module ExceptionHandler
      def catch_exception(e)
        config.exception_catcher_mapping.each_pair do |klazz, block|
          if e.is_a?(klazz)
            return block.call(e)
          end
        end

        raise e
      end
    end
  end
end
