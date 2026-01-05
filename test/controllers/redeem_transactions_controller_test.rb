require "test_helper"

class RedeemTransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get redeem_transactions_index_url
    assert_response :success
  end

  test "should get show" do
    get redeem_transactions_show_url
    assert_response :success
  end
end
