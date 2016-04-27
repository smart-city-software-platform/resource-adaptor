require 'test_helper'

class BasicResourcesControllerTest < ActionController::TestCase
  setup do
    @basic_resource = basic_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:basic_resources)
  end

  test "should create basic_resource" do
    assert_difference('BasicResource.count') do
      post :create, basic_resource: {  }
    end

    assert_response 201
  end

  test "should show basic_resource" do
    get :show, id: @basic_resource
    assert_response :success
  end

  test "should update basic_resource" do
    put :update, id: @basic_resource, basic_resource: {  }
    assert_response 204
  end

  test "should destroy basic_resource" do
    assert_difference('BasicResource.count', -1) do
      delete :destroy, id: @basic_resource
    end

    assert_response 204
  end
end
