class Emoti
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :chats

  field :name, type: String
  field :title, type: String
  field :quote, type: String
  field :description, type: String
  field :prompt, type: String
  field :key, type: String
  field :active, type: Boolean, default: true

  validates_uniqueness_of :key

  scope :actives, -> { where(active: true) }

end
