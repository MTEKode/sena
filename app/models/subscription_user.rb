class SubscriptionUser
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :subscription


  field :until, type: Time
  field :renewable, type: Boolean
  field :affiliate_key, type: String
  field :paid, type: Float
end
