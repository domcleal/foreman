module Foreman
  class ParameterFilters
    attr_reader :resource_class

    def initialize(resource_class)
      @resource_class = resource_class
      @parameter_filters = []
    end

    def filter(params)
      ctx = Context.new(:ui) # FIXME
      @parameter_filters.each { |f| ctx.instance_eval(&f) }
      params.require(top_level_hash).permit(*ctx.filters)
    end

    def permit(*args, &block)
      opts = args.last.is_a?(Hash) ? args.pop : {:api => true, :ui => true, :nested => false} # FIXME: use these
      attrs = args.dup

      new_filter = if block_given?
                     block
                   else
                     ->(context) {
                       unless context.nested?
                         context.permit(*attrs)
                       end
                     }
                   end

      @parameter_filters << new_filter
    end

    private

    def top_level_hash
      resource_class.name.underscore
    end

    class Context
      attr_reader :filters

      def initialize(type)
        @type = type
        @filters = []
      end

      def api?
        @type == :api
      end

      def nested?
        false # FIXME
      end

      def ui?
        @type == :ui
      end

      def permit(*args)
        @filters.push(*args)
      end
    end
  end
end
