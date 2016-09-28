class ProxyFeaturesValidator < ActiveModel::EachValidator
  def initialize(args)
    @options = args
    super
  end

  def validate_each(record, attribute, value)
    if value && !value.has_feature?(@options[:feature])
      record.errors["#{attribute}_id"] << _('does not have the %s feature') % @options[:feature]
    end
  end
end
