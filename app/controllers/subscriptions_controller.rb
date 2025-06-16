class SubscriptionsController < ApplicationController
  def index
    @subscriptions = Subscription.active
  end

  def new
    @subscription = Subscription.new
  end
end
