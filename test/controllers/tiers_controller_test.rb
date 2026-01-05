require "test_helper"

class TiersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tiers_index_url
    assert_response :success
  end

  test "should get show" do
    get tiers_show_url
    assert_response :success
  end

  test "should get new" do
    get tiers_new_url
    assert_response :success
  end

  test "should get create" do
    get tiers_create_url
    assert_response :success
  end

  test "should get edit" do
    get tiers_edit_url
    assert_response :success
  end

  test "should get update" do
    get tiers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get tiers_destroy_url
    assert_response :success
  end
end
