class EmotiQuestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :order, :type => Integer
  field :key, :type => String
  field :answer_keys, :type => Array
  field :active, type: Boolean, default: true

  validates_uniqueness_of :key

  scope :active, -> { where(active: true) }
end
