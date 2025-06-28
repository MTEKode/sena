class EmotiController < ApplicationController

  def index
    @emotis = Emoti.active_emotis
  end

  def selection
    @emotis = Emoti.actives
  end
end
