class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @emotis = Emoti.actives
  end
end
