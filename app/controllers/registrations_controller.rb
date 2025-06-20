class RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def create
    super do |resource|
      if resource.persisted?
        subscription_type = params.dig(:user, :subscription_type)
        if subscription_type.present?
          subscription = Subscription.find_by(type: subscription_type)
          if subscription
            subscription_user = SubscriptionUser.from_subscription(subscription)
            subscription_user.affiliate_key = params.dig(:user, :affiliate_key) if params.dig(:user, :affiliate_key).present?
            resource.subscription_users << subscription_user
            resource.save!
          end
        end
      end
    end
  end

  protected

  def configure_sign_up_params
    params.require(:user).permit(:affiliate_key, :subscription_type)
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :email, :password, :password_confirmation, :terms_accepted])
  end
end