require "test_helper"

class EarnTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get earn_transactions_index_url
    assert_response :success
  end

  test "should get show" do
    get earn_transactions_show_url
    assert_response :success
  end
end
