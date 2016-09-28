require 'test_helper'

class BelongsToProxiesTest < ActiveSupport::TestCase
  class SampleModel
    include BelongsToProxies

    class << self
      def belongs_to(name, options = {})
      end
    end

    belongs_to_proxy :foo, :feature => 'Foo'
  end

  setup do
    @sample = SampleModel.new
    Foreman::Plugin.clear
  end

  teardown do
    Foreman::Plugin.clear
  end

  test '#smart_proxies contains foo proxy' do
    assert_equal({:foo => {:feature => 'Foo'}}, @sample.smart_proxies)
  end

  test '#smart_proxies contains foo proxy and bar proxy from plugin' do
    Foreman::Plugin.register :test_smart_proxy do
      name 'Smart Proxy test'
      smart_proxy_for SampleModel, :bar, :feature => 'Bar'
    end
    expected = {
      :foo => {:feature => 'Foo'},
      :bar => {:feature => 'Bar'}
    }
    assert_equal expected, @sample.smart_proxies
  end
end
