require "test_helper"

class MindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mind = minds(:one)
  end

  test "should get index" do
    get minds_url
    assert_response :success
  end

  test "should get new" do
    get new_mind_url
    assert_response :success
  end

  test "should create mind" do
    assert_difference("Mind.count") do
      post minds_url, params: { mind: { name: @mind.name, no: @mind.no } }
    end

    assert_redirected_to mind_url(Mind.last)
  end

  test "should show mind" do
    get mind_url(@mind)
    assert_response :success
  end

  test "should get edit" do
    get edit_mind_url(@mind)
    assert_response :success
  end

  test "should update mind" do
    patch mind_url(@mind), params: { mind: { name: @mind.name, no: @mind.no } }
    assert_redirected_to mind_url(@mind)
  end

  test "should destroy mind" do
    assert_difference("Mind.count", -1) do
      delete mind_url(@mind)
    end

    assert_redirected_to minds_url
  end
end
