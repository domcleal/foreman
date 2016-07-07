# Stores permitted parameters for a given resource/AR model for use in
# controllers to filter input parameters.
#
# Allows the permitted parameters to be set up once model and re-used in
# multiple contexts, e.g. API controllers, UI controllers and nested UI
# attributes, by applying different rules.
#
module Foreman
  class ParameterFilters
    attr_reader :resource_class

    def initialize(resource_class)
      @resource_class = resource_class
      @parameter_filters = []

      Foreman::Plugin.all.each do |plugin|
        plugin.parameter_filters(resource_class).each { |filter| permit(*filter) }
      end

      # Permit all attributes using deprecated attr_accessible, both as scalar or array
      permit(resource_class.legacy_accessible_attributes, :nested => true)
      permit(Hash[resource_class.legacy_accessible_attributes.map { |a| [a,[]] }], :nested => true)
    end

    # Return a list of permitted parameters that may be passed into #permit
    def filter(context_type)
      ctx = Context.new(context_type)
      @parameter_filters.each { |f| ctx.instance_eval(&f) }
      ctx.filters.map { |f| expand_nested(f) }
    end

    # Runs permitted parameter whitelist against supplied parameters
    def filter_params(params, *context_args)
      params.require(top_level_hash).permit(filter(*context_args))
    end

    # Registers new whitelisted parameter(s) in the same form as
    # ActionController::Parameters#permit, plus can accept a ParametersFilter
    # instance for nested models which is expanded.
    #
    # Last argument of a hash determines which contexts the parameter may be
    # used in, or a block can be passed to determine it dynamically from the
    # Context class.
    def permit(*args, &block)
      opts = {:api => true, :nested => false, :ui => true}
      opts.merge!(args.pop) if args.last.is_a?(Hash) && args.count >= 2
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
      if filter.is_a?(ParameterFilters)
        filter.filter(:nested)
      elsif filter.is_a?(Hash)
        filter.transform_values { |v| expand_nested(v) }
      elsif filter.is_a?(Array)
        filter.map { |v| expand_nested(v) }
      else
        filter
      end
    end

    def top_level_hash
      resource_class.name.underscore
    end

    # Public API for blocks passed into #permit, allowing them to inspect the
    # context of the request and permit/deny different parameters
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

      # Accepts same arguments as ActionController::Parameters#permit, plus can
      # accept a ParametersFilter instance for nested models which is expanded
      def permit(*args)
        @filters.push(*args)
      end
    end
  end
end
