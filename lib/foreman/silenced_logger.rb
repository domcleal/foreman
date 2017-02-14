# Wrap a ::Logging::Logger and implement #silence to temporarily increase the
# min log level to execute a block of code. Used by sprockets-rails' quiet
# assets logging feature.
module Foreman
  class SilencedLogger < SimpleDelegator
    def silence(new_level = :error, &block)
      old_level = __getobj__.level
      begin
        __getobj__.level = new_level
        yield self
      ensure
        __getobj__.level = old_level
      end
    end
  end
end
