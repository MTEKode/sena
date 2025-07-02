class User
  include Mongoid::Document
  include Mongoid::Timestamps

  TYPES = %i[user affiliate admin].freeze

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  embeds_many :subscription_users
  accepts_nested_attributes_for :subscription_users

  has_many :chats

  ## Database authenticatable
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  field :full_name, type: String
  field :type, type: StringifiedSymbol, default: TYPES.first
  field :terms_accepted, type: Boolean

  validates :terms_accepted, acceptance: { accept: true }


  # Method to create a new subscription user
  def create_subscription_user(subscription_type)
    subscription = Subscription.find_by(type: subscription_type)
    return unless subscription

    self.subscription_users.build(subscription: subscription)
  end

  # Returns the first active subscription user.
  # @return [SubscriptionUser] the active subscription user
  def active_subscription
    self.subscription_users.where(:until.gt => Date.today).desc(:until).first
  end

  def active_emotis
    Emoti.actives.where(:id.in => active_subscription.emoti_ids) if active_subscription&.emoti_ids.present?
  end

  def find_last_chat
    self.chats.order(updated_at: :asc).last
  end
end
