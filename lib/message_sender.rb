class MessageSender
  def initialize(emoti)
    @emoti = emoti
  end

  def send_message(message)
    client.send_message(message)
  end

  private

  def client
    @client ||= ChatApi::Gpt::PsychologyClient.new(@emoti)
  end
end