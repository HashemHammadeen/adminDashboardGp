require "test_helper"

class AuditLogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audit_logs_index_url
    assert_response :success
  end

  test "should get show" do
    get audit_logs_show_url
    assert_response :success
  end
end
