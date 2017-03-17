require 'test_helper'
require 'controllers/shared/report_host_permissions_test'

class ConfigReportsControllerTest < ActionController::TestCase
  include ::ReportHostPermissionsTest

  def test_index
    FactoryGirl.create(:config_report)
    get :index, session: set_session_user
    assert_response :success
    assert_not_nil assigns('config_reports')
    assert_template 'index'
  end

  test 'csv export works' do
    FactoryGirl.create(:config_report)
    get :index, format: :csv, session: set_session_user
    assert_response :success
    assert_equal 2, response.body.lines.size
  end

  def test_show
    report = FactoryGirl.create(:config_report)
    get :show, params: { :id => report.id }, session: set_session_user
    assert_template 'show'
  end

  test '404 on show when id is blank' do
    get :show, params: { :id => ' ' }, session: set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  def test_show_last
    FactoryGirl.create(:config_report)
    get :show, params: { :id => "last" }, session: set_session_user
    assert_template 'show'
  end

  test '404 on last when no reports available' do
    get :show, params: { :id => 'last', :host_id => FactoryGirl.create(:host) }, session: set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  def test_show_last_report_for_host
    report = FactoryGirl.create(:config_report)
    get :show, params: { :id => "last", :host_id => report.host.to_param }, session: set_session_user
    assert_template 'show'
  end

  def test_render_404_when_invalid_report_for_a_host_is_requested
    get :show, params: { :id => "last", :host_id => "blalala.domain.com" }, session: set_session_user
    assert_response :missing
    assert_template 'common/404'
  end

  def test_destroy
    report = FactoryGirl.create(:config_report)
    delete :destroy, params: { :id => report }, session: set_session_user
    assert_redirected_to config_reports_url
    assert !ConfigReport.exists?(report.id)
  end

  test "should show report" do
    create_a_report
    assert @report.save!

    get :show, params: { :id => @report.id }, session: set_session_user
    assert_response :success
  end

  test "should destroy report" do
    create_a_report
    assert @report.save!

    assert_difference('ConfigReport.count', -1) do
      delete :destroy, params: { :id => @report.id }, session: set_session_user
    end

    assert_redirected_to config_reports_path
  end

  test 'cannot view the last report without hosts view permission' do
    setup_user('view', 'config_reports')
    report = FactoryGirl.create(:config_report)
    get :show, params: { :id => 'last', :host_id => report.host.id }, session: set_session_user.merge(:user => User.current.id)
    assert_response :not_found
  end

  private

  def create_a_report
    @report = ConfigReport.import(read_json_fixture('reports/empty.json'))
  end
end
