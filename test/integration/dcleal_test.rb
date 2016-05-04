require 'integration_test_helper'
require 'integration/shared/host_finders'
require 'integration/shared/host_orchestration_stubs'

class DclealTest < IntegrationTestWithJavascript
  include HostFinders
  include HostOrchestrationStubs

  before do
    SETTINGS[:locations_enabled] = false
    SETTINGS[:organizations_enabled] = false
    as_admin { @host = FactoryGirl.create(:host, :with_puppet, :managed) }
  end

  after do
    SETTINGS[:locations_enabled] = true
    SETTINGS[:organizations_enabled] = true
  end

  describe "hosts index multiple actions" do
    20.times do |i|
      test "show action buttons #{i}" do
        MyLogger.write("show action buttons #{i}")
        MyLogger.write("  cookies=#{get_me_the_cookies.inspect}")
        visit hosts_path
        save_screenshot("/tmp/14865_screenshot_#{$$}_#{i}.png")
        MyLogger.write("  click#{i}")
        page.find('#check_all').trigger('click')
        #MyLogger.write("  click#{i}=#{page.find('#check_all').click.inspect}")
        #assert page.find('input.host_select_boxes').checked?
        unless page.has_no_selector?('input.host_select_boxes:not(:checked)')
          assert false, "failed on #{$$} #{i}"
        end
      end
    end
  end
end
