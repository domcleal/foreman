require 'test_helper'

class ParameterFiltersTest < ActiveSupport::TestCase
  let(:klass) do
    mock('Example').tap { |k| k.stubs(:name).returns('Example') }
  end
  let(:filters) { Foreman::ParameterFilters.new(klass) }

  test "permitting second-level attributes via permit(Symbol)" do
    filters.permit(:test)
    assert_equal({'test' => 'a'}, filters.filter(params(:example => {:test => 'a', :denied => 'b'})))
  end

  test "permitting second-level attributes via block" do
    filters.permit { |ctx| ctx.permit(:test) }
    assert_equal({'test' => 'a'}, filters.filter(params(:example => {:test => 'a', :denied => 'b'})))
  end

  test "permitting second-level attributes via permit(Symbol => Array)" do
    filters.permit(:test => [])
    assert_equal({}, filters.filter(params(:example => {:test => 'a'})))
    assert_equal({'test' => ['a']}, filters.filter(params(:example => {:test => ['a']})))
  end

  test "blocks second-level attributes for UI when :ui => false" do
    filters.permit(:test, :ui => false)
    assert_equal({}, filters.filter(params(:example => {:test => 'a'})))
  end

  private

  def params(p)
    ActionController::Parameters.new(p)
  end
end
