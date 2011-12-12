require 'test_helper'

class SocialAppsControllerTest < ActionController::TestCase
  setup do
    @social_app = social_apps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:social_apps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create social_app" do
    assert_difference('SocialApp.count') do
      post :create, social_app: @social_app.attributes
    end

    assert_redirected_to social_app_path(assigns(:social_app))
  end

  test "should show social_app" do
    get :show, id: @social_app.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @social_app.to_param
    assert_response :success
  end

  test "should update social_app" do
    put :update, id: @social_app.to_param, social_app: @social_app.attributes
    assert_redirected_to social_app_path(assigns(:social_app))
  end

  test "should destroy social_app" do
    assert_difference('SocialApp.count', -1) do
      delete :destroy, id: @social_app.to_param
    end

    assert_redirected_to social_apps_path
  end
end
