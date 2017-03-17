module ReportHostPermissionsTest
  extend ActiveSupport::Concern
  included do
    context 'when user does not have permission to view hosts' do
      setup { setup_user('view', 'config_reports') }

      test 'cannot view any reports' do
        report = FactoryGirl.create(:config_report)
        get :show, params: { :id => report.id }, session: set_session_user.merge(:user => User.current.id)
        assert_response :not_found
      end

      test 'cannot delete host reports' do
        setup_user 'destroy', 'config_reports'
        report = FactoryGirl.create(:config_report)
        delete :destroy, params: { :id => report.id }, session: set_session_user.merge(:user => User.current.id)
        assert_response :not_found
      end
    end
  end
end
