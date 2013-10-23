require 'test_helper'

class Api::TestableController < Api::BaseController

  def index
    render :text => 'dummy', :status => 200
  end

end

class Api::TestableControllerTest < ActionController::TestCase
  tests Api::TestableController

  context "api base headers" do
    test "should contain version in headers" do
      get :index
      puts @response.headers.inspect
      assert_true @response.headers["Foreman_version"].index /\d+\.\d+/
    end
  end

end
