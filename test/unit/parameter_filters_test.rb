require 'test_helper'

class ParameterFiltersTest < ActiveSupport::TestCase
  let(:legacy_accessible_attributes) { [] }
  let(:klass) do
    mock('Example').tap do |k|
      k.stubs(:name).returns('Example')
      k.stubs(:legacy_accessible_attributes).returns(legacy_accessible_attributes)
    end
  end
  let(:filters) { Foreman::ParameterFilters.new(klass) }
  let(:ui_context) { Foreman::ParameterFilters::Context.new(:ui, 'examples', 'create') }

  test "permitting second-level attributes via permit(Symbol)" do
    filters.permit(:test)
    assert_equal({'test' => 'a'}, filters.filter_params(params(:example => {:test => 'a', :denied => 'b'}), ui_context))
  end

  test "permitting second-level attributes via block" do
    filters.permit { |ctx| ctx.permit(:test) }
    assert_equal({'test' => 'a'}, filters.filter_params(params(:example => {:test => 'a', :denied => 'b'}), ui_context))
  end

  test "block contains controller/action names" do
    filters.permit do |ctx|
      ctx.controller_name == 'examples' or raise 'controller is not "examples"'
      ctx.action == 'create' or raise 'action is not "create"'
    end
    filters.filter_params(params(:example => {:test => 'a'}), ui_context)
  end

  test "permitting second-level arrays via permit(Symbol => Array)" do
    filters.permit(:test => [])
    assert_equal({}, filters.filter_params(params(:example => {:test => 'a'}), ui_context))
    assert_equal({'test' => ['a']}, filters.filter_params(params(:example => {:test => ['a']}), ui_context))
  end

  test "permitting third-level attributes via permit(Symbol => Array[Symbol])" do
    filters.permit(:test => [:inner])
    assert_equal({'test' => {'inner' => 'a'}}, filters.filter_params(params(:example => {:test => {:inner => 'a', :denied => 'b'}}), ui_context))
  end

  test "blocks second-level attributes for UI when :ui => false" do
    filters.permit(:test, :ui => false)
    assert_equal({}, filters.filter_params(params(:example => {:test => 'a'}), ui_context))
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
      assert_equal({'test' => 'a', 'nested' => [{'inner' => 'b'}]}, filters.filter_params(params(:example => {:test => 'a', :nested => [{:inner => 'b', :ui_only => 'b'}]}), ui_context))
      assert_equal({'test' => 'a', 'nested' => {'123' => {'inner' => 'b'}}}, filters.filter_params(params(:example => {:test => 'a', :nested => {'123' => {:inner => 'b', :ui_only => 'b'}}}), ui_context))
    end

    test "second filter block has access to original controller/action" do
      filters2.permit do |ctx|
        ctx.controller_name == 'examples' or raise 'controller is not "examples"'
        ctx.action == 'create' or raise 'action is not "create"'
      end
      filters.permit(:test, {:nested => [filters2]}, {}) # FIXME, third parameter!
      filters.filter_params(params(:example => {:test => 'a', :nested => [{:inner => 'b'}]}), ui_context)
    end
  end

  context "with legacy accessible attributes" do
    let(:legacy_accessible_attributes) { [:legacy] }

    test "permits legacy attribute" do
      assert_equal({'legacy' => 'b'}, filters.filter_params(params(:example => {:test => 'a', :legacy => 'b'}), ui_context))
    end

    test "permits legacy attribute with an array" do
      assert_equal({'legacy' => ['b']}, filters.filter_params(params(:example => {:test => 'a', :legacy => ['b']}), ui_context))
    end
  end

  context "with plugin registered filters" do
    test "permits plugin-added attribute" do
      plugin = mock('plugin')
      plugin.expects(:parameter_filters).with(klass).returns([[:plugin_ext, :ui =>true]])
      Foreman::Plugin.expects(:all).returns([plugin])
      assert_equal({'plugin_ext' => 'b'}, filters.filter_params(params(:example => {:test => 'a', :plugin_ext => 'b'}), ui_context))
    end

    test "permits plugin-added attributes from blocks" do
      plugin = mock('plugin')
      plugin.expects(:parameter_filters).with(klass).returns([[Proc.new { |ctx| ctx.permit(:plugin_ext) }]])
      Foreman::Plugin.expects(:all).returns([plugin])
      assert_equal({'plugin_ext' => 'b'}, filters.filter_params(params(:example => {:test => 'a', :plugin_ext => 'b'}), ui_context))
    end
  end

  private

  def params(p)
    ActionController::Parameters.new(p)
  end
end
