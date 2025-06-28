class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :emoti

  embeds_many :messages

  def send_message(msg)
    self.messages.create!(content: msg, role: :user)
    response = MessageSender.new(self).send_message(msg)
    self.messages.create!(content: response, role: :assistant)
    response
  rescue StandardError => e
    raise "Failed to send message: #{e.message}"
  end
end
