class SubscriptionUser
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :subscription


  field :until, type: Date, default: -> { Date.today + subscription.duration }
  field :renewable, type: Boolean, default: true
  field :affiliate_key, type: String
  field :paid, type: Float
end
