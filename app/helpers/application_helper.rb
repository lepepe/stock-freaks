module ApplicationHelper
  def time_now_zone_to_date
    Time.now.in_time_zone('Eastern Time (US & Canada)').to_date
  end
end
