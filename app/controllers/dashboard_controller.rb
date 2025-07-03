class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @emotis ||= helpers.load_current_user_emotis
  end
end
