class EmotiController < ApplicationController

  def index
    @emotis = current_user.active_emotis
  end

  def selection
    @emotis = Emoti.actives
  end
end
