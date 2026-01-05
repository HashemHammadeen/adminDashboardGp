class AuditLogsController < ApplicationController
  before_action :authenticate_mall_admin!
  load_and_authorize_resource
  def index
  end

  def show
  end
end
