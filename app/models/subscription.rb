class Subscription
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: StringifiedSymbol
  field :name, type: String
  field :description, type: String
  field :price, type: Float
  field :duration, type: Integer, default: 1.month.to_i
  field :active, type: Boolean, default: true
  field :features, type: Array, default: []

  scope :active, -> { where(active: true) }

  validates_presence_of :type, :name, :price, :duration
  validates_uniqueness_of :type
end
