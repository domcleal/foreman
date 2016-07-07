require 'test_helper'

class ParameterFiltersTest < ActiveSupport::TestCase
  let(:klass) do
    mock('Example').tap do |k|
      k.stubs(:name).returns('Example')
      k.stubs(:legacy_accessible_attributes).returns([])
    end
  end
  let(:filters) { Foreman::ParameterFilters.new(klass) }

  test "permitting second-level attributes via permit(Symbol)" do
    filters.permit(:test)
    assert_equal({'test' => 'a'}, filters.filter_params(params(:example => {:test => 'a', :denied => 'b'}), :ui))
  end

  test "permitting second-level attributes via block" do
    filters.permit { |ctx| ctx.permit(:test) }
    assert_equal({'test' => 'a'}, filters.filter_params(params(:example => {:test => 'a', :denied => 'b'}), :ui))
  end

  test "permitting second-level arrays via permit(Symbol => Array)" do
    filters.permit(:test => [])
    assert_equal({}, filters.filter_params(params(:example => {:test => 'a'}), :ui))
    assert_equal({'test' => ['a']}, filters.filter_params(params(:example => {:test => ['a']}), :ui))
  end

  test "permitting third-level attributes via permit(Symbol => Array[Symbol])" do
    filters.permit(:test => [:inner])
    assert_equal({'test' => {'inner' => 'a'}}, filters.filter_params(params(:example => {:test => {:inner => 'a', :denied => 'b'}}), :ui))
  end

  test "blocks second-level attributes for UI when :ui => false" do
    filters.permit(:test, :ui => false)
    assert_equal({}, filters.filter_params(params(:example => {:test => 'a'}), :ui))
  end

  context "with nested object" do
    let(:klass2) do
      mock('Example').tap do |k|
        k.stubs(:name).returns('Example')
        k.stubs(:legacy_accessible_attributes).returns([])
      end
    end
    let(:filters2) { Foreman::ParameterFilters.new(klass2) }

    test "permits nested attribute through second filter" do
      filters2.permit(:inner, :nested => true)
      filters2.permit(:ui_only)
      filters.permit(:test, {:nested => [filters2]}, {}) # FIXME, third parameter!
      assert_equal({'test' => 'a', 'nested' => [{'inner' => 'b'}]}, filters.filter_params(params(:example => {:test => 'a', :nested => [{:inner => 'b', :ui_only => 'b'}]}), :ui))
    end
  end

  private

  def params(p)
    ActionController::Parameters.new(p)
  end
end
