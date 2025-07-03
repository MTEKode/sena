class ChatController < ApplicationController
  before_action :authenticate_user!

  def show
    redirect_to selection_emoti_index_path if current_user.active_emotis.blank?
    initialize_chat
  end

  def create
    load_chat
    @response = @chat.send_message(message_params[:content])
    @chat.save!
  end

  private
  def emoti_params
    params.permit(:id)
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def chat_params
    params.require(:chat).permit(:id)
  end

  def initialize_chat
    return @chat = current_user.find_last_chat if emoti_params[:id].present? && emoti_params[:id] == 'last'
    @chat = current_user.chats.find_or_create_by!(emoti_id: emoti_params[:id])
  end

  def load_chat
    @chat = Chat.find_by(chat_params.to_h)
  end

end
