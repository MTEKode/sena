class HomeController < ApplicationController
  def index
    @emotis = Emoti.actives
    @main_amoti = @emotis.sample
  end
end
