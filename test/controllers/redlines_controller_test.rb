require 'test_helper'

class RedlinesControllerTest < ActionController::TestCase
  setup do
    @redline = redlines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:redlines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create redline" do
    assert_difference('Redline.count') do
      post :create, redline: { document_id: @redline.document_id, key: @redline.key, user_id: @redline.user_id }
    end

    assert_redirected_to redline_path(assigns(:redline))
  end

  test "should show redline" do
    get :show, id: @redline
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @redline
    assert_response :success
  end

  test "should update redline" do
    patch :update, id: @redline, redline: { document_id: @redline.document_id, key: @redline.key, user_id: @redline.user_id }
    assert_redirected_to redline_path(assigns(:redline))
  end

  test "should destroy redline" do
    assert_difference('Redline.count', -1) do
      delete :destroy, id: @redline
    end

    assert_redirected_to redlines_path
  end
end
