class PagesController < ApplicationController
  include ApplicationHelper

  def home
    @mentions = Mention.find_by_sql("
      SELECT
        count(m.stock_id) AS count,
        s.symbol,
        s.name
      FROM
        mention m
        JOIN stock s ON m.stock_id = s.id
      WHERE
        date(m.dt) = '#{time_now_zone_to_date}'
      GROUP BY
        s.symbol,
        s.name
      ORDER BY
        (count(m.stock_id)) DESC
        LIMIT 20;
    ")
  end
end
