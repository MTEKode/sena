class HomeController < ApplicationController
  before_action :redirect_to_dashboard
  def index
    @emotis = Emoti.actives
    @main_amoti = @emotis.sample
  end

  def redirect_to_dashboard
    redirect_to dashboard_index_path if user_signed_in?
  end
end
