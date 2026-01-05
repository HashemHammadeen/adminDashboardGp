require "test_helper"

class MallsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get malls_index_url
    assert_response :success
  end

  test "should get show" do
    get malls_show_url
    assert_response :success
  end

  test "should get new" do
    get malls_new_url
    assert_response :success
  end

  test "should get create" do
    get malls_create_url
    assert_response :success
  end

  test "should get edit" do
    get malls_edit_url
    assert_response :success
  end

  test "should get update" do
    get malls_update_url
    assert_response :success
  end

  test "should get destroy" do
    get malls_destroy_url
    assert_response :success
  end
end
