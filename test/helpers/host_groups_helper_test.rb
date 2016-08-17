require 'test_helper'

class HostGroupsHelperTest < ActionView::TestCase
  include PuppetRelatedHelper
  include HostsAndHostgroupsHelper
  include ApplicationHelper
  include HostsHelper
  include ::FormHelper

  test "should have the full string of the parent class if the child is a substring" do
    test_group = Hostgroup.create(:name => "test/st")
    stubs(:hash_for_edit_hostgroup_path).returns(controller: 'hostgroups', action: 'edit')
    stubs(:url_for).returns('/some/url')
    assert_match /test\/st/, label_with_link(test_group)
    refute_match /te\/st/, label_with_link(test_group)
  end

  describe 'puppet environment field' do
    setup do
      @host = mock('host')
      @host.stubs(:hostgroup)
      @host.stubs(:id).returns(999)
      @f = mock('f')
      @f.stubs(:object).returns(@host)
    end
    test 'it adds new first level attributes' do
      @f.expects(:collection_select).with do |attr, array, id, method, select_options, html_options|
        select_options[:test_select_option] == 'test_value1' &&
        html_options[:test_html_option] == 'test_value2'
      end

      host_puppet_environment_field(@f, { :test_select_option => 'test_value1' }, { :test_html_option => 'test_value2' })
    end

    test 'it adds new data attributes' do
      @f.expects(:collection_select).with do |attr, array, id, method, select_options, html_options|
        select_options[:test_select_option] == 'test_value1' &&
        html_options[:data][:test] == 'test_value2'
      end

      host_puppet_environment_field(@f, { :test_select_option => 'test_value1' }, { :data => { :test => 'test_value2' }})
    end

    test 'it overrides existing attributes' do
      @f.expects(:collection_select).with do |attr, array, id, method, select_options, html_options|
        html_options[:data][:test] == 'some_test_value' &&
        html_options[:data][:url] == '/test/url'
      end.returns('')

      html = host_puppet_environment_field(@f, { :disable_button => false }, { :data => { :url => '/test/url', :test => 'some_test_value' }})

      refute_match /btn/, html
    end
  end
end
