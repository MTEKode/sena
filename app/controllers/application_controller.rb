class ApplicationController < ActionController::Base
  # Solo permite navegadores modernos que soportan webp images, web push, badges, import maps, CSS nesting, y CSS :has.
  allow_browser versions: :modern
  helper :all

  def after_sign_in_path_for(resource_or_scope)
    chat_path('last')
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
