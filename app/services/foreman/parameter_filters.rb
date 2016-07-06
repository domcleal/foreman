module Foreman
  class ParameterFilters
    attr_reader :resource_class

    def initialize(resource_class)
      @resource_class = resource_class
      @parameter_filters = []
    end

    def filter(context_type)
      ctx = Context.new(context_type)
      @parameter_filters.each { |f| ctx.instance_eval(&f) }
      ctx.filters.map { |f| expand_nested(f) }
    end

    def filter_params(context_type, params)
      params.require(top_level_hash).permit(filter(context_type))
    end

    def permit(*args, &block)
      opts = (args.last.is_a?(Hash) && args.count >= 2) ? args.pop : {}
      opts[:api] = true if opts[:api].nil?
      opts[:nested] = false if opts[:nested].nil?
      opts[:ui] = true if opts[:ui].nil?
      attrs = args.dup

      new_filter = if block_given?
                     block
                   else
                     ->(context) { context.permit(*attrs) if opts[context.type] }
                   end

      @parameter_filters << new_filter
    end

    private

    def expand_nested(filter)
      return filter.filter(:nested) if filter.is_a?(ParameterFilters)

      if filter.is_a?(Hash)
        Hash[filter.map { |k,v| [k, expand_nested(v)] }]
      elsif filter.is_a?(Array)
        filter.map { |v| expand_nested(v) }
      else
        filter
      end
    end

    def top_level_hash
      resource_class.name.underscore
    end

    class Context
      attr_reader :filters, :type

      def initialize(type)
        @type = type
        @filters = []
      end

      def api?
        @type == :api
      end

      def nested?
        @type == :nested
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
