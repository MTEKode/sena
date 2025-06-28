class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :role, type: StringifiedSymbol

  embedded_in :chat
end
