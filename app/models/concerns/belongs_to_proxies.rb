module BelongsToProxies
  extend ActiveSupport::Concern

  delegate :smart_proxies, :to => :class
  included do
    class_attribute :smart_proxies_from_model
  end

  module ClassMethods
    def belongs_to_proxy(name, options)
      register_smart_proxy(name, options)
      self.smart_proxies_from_model = (smart_proxies_from_model || {}).merge(name => options)
    end

    def smart_proxies
      (smart_proxies_from_model || {}).merge(smart_proxies_from_plugins)
    end

    def register_smart_proxy(name, options)
      belongs_to name, :class_name => 'SmartProxy'
      validates name, :proxy_features => { :feature => options[:feature] }
    end

    private

    def smart_proxies_from_plugins
      Foreman::Plugin.all.map {|plugin| plugin.smart_proxies(self) }.inject({}, :merge)
    end
  end
end
