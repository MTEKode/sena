module SubscriptionsHelper
  def sec_to_month(sec)
    sec_per_min = 60
    sec_per_hour = 60 * sec_per_min
    sec_per_day = 24 * sec_per_hour
    sec_per_month = 30 * sec_per_day

    months = sec / sec_per_month

    months
  end

  def sec_to_month_str(sec)
    months = sec_to_month(sec)
    "#{months} #{months > 1 ? 'meses' : 'mes'}"
  end
end
