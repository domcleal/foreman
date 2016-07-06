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

  private

  def params(p)
    ActionController::Parameters.new(p)
  end
end
