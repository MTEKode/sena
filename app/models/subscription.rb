class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :subscription_users

  field :type, type: Symbol
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :duration, type: Integer, default: 1.month.to_i
  field :active, type: Boolean, default: true
  field :features, type: Array, default: []

  scope :active, -> { where(active: true) }

end
