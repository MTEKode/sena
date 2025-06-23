class ChatController < ApplicationController

  def show
    initialize_chat
  end

  def create
    load_chat
    response = @chat.send_message(message_params[:content])
    if @chat.save!
      render json: { message: response, sender: 'user' }, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
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
    @chat = current_user.chats.find_or_create_by!(emoti_id: emoti_params[:id])
  end

  def load_chat
    @chat = Chat.find_by(chat_params.to_h)
  end
end
