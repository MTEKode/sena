module ApplicationHelper
  def load_current_user_emotis
    @emotis ||= current_user.active_emotis
  end
end
