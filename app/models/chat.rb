class Chat
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :emoti

  embeds_many :message
end
