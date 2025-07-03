class EmotiController < ApplicationController

  def index
    helpers.load_current_user_emotis
  end

  def selection
    @emotis = Emoti.actives
  end
end
