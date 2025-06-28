class MessageSender
  def initialize(chat)
    @chat = chat
  end

  def send_message(message)
    client.send_message(message)
  end

  private

  def client
    @client ||= ChatApi::Gpt::PsychologyClient.new(@chat)
  end
end