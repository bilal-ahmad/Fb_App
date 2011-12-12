require 'test_helper'

class SocialPostsControllerTest < ActionController::TestCase
  setup do
    @social_post = social_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:social_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create social_post" do
    assert_difference('SocialPost.count') do
      post :create, social_post: @social_post.attributes
    end

    assert_redirected_to social_post_path(assigns(:social_post))
  end

  test "should show social_post" do
    get :show, id: @social_post.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @social_post.to_param
    assert_response :success
  end

  test "should update social_post" do
    put :update, id: @social_post.to_param, social_post: @social_post.attributes
    assert_redirected_to social_post_path(assigns(:social_post))
  end

  test "should destroy social_post" do
    assert_difference('SocialPost.count', -1) do
      delete :destroy, id: @social_post.to_param
    end

    assert_redirected_to social_posts_path
  end
end
