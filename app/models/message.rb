class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :sender, type: StringifiedSymbol

  embedded_in :chat
end
