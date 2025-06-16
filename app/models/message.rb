class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String

  embedded_in :chat
end
