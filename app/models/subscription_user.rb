class SubscriptionUser
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  # Campos denormalizados de Subscription
  field :subscription_type, type: StringifiedSymbol
  field :subscription_name, type: String
  field :subscription_price, type: Float
  field :subscription_duration, type: Integer

  field :emoti_ids, type: Array, default: []

  # Campos originales de SubscriptionUser
  field :until, type: Date
  field :renewable, type: Boolean, default: true
  field :affiliate_key, type: String
  field :paid_at, type: Date, default: false

  # Validaciones
  validates_presence_of :subscription_type, :subscription_name, :subscription_duration, :until

  def self.from_subscription(subscription)
    new(
      subscription_type: subscription.type,
      subscription_name: subscription.name,
      subscription_price: subscription.price,
      subscription_duration: subscription.duration,
      until: Date.today + subscription.duration.days,
      renewable: true,
      paid_at: nil
    )
  end

  def update_emoti_ids(new_emoti_ids)
    self.emoti_ids.concat(new_emoti_ids)
    self.emoti_ids.map!(&:to_s).uniq
    self.save!
  end
end